// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Öko-Gewohnheits-Tracker';

  @override
  String get makingTheWorldGreener => 'Die Welt grüner machen';

  @override
  String get ecoExplorer => 'ÖKO-ENTDECKER';

  @override
  String get greenScore => 'Grüne Punktzahl';

  @override
  String get avgActionsPerDay => 'Durchschn. Aktionen/Tag';

  @override
  String get dayStreak => 'Tages-Serie';

  @override
  String get badges => 'Abzeichen';

  @override
  String get firstStep => 'Erster Schritt';

  @override
  String get cyclist => 'Radfahrer';

  @override
  String get waterSaver => 'Wassersparer';

  @override
  String get energyPr => 'Energie Pr';

  @override
  String youHaveUnlockedBadge(String badge) {
    return 'Du hast das $badge Abzeichen freigeschaltet!';
  }

  @override
  String get history => 'Verlauf';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get monthly => 'Monatlich';

  @override
  String get allTime => 'Gesamte Zeit';

  @override
  String get viewHistory => 'Verlauf anzeigen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get account => 'Konto';

  @override
  String get language => 'Sprache';

  @override
  String get english => 'Englisch';

  @override
  String get shareApp => 'App teilen';

  @override
  String get rateUs => 'Bewerten Sie uns';

  @override
  String get moreApps => 'Weitere Apps';

  @override
  String get support => 'Support';

  @override
  String get feedback => 'Feedback';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get communityGuidelines => 'Community-Richtlinien';

  @override
  String get logout => 'Abmelden';

  @override
  String get chooseALanguage => 'Sprache wählen';

  @override
  String get next => 'Weiter';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get addThisHabitToYourRoutine =>
      'Diese Gewohnheit zu Ihrer Routine hinzufügen?';

  @override
  String get youCanTrackItDailyOnYourHomeScreen =>
      'Sie können es täglich auf Ihrem Startbildschirm verfolgen';

  @override
  String get exit => 'Beenden';

  @override
  String get areYouSureYouWantToExit =>
      'Sind Sie sicher, dass Sie die App beenden möchten?';

  @override
  String get areYouSureYouWantToLogout =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get accountSettingsComingSoon => 'Kontoeinstellungen kommen bald';

  @override
  String languageChangedTo(String language) {
    return 'Sprache geändert zu $language';
  }

  @override
  String get shareFunctionalityComingSoon => 'Teilen-Funktion kommt bald';

  @override
  String get logoutFunctionalityComingSoon => 'Abmelde-Funktion kommt bald';

  @override
  String get resetAllProgress => 'Alle Fortschritte zurücksetzen';

  @override
  String get areYouSureYouWantToResetAllProgress =>
      'Sind Sie sicher, dass Sie alle Fortschritte zurücksetzen möchten? Dies löscht alle Ihre Punkte, Gewohnheiten und den Verlauf.';

  @override
  String get progressResetSuccessfully =>
      'Alle Fortschritte wurden erfolgreich zurückgesetzt';

  @override
  String get couldNotOpenLink => 'Link konnte nicht geöffnet werden';

  @override
  String get habitLibrary => 'Gewohnheit';

  @override
  String get pickOneHabitToBeginYourEcoJourney =>
      'Wählen Sie eine Gewohnheit, um Ihre Öko-Reise zu beginnen.';

  @override
  String get pickAHabitToAdd => 'Gewohnheit zum Hinzufügen wählen';

  @override
  String get all => 'Alle';

  @override
  String get transport => 'Transport';

  @override
  String get food => 'Essen';

  @override
  String get home => 'Zuhause';

  @override
  String get water => 'Wasser';

  @override
  String get shopping => 'Einkaufen';

  @override
  String get waste => 'Abfall';

  @override
  String get digital => 'Digital';

  @override
  String get fitness => 'Fitness';

  @override
  String get mindfulness => 'Achtsamkeit';

  @override
  String get savings => 'Ersparnisse';

  @override
  String get easy => 'Einfach';

  @override
  String get medium => 'Mittel';

  @override
  String get highImpact => 'Hohe Wirkung';

  @override
  String get mediumImpact => 'Mittlere Wirkung';

  @override
  String get lowImpact => 'Geringe Wirkung';

  @override
  String get monday => 'Mo';

  @override
  String get tuesday => 'Di';

  @override
  String get wednesday => 'Mi';

  @override
  String get thursday => 'Do';

  @override
  String get friday => 'Fr';

  @override
  String get saturday => 'Sa';

  @override
  String get sunday => 'So';

  @override
  String get setUpYourProfile => 'Profil';

  @override
  String get letsPersonalizeYourEcoJourney =>
      'Personalisieren wir Ihre Öko-Reise';

  @override
  String get tapToUploadPhoto => 'Tippen zum Hochladen eines Fotos';

  @override
  String get yourName => 'Ihr Name';

  @override
  String get nameHint => 'z.B. Liza';

  @override
  String get continueButton => 'Weiter';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get profileUpdatedSuccessfully => 'Profil erfolgreich aktualisiert';

  @override
  String get pleaseEnterYourName => 'Bitte geben Sie Ihren Namen ein';

  @override
  String get pleaseSelectPhoto => 'Bitte wählen Sie ein Foto aus';

  @override
  String errorPickingImage(String error) {
    return 'Fehler beim Auswählen des Bildes: $error';
  }

  @override
  String get noFaceDetected =>
      'Kein menschliches Gesicht erkannt. Bitte laden Sie ein Foto mit einem klaren Gesicht hoch.';

  @override
  String get chooseFromGallery => 'Aus Galerie wählen';

  @override
  String get takeAPhoto => 'Foto aufnehmen';

  @override
  String get useDefaultImage => 'Standardbild verwenden';

  @override
  String get leaderboard => 'Bestenliste';

  @override
  String get yourEcoHabitsYourRank => 'Ihre Öko-Gewohnheiten, Ihr Rang';

  @override
  String get betterHabitsLeadToBetterBadges =>
      'Bessere Gewohnheiten führen zu besseren Abzeichen und größerem Fortschritt.';

  @override
  String get currentEcoHabitRankings => 'Aktuelle Öko-Gewohnheits-Rangliste';

  @override
  String get you => 'Sie';

  @override
  String get greenStarter => 'Grüner Anfänger';

  @override
  String get ecoExplorerRank => 'Öko-Entdecker';

  @override
  String get ecoWarrior => 'Öko-Krieger';

  @override
  String get natureGuardian => 'Naturwächter';

  @override
  String get ecoMaster => 'Öko-Meister';

  @override
  String get ecoBuilder => 'Öko-Bauer';

  @override
  String get ecoChampion => 'Öko-Champion';

  @override
  String get ecoGuardian => 'Öko-Wächter';

  @override
  String get planetHero => 'Planeten-Held';

  @override
  String get hi => 'Hallo';

  @override
  String get dailyEcoScore => 'Tägliche Öko-Punktzahl';

  @override
  String nextLevel(String level) {
    return 'Nächstes Level: $level';
  }

  @override
  String get todaysEcoTasks => 'Heutige Öko-Aufgaben';

  @override
  String get skippedYourStreakNeedsConsistency =>
      'Übersprungen! Ihre Serie braucht Konsistenz';

  @override
  String taskDoneStreakStrong(String task) {
    return '$task Erledigt! Serie Stark';
  }

  @override
  String taskDone(String task) {
    return '$task Erledigt';
  }

  @override
  String get skip => 'Überspringen';

  @override
  String get done => 'Erledigt';

  @override
  String get noMoreTasksForTheDay => 'Keine weiteren Aufgaben für heute';

  @override
  String get goodMorning => 'Guten Morgen';

  @override
  String get goodAfternoon => 'Guten Tag';

  @override
  String get goodEvening => 'Guten Abend';

  @override
  String get thisHabitIsAlreadyAdded =>
      'Diese Gewohnheit ist bereits zu Ihrer Liste hinzugefügt';

  @override
  String thisHabitWasAddedRecently(int hours) {
    return 'Diese Gewohnheit wurde kürzlich hinzugefügt. Bitte warten Sie $hours Stunden, bevor Sie sie erneut hinzufügen (setzt sich um Mitternacht zurück)';
  }

  @override
  String habitAddedKeepGoing(String habit) {
    return '$habit Hinzugefügt! Weiter so';
  }

  @override
  String get cycleToWork => 'Mit dem Fahrrad zur Arbeit';

  @override
  String get usePublicTransport => 'Öffentliche Verkehrsmittel nutzen';

  @override
  String get carpoolWithColleagues => 'Fahrgemeinschaft mit Kollegen';

  @override
  String get walkShortDistances => 'Kurze Strecken zu Fuß gehen';

  @override
  String get maintainBikeRegularly => 'Fahrrad regelmäßig warten';

  @override
  String get buyBulkFood => 'Lebensmittel in großen Mengen kaufen';

  @override
  String get compostKitchenWaste => 'Küchenabfälle kompostieren';

  @override
  String get plantAMiniGarden => 'Mini-Garten anlegen';

  @override
  String get reducePackagedFood => 'Verpackte Lebensmittel reduzieren';

  @override
  String get chooseSeasonalFruits => 'Saisonale Früchte wählen';

  @override
  String get coldWaterWash => 'Kaltwasserwäsche';

  @override
  String get switchOffUnusedLights => 'Ungenutzte Lichter ausschalten';

  @override
  String get useEnergyEfficientBulbs => 'Energiesparende Glühbirnen verwenden';

  @override
  String get airDryClothes => 'Kleidung an der Luft trocknen';

  @override
  String get useNaturalVentilation => 'Natürliche Belüftung nutzen';

  @override
  String get shorterShowers => 'Kürzere Duschen';

  @override
  String get fixWaterLeaks => 'Wasserverluste reparieren';

  @override
  String get collectRainwaterForPlants => 'Regenwasser für Pflanzen sammeln';

  @override
  String get reuseROWater => 'Umkehrosmose-Wasser wiederverwenden';

  @override
  String get turnOffTapWhileBrushing => 'Wasserhahn beim Zähneputzen abstellen';

  @override
  String get carryReusableBags => 'Wiederverwendbare Taschen mitnehmen';

  @override
  String get buyRecycledProducts => 'Recycelte Produkte kaufen';

  @override
  String get avoidFastFashion => 'Fast Fashion vermeiden';

  @override
  String get chooseEcoFriendlyBrands => 'Umweltfreundliche Marken wählen';

  @override
  String get supportLocalBusiness => 'Lokale Unternehmen unterstützen';

  @override
  String get reduceScreenTime => 'Bildschirmzeit reduzieren';

  @override
  String get unsubscribeUnwantedMails => 'Von unerwünschten E-Mails abmelden';

  @override
  String get cloudBackupCleanup => 'Cloud-Backup bereinigen';

  @override
  String get turnOffAutoPlay => 'Automatische Wiedergabe ausschalten';

  @override
  String get digitalMindfulBreaks => 'Digitale achtsame Pausen';

  @override
  String get morningWalk => 'Morgenspaziergang';

  @override
  String get practiceYoga => 'Yoga praktizieren';

  @override
  String get healthySleepRoutine => 'Gesunde Schlafroutine';

  @override
  String get drink2LWater => '2L Wasser trinken';

  @override
  String get avoidJunkSnacks => 'Ungesunde Snacks vermeiden';

  @override
  String get meditation5MinDay => 'Meditation 5 Min/Tag';

  @override
  String get practiceGratitudeJournaling => 'Dankbarkeitstagebuch führen';

  @override
  String get breathingExercise => 'Atemübung';

  @override
  String get spendTimeInNature => 'Zeit in der Natur verbringen';

  @override
  String get limitNegativeNews => 'Negative Nachrichten begrenzen';

  @override
  String get trackExpenses => 'Ausgaben verfolgen';

  @override
  String get monthlySavingsGoal => 'Monatliches Sparziel';

  @override
  String get avoidImpulseBuying => 'Impulskäufe vermeiden';

  @override
  String get investInSIP => 'In SIP investieren';

  @override
  String get useCashBackResponsibly => 'Cash-Back verantwortungsvoll nutzen';

  @override
  String get defaultWalkBikeTitle =>
      'Zu Fuß gegangen/mit dem Fahrrad gefahren statt Auto zu fahren';

  @override
  String get defaultCoffeeCupTitle =>
      'Einen wiederverwendbaren Kaffeebecher benutzt';

  @override
  String get defaultAfforestationTitle =>
      'Aufforstung / Einen Baum für eine bessere Umwelt gepflanzt';

  @override
  String get dailyTag => 'Täglich';

  @override
  String get afforestationTag => 'Aufforstung';

  @override
  String get plantingTag => 'Pflanzen';

  @override
  String get onboardingTitle1 => 'Verfolgen Sie Ihre täglichen Öko-Aktionen';

  @override
  String get onboardingDescription1 =>
      'Vervollständigen Sie tägliche Aktionen, halten Sie Ihre Serie aufrecht und erhöhen Sie Ihren Öko-Score.';

  @override
  String get onboardingTitle2 => 'Gewohnheiten aufbauen, die bleiben';

  @override
  String get onboardingDescription2 =>
      'Fügen Sie Gewohnheiten zu Ihrer Routine hinzu, halten Sie Serien aufrecht und verdienen Sie Belohnungen, während Sie konsequent bleiben.';

  @override
  String get onboardingTitle3 => 'Wettbewerb. Verdienen. Aufsteigen.';

  @override
  String get onboardingDescription3 =>
      'Steigen Sie in der Bestenliste auf, schalten Sie Abzeichen frei und verfolgen Sie Ihren Fortschritt im Vergleich zu anderen.';
}
