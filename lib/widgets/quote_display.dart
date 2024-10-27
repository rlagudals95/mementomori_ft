import 'package:flutter/material.dart';

class QuoteDisplay extends StatelessWidget {
  final String quote;

  const QuoteDisplay({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      quote,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 24),
    );
  }
}
