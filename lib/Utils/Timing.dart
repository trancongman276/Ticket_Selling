import 'package:flutter/material.dart';
import 'dart:async';

class Timing extends StatefulWidget {
  final int duration;

  const Timing({Key key, @required this.duration}) : super(key: key);
  @override
  _TimingState createState() => _TimingState(this.duration);
}

class _TimingState extends State<Timing> {
  int duration;
  _TimingState(this.duration);
  // Verification
  bool resendVerification = false;
  Timer _timer;
  void timing() {
    const sec = const Duration(seconds: 1);
    _timer = Timer.periodic(sec, (timer) {
      setState(() {
        if (duration < 1) {
          _timer.cancel();
        } else {
          duration -= 1;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    timing();
  }

  @override
  Widget build(BuildContext context) {
    return Text(duration == 0 ? "Resend?" : "Resend in $duration");
  }
}
