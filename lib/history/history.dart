import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/services/habit_service.dart';
import '../l10n/app_localizations.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String _selectedFilter = 'weekly';

  @override
  Widget build(BuildContext context) {
    final habitService = Provider.of<HabitService>(context);
    final l10n = AppLocalizations.of(context)!;
    // Filter to show only completed tasks (status == 'done')
    final history = habitService.history
        .where((item) => item['status'] == 'done')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 22.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.history,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Filter Bar
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  _buildFilterButton(context, 'weekly', l10n.weekly),
                  SizedBox(width: 10.w),
                  _buildFilterButton(context, 'monthly', l10n.monthly),
                  SizedBox(width: 10.w),
                  _buildFilterButton(context, 'allTime', l10n.allTime),
                ],
              ),
            ),
            // History List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 0,
                  bottom: 24
                      .h, // Extra bottom padding to prevent cards from being hidden
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  final String storedTitle = item['title'] as String;
                  final DateTime timestamp = item['timestamp'] as DateTime;
                  
                  // Localize the habit title if it's a known habit
                  final String localizedTitle = _getLocalizedHabitTitle(context, storedTitle);

                  // Format date as "Wednesday, January 14" (day name + month name + day)
                  // Use locale from Localizations to format dates correctly
                  final locale = Localizations.localeOf(context);
                  final dateFormatter = DateFormat('EEEE, MMMM d', locale.toString());
                  final String dateLabel = dateFormatter.format(timestamp);

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _buildHistoryCard(
                      habit: localizedTitle,
                      date: dateLabel,
                      isDone: true, // Only showing completed items
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = filterKey;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[200],
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  /// Get localized habit title by matching stored title against English versions
  String _getLocalizedHabitTitle(BuildContext context, String storedTitle) {
    final l10n = AppLocalizations.of(context)!;
    
    // Map of English titles to localization getters
    // This handles habits stored in English or other languages
    final Map<String, String Function()> titleMap = {
      // Habit titles
      'Cycle to work': () => l10n.cycleToWork,
      'Use public transport': () => l10n.usePublicTransport,
      'Carpool with colleagues': () => l10n.carpoolWithColleagues,
      'Walk short distances': () => l10n.walkShortDistances,
      'Maintain bike regularly': () => l10n.maintainBikeRegularly,
      'Buy bulk food': () => l10n.buyBulkFood,
      'Compost kitchen waste': () => l10n.compostKitchenWaste,
      'Plant a mini garden': () => l10n.plantAMiniGarden,
      'Reduce packaged food': () => l10n.reducePackagedFood,
      'Choose seasonal fruits': () => l10n.chooseSeasonalFruits,
      'Cold water wash': () => l10n.coldWaterWash,
      'Switch off unused lights': () => l10n.switchOffUnusedLights,
      'Use energy-efficient bulbs': () => l10n.useEnergyEfficientBulbs,
      'Air dry clothes': () => l10n.airDryClothes,
      'Use natural ventilation': () => l10n.useNaturalVentilation,
      'Shorter showers': () => l10n.shorterShowers,
      'Fix water leaks': () => l10n.fixWaterLeaks,
      'Collect rainwater for plants': () => l10n.collectRainwaterForPlants,
      'Reuse RO water': () => l10n.reuseROWater,
      'Turn off tap while brushing': () => l10n.turnOffTapWhileBrushing,
      'Carry reusable bags': () => l10n.carryReusableBags,
      'Buy recycled products': () => l10n.buyRecycledProducts,
      'Avoid fast fashion': () => l10n.avoidFastFashion,
      'Choose eco-friendly brands': () => l10n.chooseEcoFriendlyBrands,
      'Support local business': () => l10n.supportLocalBusiness,
      'Reduce screen time': () => l10n.reduceScreenTime,
      'Unsubscribe unwanted mails': () => l10n.unsubscribeUnwantedMails,
      'Cloud backup cleanup': () => l10n.cloudBackupCleanup,
      'Turn off auto-play': () => l10n.turnOffAutoPlay,
      'Digital mindful breaks': () => l10n.digitalMindfulBreaks,
      'Morning walk': () => l10n.morningWalk,
      'Practice yoga': () => l10n.practiceYoga,
      'Healthy sleep routine': () => l10n.healthySleepRoutine,
      'Drink 2L water': () => l10n.drink2LWater,
      'Avoid junk snacks': () => l10n.avoidJunkSnacks,
      'Meditation 5 min/day': () => l10n.meditation5MinDay,
      'Practice gratitude journaling': () => l10n.practiceGratitudeJournaling,
      'Breathing exercise': () => l10n.breathingExercise,
      'Spend time in nature': () => l10n.spendTimeInNature,
      'Limit negative news': () => l10n.limitNegativeNews,
      'Track expenses': () => l10n.trackExpenses,
      'Monthly savings goal': () => l10n.monthlySavingsGoal,
      'Avoid impulse buying': () => l10n.avoidImpulseBuying,
      'Invest in SIP': () => l10n.investInSIP,
      'Use cash-back responsibly': () => l10n.useCashBackResponsibly,
      // Default task titles
      'Walked/ Biked instead of driving': () => l10n.defaultWalkBikeTitle,
      'Used a reusable coffee cup': () => l10n.defaultCoffeeCupTitle,
      'Afforestation/ Plant a tree for better environment': () => l10n.defaultAfforestationTitle,
    };
    
    // Check if stored title matches English version
    if (titleMap.containsKey(storedTitle)) {
      return titleMap[storedTitle]!();
    }
    
    // Check if stored title matches current localized version
    // This handles cases where title is already in current language
    final currentLocalizedTitles = {
      l10n.cycleToWork,
      l10n.usePublicTransport,
      l10n.carpoolWithColleagues,
      l10n.walkShortDistances,
      l10n.maintainBikeRegularly,
      l10n.buyBulkFood,
      l10n.compostKitchenWaste,
      l10n.plantAMiniGarden,
      l10n.reducePackagedFood,
      l10n.chooseSeasonalFruits,
      l10n.coldWaterWash,
      l10n.switchOffUnusedLights,
      l10n.useEnergyEfficientBulbs,
      l10n.airDryClothes,
      l10n.useNaturalVentilation,
      l10n.shorterShowers,
      l10n.fixWaterLeaks,
      l10n.collectRainwaterForPlants,
      l10n.reuseROWater,
      l10n.turnOffTapWhileBrushing,
      l10n.carryReusableBags,
      l10n.buyRecycledProducts,
      l10n.avoidFastFashion,
      l10n.chooseEcoFriendlyBrands,
      l10n.supportLocalBusiness,
      l10n.reduceScreenTime,
      l10n.unsubscribeUnwantedMails,
      l10n.cloudBackupCleanup,
      l10n.turnOffAutoPlay,
      l10n.digitalMindfulBreaks,
      l10n.morningWalk,
      l10n.practiceYoga,
      l10n.healthySleepRoutine,
      l10n.drink2LWater,
      l10n.avoidJunkSnacks,
      l10n.meditation5MinDay,
      l10n.practiceGratitudeJournaling,
      l10n.breathingExercise,
      l10n.spendTimeInNature,
      l10n.limitNegativeNews,
      l10n.trackExpenses,
      l10n.monthlySavingsGoal,
      l10n.avoidImpulseBuying,
      l10n.investInSIP,
      l10n.useCashBackResponsibly,
      l10n.defaultWalkBikeTitle,
      l10n.defaultCoffeeCupTitle,
      l10n.defaultAfforestationTitle,
    };
    
    if (currentLocalizedTitles.contains(storedTitle)) {
      // Already in current language
      return storedTitle;
    }
    
    // If no match found, return stored title as-is (for custom habits or unknown titles)
    return storedTitle;
  }

  Widget _buildHistoryCard({
    required String habit,
    required String date,
    required bool isDone,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
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
          // Checkmark Icon
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: const Color(0xFF2E7D32),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // Habit Description and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  date,
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
