import 'package:flutter/material.dart';

class HeaderInputText extends StatelessWidget {
  const HeaderInputText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
