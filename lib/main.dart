import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/home/home_shell.dart';
import 'package:habit_tracker/core/services/habit_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitService(),
      child: MaterialApp(
        title: 'Eco Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const HomeShell(),
      ),
    );
  }
}
