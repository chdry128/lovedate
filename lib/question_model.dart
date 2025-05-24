import 'package:hive/hive.dart';

part 'question_model.g.dart';

@HiveType(typeId: 0)
enum QuestionIntensity {
  @HiveField(0)
  sweet,
  @HiveField(1)
  flirty,
  @HiveField(2)
  dirty
}

@HiveType(typeId: 1)
class WYRQuestion {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String questionText;
  @HiveField(2)
  final String optionA;
  @HiveField(3)
  final String optionB;
  @HiveField(4)
  final QuestionIntensity intensity;
  @HiveField(5)
  final String? explanation;

  WYRQuestion({
    required this.id,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.intensity,
    this.explanation,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': questionText,
    'option_a': optionA,
    'option_b': optionB,
    'intensity': intensity.name,
    if (explanation != null) 'explanation': explanation,
  };

  factory WYRQuestion.fromJson(Map<String, dynamic> json) => WYRQuestion(
    id: json['id'] as String,
    questionText: json['question'] as String,
    optionA: json['option_a'] as String,
    optionB: json['option_b'] as String,
    intensity: QuestionIntensity.values.firstWhere(
      (e) => e.name == json['intensity'],
      orElse: () => QuestionIntensity.flirty,
    ),
    explanation: json['explanation'] as String?,
  );
}