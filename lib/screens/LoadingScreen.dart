import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: JumpingDotsProgressIndicator(
        fontSize: 20.0,
      ),
    );
  }
}
