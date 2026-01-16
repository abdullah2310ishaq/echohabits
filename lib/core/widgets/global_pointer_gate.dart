import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// Put this above your MaterialApp/GetMaterialApp.
/// It lets the first finger through and cancels any other simultaneous taps.
class GlobalPointerGate extends StatefulWidget {
  final Widget child;
  const GlobalPointerGate({super.key, required this.child});

  @override
  State<GlobalPointerGate> createState() => _GlobalPointerGateState();
}

class _GlobalPointerGateState extends State<GlobalPointerGate> {
  int? _activePointer; // the pointer id we're allowing

  void _onPointerDown(PointerDownEvent e) {
    if (_activePointer == null) {
      _activePointer = e.pointer; // first finger wins
    } else {
      // Cancel any additional tap immediately so it never reaches buttons
      GestureBinding.instance.cancelPointer(e.pointer);
    }
  }

  void _onPointerUpOrCancel(PointerEvent e) {
    if (_activePointer == e.pointer) {
      _activePointer = null; // release when the first finger lifts/cancels
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUpOrCancel,
      onPointerCancel: _onPointerUpOrCancel,
      child: widget.child,
    );
  }
}
