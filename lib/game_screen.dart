import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heart_beat/question_card.dart';
import 'package:heart_beat/question_model.dart';
import 'package:heart_beat/question_repo.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/foundation.dart'; // Unused
import 'create_question_screen.dart';
import 'heart_rain.dart';
import 'theam.dart';

/// A screen that displays a game of "Would You Rather" questions for couples
class GameScreen extends StatefulWidget {
  /// Optional filter for question intensity
  final QuestionIntensity? intensityFilter;

  const GameScreen({super.key, this.intensityFilter});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game state
  List<WYRQuestion> _questions = [];
  int _currentIndex = 0;
  int _player1Score = 0;
  int _player2Score = 0;
  bool _isLoading = true;
  bool _hasAnswered = false;
  bool _showHeartAnimation = false;

  // Animation controllers
  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;

  // For smooth page transitions
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _scoreAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Initialize page controller for smooth transitions
    _pageController = PageController(initialPage: 0);

    // Load questions
    _loadQuestions();
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasAnswered = false;
    });

    try {
      final questionRepo = Provider.of<QuestionRepository>(
        context,
        listen: false,
      );
      final questions = await questionRepo.getQuestions(
        intensity: widget.intensityFilter,
        limit: 20,
      );

      if (mounted) {
        setState(() {
          _questions = questions..shuffle();
          _currentIndex = 0;
          _isLoading = false;

          // Reset page controller
          _pageController = PageController(initialPage: 0);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Error loading questions: $e');
      }
    }
  }

  Future<void> _deleteQuestion(String questionId) async {
    try {
      await Provider.of<QuestionRepository>(
        context,
        listen: false,
      ).deleteQuestion(questionId);
      await _loadQuestions();
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error deleting question: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  void _nextQuestion() {
    if (!mounted || _questions.isEmpty) return;

    final nextIndex =
        _currentIndex + 1 >= _questions.length ? 0 : _currentIndex + 1;

    // If we're going back to the beginning, shuffle questions
    if (nextIndex == 0) {
      setState(() {
        _questions.shuffle();
      });
    }

    // Animate to next page
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      _currentIndex = nextIndex;
      _hasAnswered = false;
    });
  }

  void _previousQuestion() {
    if (!mounted || _questions.isEmpty) return;

    final prevIndex =
        _currentIndex - 1 < 0 ? _questions.length - 1 : _currentIndex - 1;

    // Animate to previous page
    _pageController.animateToPage(
      prevIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      _currentIndex = prevIndex;
      _hasAnswered = false;
    });
  }

  void _submitAnswer(String selectedOption) {
    if (!mounted || _questions.isEmpty || _hasAnswered) return;

    // In real app, compare with partner's answer
    // For demo, randomly decide if answers matched
    final matched = Random().nextBool();

    setState(() {
      _hasAnswered = true;
      _showHeartAnimation = matched;

      if (matched) {
        _player1Score += 2;
        _player2Score += 2;
      } else {
        _player1Score += 1;
        _player2Score += 1;
      }
    });

    // Animate score
    _scoreAnimationController.forward().then((_) {
      _scoreAnimationController.reverse();
    });

    // Move to next question after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showHeartAnimation = false;
        });
        _nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Love Quiz'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadQuestions,
            tooltip: 'Load New Questions',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(gradient: AppTheme.secondaryGradient),
          ),

          // Heart animation (only shown when answers match)
          if (_showHeartAnimation) const HeartRainEffect(heartCount: 15),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildScoreBoard(),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateQuestionScreen()),
            ).then((_) => _loadQuestions()), // Refresh questions when returning
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Create New Question',
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No questions available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadQuestions,
              icon: const Icon(Icons.refresh),
              label: const Text('Load Questions'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Question cards with page view for smooth transitions
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics:
                  _hasAnswered
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
              itemCount: _questions.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _hasAnswered = false;
                });
              },
              itemBuilder: (context, index) {
                return QuestionCard(
                  key: ValueKey(_questions[index].id),
                  question: _questions[index],
                  onSubmit: _submitAnswer,
                  isAnswered: _hasAnswered && index == _currentIndex,
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(
                icon: Icons.arrow_back_rounded,
                onPressed: _previousQuestion,
                tooltip: 'Previous Question',
              ),
              _buildIconButton(
                icon: Icons.delete_outline_rounded,
                onPressed: () => _deleteQuestion(_questions[_currentIndex].id),
                tooltip: 'Delete Question',
              ),
              _buildIconButton(
                icon: Icons.arrow_forward_rounded,
                onPressed: _nextQuestion,
                tooltip: 'Next Question',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPlayerScore('You', _player1Score, Colors.pink[800]!),
          const Text('❤️', style: TextStyle(fontSize: 30)),
          _buildPlayerScore('Partner', _player2Score, Colors.purple[800]!),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        ScaleTransition(
          scale: _scoreAnimation,
          child: Text(
            '$score',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Tooltip(
          message: tooltip,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 24),
          ),
        ),
      ),
    );
  }
}
