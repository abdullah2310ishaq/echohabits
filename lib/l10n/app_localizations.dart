import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Eco Habit Tracker'**
  String get appTitle;

  /// Profile subtitle text
  ///
  /// In en, this message translates to:
  /// **'Making the world greener'**
  String get makingTheWorldGreener;

  /// Badge title
  ///
  /// In en, this message translates to:
  /// **'ECO EXPLORER'**
  String get ecoExplorer;

  /// Green score card title
  ///
  /// In en, this message translates to:
  /// **'Green Score'**
  String get greenScore;

  /// Average actions per day label
  ///
  /// In en, this message translates to:
  /// **'Avg Actions/Day'**
  String get avgActionsPerDay;

  /// Day streak label
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// Badges section title
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// First step badge name
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get firstStep;

  /// Cyclist badge name
  ///
  /// In en, this message translates to:
  /// **'Cyclist'**
  String get cyclist;

  /// Water saver badge name
  ///
  /// In en, this message translates to:
  /// **'Water Saver'**
  String get waterSaver;

  /// Energy Pr badge name
  ///
  /// In en, this message translates to:
  /// **'Energy Pr'**
  String get energyPr;

  /// History section title
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// View history button text
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Account settings option
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Language settings option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Share app option
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// Rate us option
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// Support option
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Privacy policy option
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms of service option
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Logout option
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Language selection screen title
  ///
  /// In en, this message translates to:
  /// **'Choose a Language'**
  String get chooseALanguage;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// Account settings placeholder message
  ///
  /// In en, this message translates to:
  /// **'Account settings coming soon'**
  String get accountSettingsComingSoon;

  /// Language change confirmation message
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChangedTo(String language);

  /// Share functionality placeholder message
  ///
  /// In en, this message translates to:
  /// **'Share functionality coming soon'**
  String get shareFunctionalityComingSoon;

  /// Logout functionality placeholder message
  ///
  /// In en, this message translates to:
  /// **'Logout functionality coming soon'**
  String get logoutFunctionalityComingSoon;

  /// Error message when link cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open link'**
  String get couldNotOpenLink;

  /// Habit library screen title
  ///
  /// In en, this message translates to:
  /// **'Habit'**
  String get habitLibrary;

  /// Habit library subtitle
  ///
  /// In en, this message translates to:
  /// **'Pick one habit to begin your eco journey.'**
  String get pickOneHabitToBeginYourEcoJourney;

  /// Habit list section title
  ///
  /// In en, this message translates to:
  /// **'Pick a Habit to Add'**
  String get pickAHabitToAdd;

  /// All categories filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Transport category
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// Food category
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// Home category
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Water category
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// Shopping category
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// Waste category
  ///
  /// In en, this message translates to:
  /// **'Waste'**
  String get waste;

  /// Digital category
  ///
  /// In en, this message translates to:
  /// **'Digital'**
  String get digital;

  /// Fitness category
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get fitness;

  /// Mindfulness category
  ///
  /// In en, this message translates to:
  /// **'Mindfulness'**
  String get mindfulness;

  /// Savings category
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// Easy difficulty level
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// Medium difficulty level
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// High impact label
  ///
  /// In en, this message translates to:
  /// **'High Impact'**
  String get highImpact;

  /// Medium impact label
  ///
  /// In en, this message translates to:
  /// **'Medium Impact'**
  String get mediumImpact;

  /// Low impact label
  ///
  /// In en, this message translates to:
  /// **'Low Impact'**
  String get lowImpact;

  /// Monday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// Tuesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// Wednesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// Thursday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// Friday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// Saturday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// Sunday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// Profile setup screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get setUpYourProfile;

  /// Profile setup subtitle
  ///
  /// In en, this message translates to:
  /// **'Let\'s personalize your eco journey'**
  String get letsPersonalizeYourEcoJourney;

  /// Profile picture upload instruction
  ///
  /// In en, this message translates to:
  /// **'Tap to upload photo'**
  String get tapToUploadPhoto;

  /// Name input field label
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// Name input field hint text
  ///
  /// In en, this message translates to:
  /// **'e.g. Liza'**
  String get nameHint;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Validation message when name is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// Error message when image picker fails
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(String error);

  /// Image source option - gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Image source option - camera
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takeAPhoto;

  /// Image source option - default
  ///
  /// In en, this message translates to:
  /// **'Use Default Image'**
  String get useDefaultImage;

  /// Leaderboard screen title
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// Leaderboard subtitle
  ///
  /// In en, this message translates to:
  /// **'Your eco habits, your rank'**
  String get yourEcoHabitsYourRank;

  /// Leaderboard motivational message
  ///
  /// In en, this message translates to:
  /// **'Better habits lead to better badges and greater progress.'**
  String get betterHabitsLeadToBetterBadges;

  /// Rankings section title
  ///
  /// In en, this message translates to:
  /// **'Current eco habit rankings'**
  String get currentEcoHabitRankings;

  /// Current user indicator
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// Rank title for score < 2000
  ///
  /// In en, this message translates to:
  /// **'Green Starter'**
  String get greenStarter;

  /// Rank title for score 2000-2999
  ///
  /// In en, this message translates to:
  /// **'Eco Explorer'**
  String get ecoExplorerRank;

  /// Rank title for score 3000-4999
  ///
  /// In en, this message translates to:
  /// **'Eco Warrior'**
  String get ecoWarrior;

  /// Rank title for score 5000-9999
  ///
  /// In en, this message translates to:
  /// **'Nature Guardian'**
  String get natureGuardian;

  /// Rank title for score >= 10000
  ///
  /// In en, this message translates to:
  /// **'Eco Master'**
  String get ecoMaster;

  /// Greeting prefix
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// Daily eco score card title
  ///
  /// In en, this message translates to:
  /// **'Daily Eco Score'**
  String get dailyEcoScore;

  /// Next level indicator with level name
  ///
  /// In en, this message translates to:
  /// **'Next Level: {level}'**
  String nextLevel(String level);

  /// Today's tasks section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Eco Tasks'**
  String get todaysEcoTasks;

  /// Message when task is skipped
  ///
  /// In en, this message translates to:
  /// **'Skipped! Your streak needs consistency'**
  String get skippedYourStreakNeedsConsistency;

  /// Message when habit task is completed
  ///
  /// In en, this message translates to:
  /// **'{task} Done! Streak Strong'**
  String taskDoneStreakStrong(String task);

  /// Message when default task is completed
  ///
  /// In en, this message translates to:
  /// **'{task} Done'**
  String taskDone(String task);

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Empty state message when no tasks
  ///
  /// In en, this message translates to:
  /// **'No more tasks for the day'**
  String get noMoreTasksForTheDay;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// Afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// Error message when trying to add duplicate habit
  ///
  /// In en, this message translates to:
  /// **'This habit is already added to your list'**
  String get thisHabitIsAlreadyAdded;

  /// Error message when habit is on cooldown
  ///
  /// In en, this message translates to:
  /// **'This habit was added recently. Please wait {hours} hours before adding again (resets at midnight)'**
  String thisHabitWasAddedRecently(int hours);

  /// Success message when habit is added
  ///
  /// In en, this message translates to:
  /// **'{habit} Added! Keep Going'**
  String habitAddedKeepGoing(String habit);

  /// Transport habit title
  ///
  /// In en, this message translates to:
  /// **'Cycle to work'**
  String get cycleToWork;

  /// Transport habit title
  ///
  /// In en, this message translates to:
  /// **'Use public transport'**
  String get usePublicTransport;

  /// Transport habit title
  ///
  /// In en, this message translates to:
  /// **'Carpool with colleagues'**
  String get carpoolWithColleagues;

  /// Transport habit title
  ///
  /// In en, this message translates to:
  /// **'Walk short distances'**
  String get walkShortDistances;

  /// Transport habit title
  ///
  /// In en, this message translates to:
  /// **'Maintain bike regularly'**
  String get maintainBikeRegularly;

  /// Food habit title
  ///
  /// In en, this message translates to:
  /// **'Buy bulk food'**
  String get buyBulkFood;

  /// Food habit title
  ///
  /// In en, this message translates to:
  /// **'Compost kitchen waste'**
  String get compostKitchenWaste;

  /// Food habit title
  ///
  /// In en, this message translates to:
  /// **'Plant a mini garden'**
  String get plantAMiniGarden;

  /// Food habit title
  ///
  /// In en, this message translates to:
  /// **'Reduce packaged food'**
  String get reducePackagedFood;

  /// Food habit title
  ///
  /// In en, this message translates to:
  /// **'Choose seasonal fruits'**
  String get chooseSeasonalFruits;

  /// Home habit title
  ///
  /// In en, this message translates to:
  /// **'Cold water wash'**
  String get coldWaterWash;

  /// Home habit title
  ///
  /// In en, this message translates to:
  /// **'Switch off unused lights'**
  String get switchOffUnusedLights;

  /// Home habit title
  ///
  /// In en, this message translates to:
  /// **'Use energy-efficient bulbs'**
  String get useEnergyEfficientBulbs;

  /// Home habit title
  ///
  /// In en, this message translates to:
  /// **'Air dry clothes'**
  String get airDryClothes;

  /// Home habit title
  ///
  /// In en, this message translates to:
  /// **'Use natural ventilation'**
  String get useNaturalVentilation;

  /// Water habit title
  ///
  /// In en, this message translates to:
  /// **'Shorter showers'**
  String get shorterShowers;

  /// Water habit title
  ///
  /// In en, this message translates to:
  /// **'Fix water leaks'**
  String get fixWaterLeaks;

  /// Water habit title
  ///
  /// In en, this message translates to:
  /// **'Collect rainwater for plants'**
  String get collectRainwaterForPlants;

  /// Water habit title
  ///
  /// In en, this message translates to:
  /// **'Reuse RO water'**
  String get reuseROWater;

  /// Water habit title
  ///
  /// In en, this message translates to:
  /// **'Turn off tap while brushing'**
  String get turnOffTapWhileBrushing;

  /// Shopping/Waste habit title
  ///
  /// In en, this message translates to:
  /// **'Carry reusable bags'**
  String get carryReusableBags;

  /// Shopping/Waste habit title
  ///
  /// In en, this message translates to:
  /// **'Buy recycled products'**
  String get buyRecycledProducts;

  /// Shopping/Waste habit title
  ///
  /// In en, this message translates to:
  /// **'Avoid fast fashion'**
  String get avoidFastFashion;

  /// Shopping/Waste habit title
  ///
  /// In en, this message translates to:
  /// **'Choose eco-friendly brands'**
  String get chooseEcoFriendlyBrands;

  /// Shopping/Waste habit title
  ///
  /// In en, this message translates to:
  /// **'Support local business'**
  String get supportLocalBusiness;

  /// Digital habit title
  ///
  /// In en, this message translates to:
  /// **'Reduce screen time'**
  String get reduceScreenTime;

  /// Digital habit title
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe unwanted mails'**
  String get unsubscribeUnwantedMails;

  /// Digital habit title
  ///
  /// In en, this message translates to:
  /// **'Cloud backup cleanup'**
  String get cloudBackupCleanup;

  /// Digital habit title
  ///
  /// In en, this message translates to:
  /// **'Turn off auto-play'**
  String get turnOffAutoPlay;

  /// Digital habit title
  ///
  /// In en, this message translates to:
  /// **'Digital mindful breaks'**
  String get digitalMindfulBreaks;

  /// Fitness habit title
  ///
  /// In en, this message translates to:
  /// **'Morning walk'**
  String get morningWalk;

  /// Fitness habit title
  ///
  /// In en, this message translates to:
  /// **'Practice yoga'**
  String get practiceYoga;

  /// Fitness habit title
  ///
  /// In en, this message translates to:
  /// **'Healthy sleep routine'**
  String get healthySleepRoutine;

  /// Fitness habit title
  ///
  /// In en, this message translates to:
  /// **'Drink 2L water'**
  String get drink2LWater;

  /// Fitness habit title
  ///
  /// In en, this message translates to:
  /// **'Avoid junk snacks'**
  String get avoidJunkSnacks;

  /// Mindfulness habit title
  ///
  /// In en, this message translates to:
  /// **'Meditation 5 min/day'**
  String get meditation5MinDay;

  /// Mindfulness habit title
  ///
  /// In en, this message translates to:
  /// **'Practice gratitude journaling'**
  String get practiceGratitudeJournaling;

  /// Mindfulness habit title
  ///
  /// In en, this message translates to:
  /// **'Breathing exercise'**
  String get breathingExercise;

  /// Mindfulness habit title
  ///
  /// In en, this message translates to:
  /// **'Spend time in nature'**
  String get spendTimeInNature;

  /// Mindfulness habit title
  ///
  /// In en, this message translates to:
  /// **'Limit negative news'**
  String get limitNegativeNews;

  /// Savings habit title
  ///
  /// In en, this message translates to:
  /// **'Track expenses'**
  String get trackExpenses;

  /// Savings habit title
  ///
  /// In en, this message translates to:
  /// **'Monthly savings goal'**
  String get monthlySavingsGoal;

  /// Savings habit title
  ///
  /// In en, this message translates to:
  /// **'Avoid impulse buying'**
  String get avoidImpulseBuying;

  /// Savings habit title
  ///
  /// In en, this message translates to:
  /// **'Invest in SIP'**
  String get investInSIP;

  /// Savings habit title
  ///
  /// In en, this message translates to:
  /// **'Use cash-back responsibly'**
  String get useCashBackResponsibly;

  /// Default task title: walked/biked instead of driving
  ///
  /// In en, this message translates to:
  /// **'Walked/ biked instead of driving'**
  String get defaultWalkBikeTitle;

  /// Default task title: used a reusable coffee cup
  ///
  /// In en, this message translates to:
  /// **'Used a reusable coffee cup'**
  String get defaultCoffeeCupTitle;

  /// Default task title: afforestation / plant a tree
  ///
  /// In en, this message translates to:
  /// **'Afforestation / Plant a tree for better environment'**
  String get defaultAfforestationTitle;

  /// Tag label for daily tasks
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dailyTag;

  /// Tag label for afforestation
  ///
  /// In en, this message translates to:
  /// **'Afforestation'**
  String get afforestationTag;

  /// Tag label for planting
  ///
  /// In en, this message translates to:
  /// **'Planting'**
  String get plantingTag;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
