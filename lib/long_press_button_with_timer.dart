library long_press_button_with_timer;

import 'dart:async';

import 'package:flutter/material.dart';

class LongPressButtonWithTimer extends StatefulWidget {
  /// The Base button widget
  /// This should be one of [ElevatedButton], [OutlinedButton], [TextButton]
  // final Widget child;
  final Widget child;

  /// Write your onLongPress function here.
  /// CAUTION: DO NOT WRITE [onLongPress] in [button]
  /// if null, use the basic button widget, not this
  final VoidCallback afterLongPress;

  /// Duration to activate function of [onLongPress]
  final int seconds;

  /// The initial visibility of timer
  final bool initialVisible;

  /// The count down of timer is [Duration] to zero, Default [true]
  final bool countToZero;

  /// The visibility of count down timer, Default [true]
  final bool countVisibility;

  /// The color of button when pressed
  final Color onPressedColor;

  /// Define the location of timer text
  final Axis axis;

  const LongPressButtonWithTimer({
    Key? key,
    required this.child,
    required this.afterLongPress,
    this.seconds = 3,
    this.initialVisible = false,
    this.countToZero = true,
    this.countVisibility = true,
    this.onPressedColor = Colors.grey,
    this.axis = Axis.vertical,
  }) : super(key: key);

  @override
  _LongPressButtonWithTimerState createState() =>
      _LongPressButtonWithTimerState();
}

class _LongPressButtonWithTimerState extends State<LongPressButtonWithTimer> {
  late Widget buttonChild;
  late VoidCallback? origianlOnTap;
  late int _counter;
  late Type _buttonType;
  late bool _initialVisible;
  Timer? _timer;
  late bool _counting;

  @override
  void initState() {
    _counter = widget.seconds;
    _buttonType = widget.child.runtimeType;
    _initialVisible = widget.initialVisible;
    _counting = false;

    if (_buttonType == ElevatedButton) {
      ElevatedButton originalButton = widget.child as ElevatedButton;
      buttonChild = originalButton.child!;
      origianlOnTap = originalButton.onPressed;
    } else if (_buttonType == TextButton) {
      TextButton originalButton = widget.child as TextButton;
      buttonChild = originalButton.child!;
      origianlOnTap = originalButton.onPressed;
    } else if (_buttonType == OutlinedButton) {
      OutlinedButton originalButton = widget.child as OutlinedButton;
      buttonChild = originalButton.child!;
      origianlOnTap = originalButton.onPressed;
    } else {
      throw TypeError;
    }

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _counting = false;
    super.dispose();
  }

  /// Make row or column with button & count-down timer
  _makeRowColumn(Widget? inherited, String counter) {
    if (widget.axis == Axis.vertical) {
      return Column(
        children: [inherited ?? const SizedBox(), Text(counter.toString())],
      );
    } else {
      return Row(
        children: [inherited ?? const SizedBox(), Text(counter.toString())],
      );
    }
  }

  /// Make Button with count-down timer
  _button(int counter) {
    if (_buttonType == ElevatedButton) {
      ElevatedButton originalButton = widget.child as ElevatedButton;
      if (_initialVisible || (counter != widget.seconds)) {
        return ElevatedButton(
            onPressed: () {},
            child: _makeRowColumn(originalButton.child, counter.toString()));
      } else {
        return ElevatedButton(
            onPressed: () {},
            child: _makeRowColumn(originalButton.child, counter.toString()));
      }
    } else if (_buttonType == TextButton) {
      TextButton originalButton = widget.child as TextButton;
      if (_initialVisible || (counter != widget.seconds)) {
        return TextButton(
            onPressed: () {},
            child: _makeRowColumn(originalButton.child, counter.toString()));
      } else {
        return originalButton;
      }
    } else if (_buttonType == OutlinedButton) {
      OutlinedButton originalButton = widget.child as OutlinedButton;
      if (_initialVisible || (counter != widget.seconds)) {
        return OutlinedButton(
            onPressed: () {},
            child: _makeRowColumn(originalButton.child, counter.toString()));
      } else {
        return originalButton;
      }
    } else {
      throw TypeError;
    }
  }

  /// While gesture long pressed is detected,
  /// keep count Down
  _onLongPressed() async {
    /// if _counting was false, Timer start
    if (!_counting) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _counter--;
          if (_counter <= 0) {
            widget.afterLongPress();
            _onCancel();
          }
        });
      });
    }
    _counting = true;
  }

  /// Reset timer
  _onCancel() {
    setState(() {
      _counter = widget.seconds;
      _counting = false;
      _timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: (!widget.countVisibility) ? buttonChild : _button(_counter),
      onLongPressMoveUpdate: (details) async => _onLongPressed(),
      onLongPressCancel: () => _onCancel(),
      onLongPressUp: () {
        if (_counter > 0) _onCancel();
      },
    );
  }
}
