import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/core/services/habit_service.dart';
import 'package:habit_tracker/core/services/profile_service.dart';
import 'package:habit_tracker/core/services/locale_service.dart';
import 'package:habit_tracker/splash_screen.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';

void main() async {
  // Ensure Flutter binding is initialized before async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await ProfileService.init();
  await HabitService.init();
  await LocaleService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final service = HabitService();
            service.loadData(); // Will complete asynchronously
            return service;
          },
        ),
        ChangeNotifierProvider(create: (_) => LocaleService()),
      ],
      child: Consumer<LocaleService>(
        builder: (context, localeService, child) {
          final mediaQueryData = MediaQuery.maybeOf(context);
          return ScreenUtilInit(
            designSize: const Size(375, 812), // iPhone X design size
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MediaQuery(
                // Lock text scale factor to 1.0 to prevent system text size changes
                data: (mediaQueryData ?? const MediaQueryData()).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: MaterialApp(
                  title: 'Eco Habit Tracker',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
                  ),
                  // Localization configuration
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: localeService.getCurrentLocale(),
                  home: const SplashScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
