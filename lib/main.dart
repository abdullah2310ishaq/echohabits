import 'package:flutter/material.dart';
import 'splash_Screen.dart';
import 'profile_first.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Habit Tracker',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const ProfileFirst(),
    );
  }
}
