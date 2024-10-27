import 'package:flutter/material.dart';

class QuoteDisplay extends StatelessWidget {
  final String quote;

  const QuoteDisplay({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Text(
          quote,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
