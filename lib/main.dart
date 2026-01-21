import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/core/services/habit_service.dart'; 
import 'package:habit_tracker/core/services/profile_service.dart';
import 'package:habit_tracker/core/services/locale_service.dart';
import 'package:habit_tracker/core/widgets/global_pointer_gate.dart';
import 'package:habit_tracker/splash_screen.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import 'package:habit_tracker/home/home_shell.dart';

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
        ChangeNotifierProvider(
          create: (_) {
            final service = LocaleService();
            service.loadLocaleFromStorage();
            return service;
          },
        ),
        ChangeNotifierProvider(create: (_) => ProfileService()),
      ],
      child: Consumer<LocaleService>(
        builder: (context, localeService, child) {
          final mediaQueryData = MediaQuery.maybeOf(context);
          return ScreenUtilInit(
            designSize: const Size(375, 812), // iPhone X design size
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              final currentLocale = localeService.getCurrentLocale();
              final isRTL = currentLocale.languageCode == 'ar';

              return Directionality(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: MediaQuery(
                  // Lock text scale factor to 1.0 to prevent system text size changes
                  data: (mediaQueryData ?? const MediaQueryData()).copyWith(
                    textScaler: TextScaler.linear(1.0),
                  ),
                  child: GlobalPointerGate(
                    child: MaterialApp(
                      key: ValueKey(currentLocale.languageCode), // Force rebuild on locale change
                      title: 'Eco Habit Tracker',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.green,
                        ),
                      ),
                      // Localization configuration
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: AppLocalizations.supportedLocales,
                      locale: currentLocale,
                      // Use onGenerateRoute to skip splash if app is already initialized
                      onGenerateRoute: (settings) {
                        // Check if app is already initialized (language selected, onboarding done, profile setup)
                        final isLanguageSelected = localeService.isLanguageSelected();
                        final isProfileSetup = ProfileService.isProfileSetupComplete();
                        final isOnboardingComplete = ProfileService.isOnboardingComplete();
                        
                        // If app is fully initialized, go directly to home (skip splash)
                        if (isLanguageSelected && isOnboardingComplete && isProfileSetup) {
                          return MaterialPageRoute(builder: (_) => const HomeShell());
                        }
                        
                        // Otherwise show splash screen (first time or incomplete setup)
                        return MaterialPageRoute(builder: (_) => const SplashScreen());
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
