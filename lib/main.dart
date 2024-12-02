import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GameExplorerApp());
}

class GameExplorerApp extends StatelessWidget {
  const GameExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FARISFILM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
    );
  }
}
