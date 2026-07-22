import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/core/billing/billing_product_ids.dart';
import 'package:habit_tracker/core/billing/billing_service.dart';
import 'package:habit_tracker/core/services/remote_config_service.dart';
import 'package:habit_tracker/core/services/habit_service.dart';
import 'package:habit_tracker/core/services/profile_service.dart';
import 'package:habit_tracker/core/services/locale_service.dart';
import 'package:habit_tracker/core/widgets/global_pointer_gate.dart';
import 'package:habit_tracker/splash_screen.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import 'package:habit_tracker/core/navigation/app_navigator.dart';

void main() async {
  // Ensure Flutter binding is initialized before async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only.
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  // Initialize Hive for local storage
  await ProfileService.init();
  await HabitService.init();
  await LocaleService.init();
  await Firebase.initializeApp();
  await RemoteConfigService.init();

  if (kDebugMode) {
    // Ensures consistent test ads on this device during development.
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: const ['3155AA20FAA8F538B527C6F31F44F5E8'],
      ),
    );
  }

  await MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ChangeNotifierProvider(
          create: (_) => BillingService(
            weeklyProductId: BillingProductIds.weekly,
            lifetimeProductId: BillingProductIds.lifetime,
          )..init(),
        ),
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
                      title: 'Eco Habit',
                      debugShowCheckedModeBanner: false,
                      navigatorKey: AppNavigator.navigatorKey,
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
                      builder: (context, child) {
                        return SafeArea(
                          top: false,
                          child: child ?? const SizedBox.shrink(),
                        );
                      },
                      // Always start from splash for a consistent launch experience.
                      onGenerateRoute: (settings) {
                        return MaterialPageRoute(
                          builder: (_) => const SplashScreen(),
                        );
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
