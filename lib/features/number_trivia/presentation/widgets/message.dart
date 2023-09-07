import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({Key? key, required this.message}) : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 25),
      ),
    );
  }
}
