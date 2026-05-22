import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Food',
      home: Scaffold(
        appBar: AppBar(title: const Text('My First Food')),
        body: const Center(child: Text('Welcome to My First Food')),
      ),
    );
  }
}
