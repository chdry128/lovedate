import 'package:heart_beat/question_model.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';

/// Repository for managing "Would You Rather" questions
/// Handles fetching, caching, and managing questions
class QuestionRepository {
  // API constants
  static const String _apiUrl =
      'https://integrate.api.nvidia.com/v1/chat/completions';
  static const String _apiKey =
      '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';
  static const String _modelName = 'meta/llama-4-maverick-17b-128e-instruct';

  // Cache keys
  static const String _questionsKey = 'last_questions';
  static const String _timestampKey = 'last_fetch_timestamp';

  // Cache duration (12 hours)
  static const Duration _cacheDuration = Duration(hours: 12);

  // HTTP client with optimized settings
  final Dio _dio;
  late final Box _localStorage;

  // Constructor with dependency injection for better testability
  QuestionRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            ),
          ) {
    _localStorage = Hive.box('wyrQuestions');

    // Add interceptor for better error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          debugPrint('API Error: ${e.message}');
          handler.next(e);
        },
      ),
    );
  }

  /// Get questions with optional intensity filter and limit
  Future<List<WYRQuestion>> getQuestions({
    QuestionIntensity? intensity,
    int limit = 10,
    bool forceRefresh = false,
  }) async {
    try {
      // Check if we should use cached questions
      if (!forceRefresh) {
        final localQuestions = _getLocalQuestions(
          intensity: intensity,
          limit: limit,
        );

        // If we have local questions and the cache is still valid, return them
        final lastFetchTime =
            _localStorage.get(_timestampKey, defaultValue: 0) as int;
        final cacheIsValid =
            DateTime.now().millisecondsSinceEpoch - lastFetchTime <
            _cacheDuration.inMilliseconds;

        if (localQuestions.isNotEmpty && cacheIsValid) {
          return localQuestions;
        }
      }

      // If no valid local questions or force refresh, try to fetch from API
      return await _fetchQuestionsFromApi(intensity, limit);
    } catch (e) {
      debugPrint('Error in getQuestions: $e');
      // Fallback to local questions in case of any error
      return _getLocalQuestions(intensity: intensity, limit: limit);
    }
  }

  /// Fetch questions from the API
  Future<List<WYRQuestion>> _fetchQuestionsFromApi(
    QuestionIntensity? intensity,
    int limit,
  ) async {
    try {
      final response = await _dio.post(
        _apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "model": _modelName,
          "messages": [
            {
              "role": "user",
              "content":
                  "Generate $limit would you rather questions for couples with "
                  "${intensity?.name ?? 'flirty'} intensity. "
                  "Return ONLY a JSON array (no other text) with each question having these fields: id (string), question (string), option_a (string), option_b (string), intensity (one of: sweet, flirty, dirty), explanation (string). "
                  "Make the questions fun and engaging for couples.",
            },
          ],
          "max_tokens": 2000,
          "temperature": 1.0,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'];
        final questions = await compute(
          _parseQuestions,
          content.toString().trim(),
        );

        if (questions.isNotEmpty) {
          // Cache the questions and update timestamp
          await _cacheQuestions(questions);
          await _localStorage.put(
            _timestampKey,
            DateTime.now().millisecondsSinceEpoch,
          );

          // Filter by intensity if needed
          return questions
              .where((q) => intensity == null || q.intensity == intensity)
              .take(limit)
              .toList();
        }
      }

      // If we get here, something went wrong with the API
      throw Exception('Failed to fetch valid questions from API');
    } catch (e) {
      debugPrint('API fetch error: $e');
      // Return local questions as fallback
      return _getLocalQuestions(intensity: intensity, limit: limit);
    }
  }

  /// Parse questions in an isolate for better performance
  static List<WYRQuestion> _parseQuestions(String content) {
    try {
      if (!content.startsWith('[')) {
        debugPrint('Invalid JSON response format');
        return [];
      }

      final questionsData = jsonDecode(content);
      if (questionsData is! List) {
        debugPrint('Response is not a list');
        return [];
      }

      return questionsData
          .map((q) {
            try {
              if (q is! Map<String, dynamic>) {
                return null;
              }
              return WYRQuestion.fromJson(q);
            } catch (e) {
              debugPrint('Error parsing question: $e');
              return null;
            }
          })
          .whereType<WYRQuestion>()
          .toList();
    } catch (e) {
      debugPrint('Error parsing API response: $e');
      return [];
    }
  }

  /// Save a custom question
  Future<void> saveCustomQuestion(WYRQuestion question) async {
    final questions = _getLocalQuestions();
    questions.add(question);
    await _cacheQuestions(questions);
  }

  /// Delete a question by ID
  Future<void> deleteQuestion(String questionId) async {
    final questions = _getLocalQuestions();
    questions.removeWhere((q) => q.id == questionId);
    await _cacheQuestions(questions);
  }

  /// Cache questions to local storage
  Future<void> _cacheQuestions(List<WYRQuestion> questions) async {
    await _localStorage.put(
      _questionsKey,
      questions.map((q) => q.toJson()).toList(),
    );
  }

  /// Get questions from local storage
  List<WYRQuestion> _getLocalQuestions({
    QuestionIntensity? intensity,
    int limit = 10,
  }) {
    try {
      final rawQuestions =
          _localStorage.get(_questionsKey, defaultValue: []) as List;
      final allQuestions =
          rawQuestions
              .map((q) {
                try {
                  if (q is! Map<String, dynamic>) {
                    return null;
                  }
                  return WYRQuestion.fromJson(q);
                } catch (e) {
                  debugPrint('Error parsing stored question: $e');
                  return null;
                }
              })
              .whereType<WYRQuestion>()
              .toList();

      if (allQuestions.isEmpty) {
        // Add default questions if none exist
        final defaultQuestions = _getDefaultQuestions();
        _cacheQuestions(defaultQuestions);
        return defaultQuestions
            .where((q) => intensity == null || q.intensity == intensity)
            .take(limit)
            .toList();
      }

      return allQuestions
          .where((q) => intensity == null || q.intensity == intensity)
          .take(limit)
          .toList();
    } catch (e) {
      debugPrint('Error getting local questions: $e');
      return _getDefaultQuestions()
          .where((q) => intensity == null || q.intensity == intensity)
          .take(limit)
          .toList();
    }
  }

  /// Get default questions as fallback
  List<WYRQuestion> _getDefaultQuestions() {
    return [
      WYRQuestion(
        id: '1',
        questionText:
            'Would you rather have a romantic candlelit dinner at home or go out to a fancy restaurant?',
        optionA: 'Candlelit dinner at home',
        optionB: 'Fancy restaurant',
        intensity: QuestionIntensity.sweet,
        explanation:
            'This question helps understand your preferred romantic setting.',
      ),
      WYRQuestion(
        id: '2',
        questionText:
            'Would you rather slow dance in the rain or watch a sunset together?',
        optionA: 'Slow dance in the rain',
        optionB: 'Watch a sunset',
        intensity: QuestionIntensity.flirty,
        explanation: 'This question reveals your romantic style.',
      ),
      WYRQuestion(
        id: '3',
        questionText:
            'Would you rather cuddle on the couch or go for a romantic walk?',
        optionA: 'Cuddle on the couch',
        optionB: 'Romantic walk',
        intensity: QuestionIntensity.sweet,
        explanation:
            'This question shows your preferred way of spending quality time.',
      ),
      WYRQuestion(
        id: '4',
        questionText:
            'Would you rather have a surprise weekend getaway or a thoughtfully planned vacation?',
        optionA: 'Surprise weekend getaway',
        optionB: 'Thoughtfully planned vacation',
        intensity: QuestionIntensity.sweet,
        explanation:
            'This reveals your preference for spontaneity versus planning in your relationship.',
      ),
      WYRQuestion(
        id: '5',
        questionText:
            'Would you rather share a passionate kiss in the rain or under the stars?',
        optionA: 'Kiss in the rain',
        optionB: 'Kiss under the stars',
        intensity: QuestionIntensity.flirty,
        explanation:
            'This shows your romantic preference for memorable moments.',
      ),
    ];
  }
}
