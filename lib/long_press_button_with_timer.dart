library long_press_button_with_timer;

import 'dart:async';
import 'package:flutter/material.dart';

// ButtonStyleButton
// OutlinedButton, ElevatedButton, TextButton

// ignore: must_be_immutable
class LongPressButtonWithTimer extends StatefulWidget {
  /// The Base button widget
  /// This should be one of [ElevatedButton], [OutlinedButton], [TextButton]
  final Widget child;

  // /// This should be one of [ElevatedButton], [OutlinedButton], [TextButton]
  // final ButtonThemeData buttonThemeData;

  /// Write your onLongPress function here.
  /// CAUTION: DO NOT WRITE [onLongPress] in [buttonWidget]
  /// if null, use the basic button widget, not this
  final VoidCallback onLongPress;

  /// Duration to activate function of [onLongPress]
  final Duration durationToActive;

  /// The count down of timer is [Duration] to zero, Default [true]
  final bool countToZero;

  /// The visibility of count down timer, Default [true]
  final bool visibility;

  const LongPressButtonWithTimer({
    Key? key,
    required this.child,
    required this.onLongPress,
    // required this.buttonThemeData,
    this.durationToActive = const Duration(seconds: 3),
    this.countToZero = true,
    this.visibility = true,
  }) : // assert(this.child == ElevatedButton),
        super(key: key);

  @override
  _LongPressButtonWithTimerState createState() =>
      _LongPressButtonWithTimerState();
}

class _LongPressButtonWithTimerState extends State<LongPressButtonWithTimer> {
  Timer? _timer;
  int _counter = 0;

  @override
  void initState() {
    _startTimer();
    widget.controller?._addListeners(_startTimer, _loading, _enableButton);
    super.initState();
  }

  _startTimer() {
    _timer?.cancel();
    _state = ButtonState.timer;
    _counter = widget.duration;

    setState(() {});

    _timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (_counter == 0) {
          _state = ButtonState.enable_button;
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _counter--;
          });
        }
      },
    );
  }

  _childBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.child,
        const SizedBox(width: 10),
        Text('$_counter'),
      ],
    );
  }

  _child() {
    return GestureDetector(
      child: (!widget.visibility) ? widget.child : _childBuilder(),
      onLongPressStart: (details) => _startTimer(),
      onLongPressCancel: () {},
      onLongPressEnd: ((details) {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _child();
  }
}

class timerButton {
  late VoidCallback _startTimerListener;
  late VoidCallback _loadingListener;
  late VoidCallback _enableButtonListener;

  _addListeners(startTimerListener, loadingListener, enableButtonListener) {
    this._startTimerListener = startTimerListener;
    this._loadingListener = loadingListener;
    this._enableButtonListener = enableButtonListener;
  }

  /// Notify listener to start the timer
  startTimer() {
    _startTimerListener();
  }

  /// Notify listener to show loading
  loading() {
    _loadingListener();
  }

  /// Notify listener to enable button
  enableButton() {
    _enableButtonListener();
  }
}
