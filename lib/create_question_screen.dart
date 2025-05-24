import 'package:flutter/material.dart';
import 'package:heart_beat/question_model.dart';
import 'package:heart_beat/question_repo.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateQuestionScreen extends StatefulWidget {
  const CreateQuestionScreen({super.key});

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _optionAController = TextEditingController();
  final _optionBController = TextEditingController();
  QuestionIntensity _intensity = QuestionIntensity.flirty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Question'),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Would you rather...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _optionAController,
                decoration: const InputDecoration(
                  labelText: 'Option A',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option A';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _optionBController,
                decoration: const InputDecoration(
                  labelText: 'Option B',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option B';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<QuestionIntensity>(
                value: _intensity,
                items: QuestionIntensity.values.map((intensity) {
                  return DropdownMenuItem(
                    value: intensity,
                    child: Text(
                      intensity.name.toUpperCase(),
                      style: TextStyle(
                        color: _getIntensityColor(intensity),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _intensity = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Intensity Level',
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submitQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'SAVE QUESTION',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitQuestion() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final newQuestion = WYRQuestion(
        id: const Uuid().v4(),
        questionText: _questionController.text,
        optionA: _optionAController.text,
        optionB: _optionBController.text,
        intensity: _intensity,
      );

      await Provider.of<QuestionRepository>(context, listen: false)
          .saveCustomQuestion(newQuestion);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving question: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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