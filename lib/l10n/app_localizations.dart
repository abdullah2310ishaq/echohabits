import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

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
  /// **'Habit Library'**
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
  /// **'Set up your profile'**
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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
