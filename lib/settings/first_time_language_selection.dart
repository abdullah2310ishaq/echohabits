import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import '../core/services/profile_service.dart';
import '../core/services/locale_service.dart';
import '../onboarding/onboarding.dart';
import '../home/home_shell.dart';
import '../profile_first.dart';

class FirstTimeLanguageSelectionScreen extends StatefulWidget {
  const FirstTimeLanguageSelectionScreen({super.key});

  @override
  State<FirstTimeLanguageSelectionScreen> createState() =>
      _FirstTimeLanguageSelectionScreenState();
}

class _FirstTimeLanguageSelectionScreenState
    extends State<FirstTimeLanguageSelectionScreen> {
  String? _selectedLanguage;

  final List<Map<String, dynamic>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'imageAsset': 'assets/language/usa.svg',
      'isPng': false,
    },
    {
      'code': 'es',
      'name': 'Spanish',
      'nativeName': 'Español',
      'imageAsset': 'assets/language/espanol.svg',
      'isPng': false,
    },
    {
      'code': 'fr',
      'name': 'French',
      'nativeName': 'Français',
      'imageAsset': 'assets/language/french.svg',
      'isPng': false,
    },
    {
      'code': 'de',
      'name': 'German',
      'nativeName': 'Deutsch',
      'imageAsset': 'assets/language/german.svg',
      'isPng': false,
    },
    {
      'code': 'it',
      'name': 'Italian',
      'nativeName': 'Italiano',
      'imageAsset': 'assets/language/italian.svg',
      'isPng': false,
    },
    {
      'code': 'pt',
      'name': 'Portuguese',
      'nativeName': 'Português',
      'imageAsset': 'assets/portugal.png',
      'isPng': true,
    },
    {
      'code': 'ru',
      'name': 'Russian',
      'nativeName': 'Русский',
      'imageAsset': 'assets/language/russia.svg',
      'isPng': false,
    },
    {
      'code': 'zh',
      'name': 'Chinese',
      'nativeName': '中文',
      'imageAsset': 'assets/language/china.svg',
      'isPng': false,
    },
    {
      'code': 'ja',
      'name': 'Japanese',
      'nativeName': '日本語',
      'imageAsset': 'assets/language/japan.svg',
      'isPng': false,
    },
    {
      'code': 'ko',
      'name': 'Korean',
      'nativeName': '한국어',
      'imageAsset': 'assets/language/korea.svg',
      'isPng': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Get current locale from service
    final localeService = Provider.of<LocaleService>(context, listen: false);
    _selectedLanguage = localeService.getCurrentLocale().languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(), // No close button for first time
        title: Text(
          AppLocalizations.of(context)?.chooseALanguage ?? 'Choose a Language',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: _selectedLanguage != null
                  ? () async {
                      final localeService = Provider.of<LocaleService>(
                        context,
                        listen: false,
                      );
                      await localeService.setLocaleByCode(_selectedLanguage!);
                      if (context.mounted) {
                        _navigateToNextScreen();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context)?.next ?? 'Next',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _languages.length,
          itemBuilder: (context, index) {
            final language = _languages[index];
            final isSelected = _selectedLanguage == language['code'];
            return _buildLanguageCard(
              language: language,
              isSelected: isSelected,
            );
          },
        ),
      ),
    );
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    final isProfileSetup = ProfileService.isProfileSetupComplete();
    final isOnboardingComplete = ProfileService.isOnboardingComplete();

    final Widget nextScreen = !isOnboardingComplete
        ? const OnboardingScreen()
        : (isProfileSetup ? const HomeShell() : const ProfileFirst());

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  Widget _buildLanguageCard({
    required Map<String, dynamic> language,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = language['code'] as String;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Flag Icon
              SizedBox( 
                width: 32,
                height: 32,
                child: (language['isPng'] as bool? ?? false)
                    ? Image.asset(
                        language['imageAsset'] as String,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                        errorBuilder: (context, _, __) => Text(
                          language['name'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : SvgPicture.asset(
                        language['imageAsset'] as String,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                        // Graceful fallback if an asset fails to load
                        placeholderBuilder: (context) => const SizedBox.shrink(),
                        errorBuilder: (context, _, __) => Text(
                          language['name'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              // Language Name
              Expanded(
                child: Text(
                  language['nativeName'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? const Color(0xFF2E7D32)
                        : Colors.black87,
                  ),
                ),
              ),
              // Selection Indicator
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E7D32),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
