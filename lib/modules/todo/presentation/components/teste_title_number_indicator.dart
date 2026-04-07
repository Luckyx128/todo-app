import 'package:flutter/material.dart';

class TesteTitleNumberIndicator extends StatelessWidget {
  final String title;
  final int quantidade;
  final Color cor;

  const TesteTitleNumberIndicator({
    super.key,
    required this.quantidade,
    required this.cor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: TextStyle(color: cor)),
        SizedBox(width: 8),
        Badge.count(count: quantidade, backgroundColor: Color(0xFF333333)),
      ],
    );
  }
}
