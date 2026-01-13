import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/core/services/habit_service.dart';
import 'package:habit_tracker/core/services/profile_service.dart';
import 'package:habit_tracker/splash_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized before async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await ProfileService.init();
  await HabitService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final service = HabitService();
        service.loadData();
        return service;
      },
      child: MaterialApp(
        title: 'Eco Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
