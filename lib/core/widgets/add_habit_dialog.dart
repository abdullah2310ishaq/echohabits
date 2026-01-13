import 'package:flutter/material.dart';

class AddHabitDialog extends StatelessWidget {
  final String habitTitle;
  final String difficulty;
  final Color difficultyColor;
  final String impact;
  final Color impactColor;
  final VoidCallback? onAdd;

  const AddHabitDialog({
    super.key,
    required this.habitTitle,
    required this.difficulty,
    required this.difficultyColor,
    required this.impact,
    required this.impactColor,
    this.onAdd,
  });

  static void show(
    BuildContext context, {
    required String habitTitle,
    required String difficulty,
    required Color difficultyColor,
    required String impact,
    required Color impactColor,
    VoidCallback? onAdd,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AddHabitDialog(
        habitTitle: habitTitle,
        difficulty: difficulty,
        difficultyColor: difficultyColor,
        impact: impact,
        impactColor: impactColor,
        onAdd: onAdd,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main Title
              const Text(
                'Add this habit to your routine?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Habit Name (in green)
              Text(
                habitTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Metadata Row (Difficulty & Impact)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Difficulty Dot
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: difficultyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Difficulty Text
                  Text(
                    difficulty,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  // Impact Label
                  Text(
                    impact,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: impactColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description Text
              const Text(
                'You can track it daily on your home screen',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onAdd != null) {
                          onAdd!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
