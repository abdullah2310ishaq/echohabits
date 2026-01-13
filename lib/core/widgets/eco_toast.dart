import 'package:flutter/material.dart';

class EcoToast {
  static void show(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _EcoToastWidget(
        message: message,
        isSuccess: isSuccess,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class _EcoToastWidget extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const _EcoToastWidget({
    required this.message,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80, // Above the bottom navigation bar
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (isSuccess) ...[
                const SizedBox(width: 8),
                const Text(
                  '🔥',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
