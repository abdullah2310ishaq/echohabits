// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Suivi des Habitudes Écologiques';

  @override
  String get makingTheWorldGreener => 'Rendre le monde plus vert';

  @override
  String get ecoExplorer => 'EXPLORATEUR ÉCOLOGIQUE';

  @override
  String get greenScore => 'Score Vert';

  @override
  String get avgActionsPerDay => 'Actions Moyennes/Jour';

  @override
  String get dayStreak => 'Série de Jours';

  @override
  String get badges => 'Badges';

  @override
  String get firstStep => 'Premier Pas';

  @override
  String get cyclist => 'Cycliste';

  @override
  String get waterSaver => 'Économiseur d\'Eau';

  @override
  String get energyPr => 'Énergie Pr';

  @override
  String youHaveUnlockedBadge(String badge) {
    return 'Vous avez débloqué le badge $badge!';
  }

  @override
  String get history => 'Historique';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get monthly => 'Mensuel';

  @override
  String get allTime => 'Tout le temps';

  @override
  String get viewHistory => 'Voir l\'Historique';

  @override
  String get settings => 'Paramètres';

  @override
  String get account => 'Compte';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get shareApp => 'Partager l\'App';

  @override
  String get rateUs => 'Notez-nous';

  @override
  String get moreApps => 'Plus d\'Applications';

  @override
  String get support => 'Support';

  @override
  String get feedback => 'Commentaires';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get communityGuidelines => 'Règles de la Communauté';

  @override
  String get logout => 'Déconnexion';

  @override
  String get chooseALanguage => 'Choisir une Langue';

  @override
  String get next => 'Suivant';

  @override
  String get cancel => 'Annuler';

  @override
  String get add => 'Ajouter';

  @override
  String get addThisHabitToYourRoutine =>
      'Ajouter cette habitude à votre routine ?';

  @override
  String get youCanTrackItDailyOnYourHomeScreen =>
      'Vous pouvez le suivre quotidiennement sur votre écran d\'accueil';

  @override
  String get exit => 'Quitter';

  @override
  String get areYouSureYouWantToExit =>
      'Êtes-vous sûr de vouloir quitter l\'application ?';

  @override
  String get areYouSureYouWantToLogout =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get accountSettingsComingSoon => 'Paramètres de compte à venir';

  @override
  String languageChangedTo(String language) {
    return 'Langue changée en $language';
  }

  @override
  String get shareFunctionalityComingSoon =>
      'Fonctionnalité de partage à venir';

  @override
  String get logoutFunctionalityComingSoon =>
      'Fonctionnalité de déconnexion à venir';

  @override
  String get resetAllProgress => 'Réinitialiser Tout le Progrès';

  @override
  String get areYouSureYouWantToResetAllProgress =>
      'Êtes-vous sûr de vouloir réinitialiser tout le progrès ? Cela supprimera tous vos scores, habitudes et historique.';

  @override
  String get progressResetSuccessfully =>
      'Tout le progrès a été réinitialisé avec succès';

  @override
  String get couldNotOpenLink => 'Impossible d\'ouvrir le lien';

  @override
  String get habitLibrary => 'Habitude';

  @override
  String get pickOneHabitToBeginYourEcoJourney =>
      'Choisissez une habitude pour commencer votre voyage écologique.';

  @override
  String get pickAHabitToAdd => 'Choisir une Habitude à Ajouter';

  @override
  String get all => 'Tous';

  @override
  String get transport => 'Transport';

  @override
  String get food => 'Alimentation';

  @override
  String get home => 'Maison';

  @override
  String get water => 'Eau';

  @override
  String get shopping => 'Shopping';

  @override
  String get waste => 'Déchets';

  @override
  String get digital => 'Numérique';

  @override
  String get fitness => 'Fitness';

  @override
  String get mindfulness => 'Pleine Conscience';

  @override
  String get savings => 'Épargne';

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Moyen';

  @override
  String get highImpact => 'Impact Élevé';

  @override
  String get mediumImpact => 'Impact Moyen';

  @override
  String get lowImpact => 'Impact Faible';

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mer';

  @override
  String get thursday => 'Jeu';

  @override
  String get friday => 'Ven';

  @override
  String get saturday => 'Sam';

  @override
  String get sunday => 'Dim';

  @override
  String get setUpYourProfile => 'Profil';

  @override
  String get letsPersonalizeYourEcoJourney =>
      'Personnalisons votre voyage écologique';

  @override
  String get tapToUploadPhoto => 'Appuyez pour télécharger une photo';

  @override
  String get yourName => 'Votre Nom';

  @override
  String get nameHint => 'ex. Liza';

  @override
  String get continueButton => 'Continuer';

  @override
  String get editProfile => 'Modifier le Profil';

  @override
  String get saveChanges => 'Enregistrer les Modifications';

  @override
  String get profileUpdatedSuccessfully => 'Profil mis à jour avec succès';

  @override
  String get pleaseEnterYourName => 'Veuillez entrer votre nom';

  @override
  String get pleaseSelectPhoto => 'Veuillez sélectionner une photo';

  @override
  String errorPickingImage(String error) {
    return 'Erreur lors de la sélection de l\'image : $error';
  }

  @override
  String get noFaceDetected =>
      'Aucun visage humain détecté. Veuillez télécharger une photo avec un visage clair.';

  @override
  String get chooseFromGallery => 'Choisir dans la Galerie';

  @override
  String get takeAPhoto => 'Prendre une Photo';

  @override
  String get useDefaultImage => 'Utiliser l\'Image par Défaut';

  @override
  String get leaderboard => 'Classement';

  @override
  String get yourEcoHabitsYourRank => 'Vos habitudes écologiques, votre rang';

  @override
  String get betterHabitsLeadToBetterBadges =>
      'De meilleures habitudes mènent à de meilleurs badges et à plus de progrès.';

  @override
  String get currentEcoHabitRankings =>
      'Classements actuels des habitudes écologiques';

  @override
  String get you => 'Vous';

  @override
  String get greenStarter => 'Débutant Vert';

  @override
  String get ecoExplorerRank => 'Explorateur Écologique';

  @override
  String get ecoWarrior => 'Guerrier Écologique';

  @override
  String get natureGuardian => 'Gardien de la Nature';

  @override
  String get ecoMaster => 'Maître Écologique';

  @override
  String get ecoBuilder => 'Constructeur Écologique';

  @override
  String get ecoChampion => 'Champion Écologique';

  @override
  String get ecoGuardian => 'Gardien Écologique';

  @override
  String get planetHero => 'Héros de la Planète';

  @override
  String get hi => 'Salut';

  @override
  String get dailyEcoScore => 'Score Écologique Quotidien';

  @override
  String nextLevel(String level) {
    return 'Niveau Suivant : $level';
  }

  @override
  String get todaysEcoTasks => 'Tâches Écologiques d\'Aujourd\'hui';

  @override
  String get skippedYourStreakNeedsConsistency =>
      'Ignoré ! Votre série a besoin de cohérence';

  @override
  String taskDoneStreakStrong(String task) {
    return '$task Fait ! Série Forte';
  }

  @override
  String taskDone(String task) {
    return '$task Fait';
  }

  @override
  String get skip => 'Ignorer';

  @override
  String get done => 'Fait';

  @override
  String get noMoreTasksForTheDay => 'Plus de tâches pour aujourd\'hui';

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon Après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get thisHabitIsAlreadyAdded =>
      'Cette habitude est déjà ajoutée à votre liste';

  @override
  String thisHabitWasAddedRecently(int hours) {
    return 'Cette habitude a été ajoutée récemment. Veuillez attendre $hours heures avant de l\'ajouter à nouveau (se réinitialise à minuit)';
  }

  @override
  String habitAddedKeepGoing(String habit) {
    return '$habit Ajouté ! Continuez';
  }

  @override
  String get cycleToWork => 'Aller au travail à vélo';

  @override
  String get usePublicTransport => 'Utiliser les transports publics';

  @override
  String get carpoolWithColleagues => 'Covoiturage avec collègues';

  @override
  String get walkShortDistances => 'Marcher sur de courtes distances';

  @override
  String get maintainBikeRegularly => 'Entretenir régulièrement le vélo';

  @override
  String get buyBulkFood => 'Acheter de la nourriture en vrac';

  @override
  String get compostKitchenWaste => 'Composter les déchets de cuisine';

  @override
  String get plantAMiniGarden => 'Planter un mini jardin';

  @override
  String get reducePackagedFood => 'Réduire les aliments emballés';

  @override
  String get chooseSeasonalFruits => 'Choisir des fruits de saison';

  @override
  String get coldWaterWash => 'Lavage à l\'eau froide';

  @override
  String get switchOffUnusedLights => 'Éteindre les lumières inutilisées';

  @override
  String get useEnergyEfficientBulbs => 'Utiliser des ampoules écoénergétiques';

  @override
  String get airDryClothes => 'Sécher les vêtements à l\'air';

  @override
  String get useNaturalVentilation => 'Utiliser la ventilation naturelle';

  @override
  String get shorterShowers => 'Douches plus courtes';

  @override
  String get fixWaterLeaks => 'Réparer les fuites d\'eau';

  @override
  String get collectRainwaterForPlants =>
      'Collecter l\'eau de pluie pour les plantes';

  @override
  String get reuseROWater => 'Réutiliser l\'eau d\'osmose inverse';

  @override
  String get turnOffTapWhileBrushing => 'Fermer le robinet pendant le brossage';

  @override
  String get carryReusableBags => 'Apporter des sacs réutilisables';

  @override
  String get buyRecycledProducts => 'Acheter des produits recyclés';

  @override
  String get avoidFastFashion => 'Éviter la mode rapide';

  @override
  String get chooseEcoFriendlyBrands => 'Choisir des marques écologiques';

  @override
  String get supportLocalBusiness => 'Soutenir les entreprises locales';

  @override
  String get reduceScreenTime => 'Réduire le temps d\'écran';

  @override
  String get unsubscribeUnwantedMails =>
      'Se désabonner des courriers indésirables';

  @override
  String get cloudBackupCleanup => 'Nettoyage de sauvegarde cloud';

  @override
  String get turnOffAutoPlay => 'Désactiver la lecture automatique';

  @override
  String get digitalMindfulBreaks => 'Pauses numériques conscientes';

  @override
  String get morningWalk => 'Marche matinale';

  @override
  String get practiceYoga => 'Pratiquer le yoga';

  @override
  String get healthySleepRoutine => 'Routine de sommeil saine';

  @override
  String get drink2LWater => 'Boire 2L d\'eau';

  @override
  String get avoidJunkSnacks => 'Éviter les snacks malsains';

  @override
  String get meditation5MinDay => 'Méditation 5 min/jour';

  @override
  String get practiceGratitudeJournaling => 'Pratiquer le journal de gratitude';

  @override
  String get breathingExercise => 'Exercice de respiration';

  @override
  String get spendTimeInNature => 'Passer du temps dans la nature';

  @override
  String get limitNegativeNews => 'Limiter les nouvelles négatives';

  @override
  String get trackExpenses => 'Suivre les dépenses';

  @override
  String get monthlySavingsGoal => 'Objectif d\'épargne mensuel';

  @override
  String get avoidImpulseBuying => 'Éviter les achats impulsifs';

  @override
  String get investInSIP => 'Investir dans un SIP';

  @override
  String get useCashBackResponsibly =>
      'Utiliser le cash-back de manière responsable';

  @override
  String get defaultWalkBikeTitle =>
      'Vous avez marché ou pris le vélo au lieu de conduire';

  @override
  String get defaultCoffeeCupTitle =>
      'Vous avez utilisé une tasse à café réutilisable';

  @override
  String get defaultAfforestationTitle =>
      'Reboisement / Planté un arbre pour un meilleur environnement';

  @override
  String get dailyTag => 'Quotidien';

  @override
  String get afforestationTag => 'Reboisement';

  @override
  String get plantingTag => 'Plantation';

  @override
  String get onboardingTitle1 => 'Suivez vos Actions Écologiques Quotidiennes';

  @override
  String get onboardingDescription1 =>
      'Complétez des actions quotidiennes, maintenez votre série et augmentez votre score écologique.';

  @override
  String get onboardingTitle2 => 'Construisez des Habitudes qui Restent';

  @override
  String get onboardingDescription2 =>
      'Ajoutez des habitudes à votre routine, maintenez des séries et gagnez des récompenses en restant constant.';

  @override
  String get onboardingTitle3 => 'Rivalisez. Gagnez. Montez de Niveau.';

  @override
  String get onboardingDescription3 =>
      'Grimpez dans le classement, débloquez des badges et suivez votre progression par rapport aux autres.';
}
