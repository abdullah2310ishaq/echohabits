import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';

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
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main Title
              Text(
                AppLocalizations.of(context)!.addThisHabitToYourRoutine,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),

              // Habit Name (in green)
              Text(
                habitTitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),

              // Metadata Row (Difficulty & Impact)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Difficulty Dot
                  Container(
                    width: 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: difficultyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Difficulty Text
                  Text(
                    difficulty,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                  SizedBox(width: 12.w),
                  // Impact Label
                  Text(
                    impact,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: impactColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Description Text
              Text(
                AppLocalizations.of(
                  context,
                )!.youCanTrackItDailyOnYourHomeScreen,
                style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14.h),

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
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
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
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.add,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
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
