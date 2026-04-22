import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
// NOTE: Ads are temporarily disabled.
//
// Original ad-related import preserved for later re-enable:
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
// import 'package:habit_tracker/core/ads/app_open_ad_manager.dart';
// import 'package:habit_tracker/core/ads/interstitial_ad_manager.dart';
import 'package:habit_tracker/core/billing/billing_product_ids.dart';
import 'package:habit_tracker/core/billing/billing_service.dart';
import 'package:habit_tracker/core/services/remote_config_service.dart';
import 'package:habit_tracker/core/services/habit_service.dart';
import 'package:habit_tracker/core/services/profile_service.dart';
import 'package:habit_tracker/core/services/locale_service.dart';
import 'package:habit_tracker/core/widgets/global_pointer_gate.dart';
import 'package:habit_tracker/splash_screen.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';

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
  // NOTE: Ads are temporarily disabled.
  //
  // Original initialization preserved for later re-enable:
  // await MobileAds.instance.initialize();
  // AppOpenAdManager.initialize();
  // InterstitialAdManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _wasInBackground = true;
      return;
    }

    if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      // NOTE: Ads are temporarily disabled.
      // AppOpenAdManager.onAppResumedFromBackground();
    }
  }

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
