import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import '../core/widgets/add_habit_dialog.dart';
import '../core/widgets/eco_toast.dart';
import '../core/services/habit_service.dart';

class HabitsOne extends StatefulWidget {
  const HabitsOne({super.key});

  @override
  State<HabitsOne> createState() => _HabitsOneState();
}

class _HabitsOneState extends State<HabitsOne> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Transport',
    'Food',
    'Home',
    'Water',
    'Shopping',
    'Waste',
    'Digital',
    'Fitness',
    'Mindfulness',
    'Savings',
  ];

  final List<Map<String, dynamic>> _allHabits = [
    // Transport habits
    {
      'titleKey': 'cycleToWork',
      'category': 'Transport',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'usePublicTransport',
      'category': 'Transport',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'carpoolWithColleagues',
      'category': 'Transport',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'walkShortDistances',
      'category': 'Transport',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'maintainBikeRegularly',
      'category': 'Transport',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Food habits
    {
      'titleKey': 'buyBulkFood',
      'category': 'Food',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'compostKitchenWaste',
      'category': 'Food',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'plantAMiniGarden',
      'category': 'Food',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'reducePackagedFood',
      'category': 'Food',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'chooseSeasonalFruits',
      'category': 'Food',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Home habits
    {
      'titleKey': 'coldWaterWash',
      'category': 'Home',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'switchOffUnusedLights',
      'category': 'Home',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'useEnergyEfficientBulbs',
      'category': 'Home',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'airDryClothes',
      'category': 'Home',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'useNaturalVentilation',
      'category': 'Home',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Water habits
    {
      'titleKey': 'shorterShowers',
      'category': 'Water',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'fixWaterLeaks',
      'category': 'Water',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'collectRainwaterForPlants',
      'category': 'Water',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'reuseROWater',
      'category': 'Water',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'turnOffTapWhileBrushing',
      'category': 'Water',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Shopping habits
    {
      'titleKey': 'carryReusableBags',
      'category': 'Shopping',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'buyRecycledProducts',
      'category': 'Shopping',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'avoidFastFashion',
      'category': 'Shopping',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'chooseEcoFriendlyBrands',
      'category': 'Shopping',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'supportLocalBusiness',
      'category': 'Shopping',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Waste habits
    {
      'titleKey': 'carryReusableBags',
      'category': 'Waste',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'buyRecycledProducts',
      'category': 'Waste',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'avoidFastFashion',
      'category': 'Waste',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'chooseEcoFriendlyBrands',
      'category': 'Waste',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'supportLocalBusiness',
      'category': 'Waste',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Digital habits
    {
      'titleKey': 'reduceScreenTime',
      'category': 'Digital',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'unsubscribeUnwantedMails',
      'category': 'Digital',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'cloudBackupCleanup',
      'category': 'Digital',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'turnOffAutoPlay',
      'category': 'Digital',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'digitalMindfulBreaks',
      'category': 'Digital',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Fitness habits
    {
      'titleKey': 'morningWalk',
      'category': 'Fitness',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'practiceYoga',
      'category': 'Fitness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'healthySleepRoutine',
      'category': 'Fitness',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'drink2LWater',
      'category': 'Fitness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'avoidJunkSnacks',
      'category': 'Fitness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Mindfulness habits
    {
      'titleKey': 'meditation5MinDay',
      'category': 'Mindfulness',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'practiceGratitudeJournaling',
      'category': 'Mindfulness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'breathingExercise',
      'category': 'Mindfulness',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'spendTimeInNature',
      'category': 'Mindfulness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'limitNegativeNews',
      'category': 'Mindfulness',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    // Savings habits
    {
      'titleKey': 'trackExpenses',
      'category': 'Savings',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'monthlySavingsGoal',
      'category': 'Savings',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
    {
      'titleKey': 'avoidImpulseBuying',
      'category': 'Savings',
      'difficulty': 'Easy',
      'difficultyColor': Colors.green,
      'impact': 'Medium Impact',
      'impactColor': Colors.orange,
    },
    {
      'titleKey': 'investInSIP',
      'category': 'Savings',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'Low Impact',
      'impactColor': Colors.black54,
    },
    {
      'titleKey': 'useCashBackResponsibly',
      'category': 'Savings',
      'difficulty': 'Medium',
      'difficultyColor': Colors.orange,
      'impact': 'High Impact',
      'impactColor': Colors.green,
    },
  ];

  List<Map<String, dynamic>> get _filteredHabits {
    if (_selectedCategory == 'All') {
      return _allHabits;
    }
    return _allHabits
        .where((habit) => habit['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          SizedBox(height: 40.h),
          // Header & Filter Section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  AppLocalizations.of(context)!.habitLibrary,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(height: 6.h),
                // Subtitle
                Text(
                  AppLocalizations.of(
                    context,
                  )!.pickOneHabitToBeginYourEcoJourney,
                  style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                ),
                SizedBox(height: 16.h),
                // Filter Bar
                SizedBox(
                  height: 36.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: FilterChip(
                          label: Text(_getLocalizedCategory(context, category)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: const Color(0xFF2E7D32),
                          showCheckmark: false,
                          labelStyle: TextStyle(
                            fontSize: 12.sp,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          shape: const StadiumBorder(),
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main List View
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              children: [
                Text(
                  AppLocalizations.of(context)!.pickAHabitToAdd,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),
                ..._filteredHabits.map(
                  (habit) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _buildHabitCard(
                      context: context,
                      titleKey: habit['titleKey'] as String,
                      difficulty: habit['difficulty'] as String,
                      difficultyColor: habit['difficultyColor'] as Color,
                      impact: habit['impact'] as String,
                      impactColor: habit['impactColor'] as Color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard({
    required BuildContext context,
    required String titleKey,
    required String difficulty,
    required Color difficultyColor,
    required String impact,
    required Color impactColor,
  }) {
    final localizedTitle = _getLocalizedTitle(context, titleKey);
    final localizedDifficulty = _getLocalizedDifficulty(context, difficulty);
    final localizedImpact = _getLocalizedImpact(context, impact);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  localizedTitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10.h),
                // Metadata Row
                Row(
                  children: [
                    // Difficulty Dot
                    Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: difficultyColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    // Difficulty Text
                    Text(
                      localizedDifficulty,
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                    ),
                    SizedBox(width: 12.w),
                    // Impact Label
                    Text(
                      localizedImpact,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: impactColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Add Button
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.black87, size: 20.sp),
              onPressed: () {
                final localizedTitle = _getLocalizedTitle(context, titleKey);
                AddHabitDialog.show(
                  context,
                  habitTitle: localizedTitle,
                  difficulty: difficulty,
                  difficultyColor: difficultyColor,
                  impact: impact,
                  impactColor: impactColor,
                  onAdd: () {
                    // Find the habit category from the full habit data
                    final habitData = _allHabits.firstWhere(
                      (h) => h['titleKey'] == titleKey,
                      orElse: () => {'category': 'All'},
                    );

                    final habitService = Provider.of<HabitService>(
                      context,
                      listen: false,
                    );
                    final result = habitService.addHabit(
                      title: localizedTitle,
                      titleKey:
                          titleKey, // Pass stable identifier for 24-hour tracking
                      category: habitData['category'] as String,
                      difficulty: difficulty,
                      difficultyColor: difficultyColor,
                      impact: impact,
                      impactColor: impactColor,
                      context: context,
                    );

                    EcoToast.show(
                      context,
                      message: result['message'] as String,
                      isSuccess: result['success'] as bool,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedCategory(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'All':
        return l10n.all;
      case 'Transport':
        return l10n.transport;
      case 'Food':
        return l10n.food;
      case 'Home':
        return l10n.home;
      case 'Water':
        return l10n.water;
      case 'Shopping':
        return l10n.shopping;
      case 'Waste':
        return l10n.waste;
      case 'Digital':
        return l10n.digital;
      case 'Fitness':
        return l10n.fitness;
      case 'Mindfulness':
        return l10n.mindfulness;
      case 'Savings':
        return l10n.savings;
      default:
        return category;
    }
  }

  String _getLocalizedDifficulty(BuildContext context, String difficulty) {
    final l10n = AppLocalizations.of(context)!;
    switch (difficulty) {
      case 'Easy':
        return l10n.easy;
      case 'Medium':
        return l10n.medium;
      default:
        return difficulty;
    }
  }

  String _getLocalizedImpact(BuildContext context, String impact) {
    final l10n = AppLocalizations.of(context)!;
    switch (impact) {
      case 'High Impact':
        return l10n.highImpact;
      case 'Medium Impact':
        return l10n.mediumImpact;
      case 'Low Impact':
        return l10n.lowImpact;
      default:
        return impact;
    }
  }

  String _getLocalizedTitle(BuildContext context, String titleKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (titleKey) {
      case 'cycleToWork':
        return l10n.cycleToWork;
      case 'usePublicTransport':
        return l10n.usePublicTransport;
      case 'carpoolWithColleagues':
        return l10n.carpoolWithColleagues;
      case 'walkShortDistances':
        return l10n.walkShortDistances;
      case 'maintainBikeRegularly':
        return l10n.maintainBikeRegularly;
      case 'buyBulkFood':
        return l10n.buyBulkFood;
      case 'compostKitchenWaste':
        return l10n.compostKitchenWaste;
      case 'plantAMiniGarden':
        return l10n.plantAMiniGarden;
      case 'reducePackagedFood':
        return l10n.reducePackagedFood;
      case 'chooseSeasonalFruits':
        return l10n.chooseSeasonalFruits;
      case 'coldWaterWash':
        return l10n.coldWaterWash;
      case 'switchOffUnusedLights':
        return l10n.switchOffUnusedLights;
      case 'useEnergyEfficientBulbs':
        return l10n.useEnergyEfficientBulbs;
      case 'airDryClothes':
        return l10n.airDryClothes;
      case 'useNaturalVentilation':
        return l10n.useNaturalVentilation;
      case 'shorterShowers':
        return l10n.shorterShowers;
      case 'fixWaterLeaks':
        return l10n.fixWaterLeaks;
      case 'collectRainwaterForPlants':
        return l10n.collectRainwaterForPlants;
      case 'reuseROWater':
        return l10n.reuseROWater;
      case 'turnOffTapWhileBrushing':
        return l10n.turnOffTapWhileBrushing;
      case 'carryReusableBags':
        return l10n.carryReusableBags;
      case 'buyRecycledProducts':
        return l10n.buyRecycledProducts;
      case 'avoidFastFashion':
        return l10n.avoidFastFashion;
      case 'chooseEcoFriendlyBrands':
        return l10n.chooseEcoFriendlyBrands;
      case 'supportLocalBusiness':
        return l10n.supportLocalBusiness;
      case 'reduceScreenTime':
        return l10n.reduceScreenTime;
      case 'unsubscribeUnwantedMails':
        return l10n.unsubscribeUnwantedMails;
      case 'cloudBackupCleanup':
        return l10n.cloudBackupCleanup;
      case 'turnOffAutoPlay':
        return l10n.turnOffAutoPlay;
      case 'digitalMindfulBreaks':
        return l10n.digitalMindfulBreaks;
      case 'morningWalk':
        return l10n.morningWalk;
      case 'practiceYoga':
        return l10n.practiceYoga;
      case 'healthySleepRoutine':
        return l10n.healthySleepRoutine;
      case 'drink2LWater':
        return l10n.drink2LWater;
      case 'avoidJunkSnacks':
        return l10n.avoidJunkSnacks;
      case 'meditation5MinDay':
        return l10n.meditation5MinDay;
      case 'practiceGratitudeJournaling':
        return l10n.practiceGratitudeJournaling;
      case 'breathingExercise':
        return l10n.breathingExercise;
      case 'spendTimeInNature':
        return l10n.spendTimeInNature;
      case 'limitNegativeNews':
        return l10n.limitNegativeNews;
      case 'trackExpenses':
        return l10n.trackExpenses;
      case 'monthlySavingsGoal':
        return l10n.monthlySavingsGoal;
      case 'avoidImpulseBuying':
        return l10n.avoidImpulseBuying;
      case 'investInSIP':
        return l10n.investInSIP;
      case 'useCashBackResponsibly':
        return l10n.useCashBackResponsibly;
      default:
        return titleKey;
    }
  }
}
