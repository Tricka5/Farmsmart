
import 'package:flutter/material.dart';
class CoolLoadingSpinner extends StatefulWidget {
  @override
  _CoolLoadingSpinnerState createState() => _CoolLoadingSpinnerState();
}

class _CoolLoadingSpinnerState extends State<CoolLoadingSpinner> {
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _animateRotation();
  }

  void _animateRotation() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _rotation += 0.1;
      });
      _animateRotation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedRotation(
        turns: _rotation,
        duration: Duration(seconds: 1),
        child: Icon(
          Icons.autorenew,
          size: 100,
          color: Colors.blue,
        ),
      ),
    );
  }
}
