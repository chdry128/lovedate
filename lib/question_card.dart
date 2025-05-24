import 'package:flutter/material.dart';
import 'package:heart_beat/question_model.dart';

import 'option_button.dart';

class QuestionCard extends StatelessWidget {
  final WYRQuestion question;
  final Function(String) onSubmit;
  final bool isAnswered;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onSubmit,
    this.isAnswered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade50,
              Colors.purple.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Question text
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Options
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OptionButton(
                    text: question.optionA,
                    onTap: isAnswered ? null : () => onSubmit(question.optionA),
                    color: Colors.pink,
                  ),
                  const Text('OR', style: TextStyle(fontSize: 18)),
                  OptionButton(
                    text: question.optionB,
                    onTap: isAnswered ? null : () => onSubmit(question.optionB),
                    color: Colors.purple,
                  ),
                ],
              ),
            ),

            // Intensity indicator
            Chip(
              label: Text(
                question.intensity.name.toUpperCase(),
                style: TextStyle(
                  color: _getIntensityColor(question.intensity),
                ),
              ),
              backgroundColor: _getIntensityColor(question.intensity)
                  .withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }

  Color _getIntensityColor(QuestionIntensity intensity) {
    switch (intensity) {
      case QuestionIntensity.sweet:
        return Colors.blue;
      case QuestionIntensity.flirty:
        return Colors.pink;
      case QuestionIntensity.dirty:
        return Colors.red;
    }
  }
}