import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import '../core/services/locale_service.dart';
import '../core/services/habit_service.dart';
import '../core/widgets/eco_toast.dart';
import '../profile/edit_profile.dart';
import 'language_selection.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ValueNotifier<bool> _tapGateLocked = ValueNotifier<bool>(false);

  Future<void> _openExternal(BuildContext context, String url) async {
    if (!context.mounted) return;

    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.couldNotOpenLink),
          ),
        );
      }
      
    } catch (e) {
      // Handle any errors silently to prevent navigation issues
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.couldNotOpenLink),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      _SettingsOption(
        iconPath: 'assets/settings/accounts.svg',
        title: AppLocalizations.of(context)!.editProfile,
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          );
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/language.svg',
        title: AppLocalizations.of(context)!.language,
        trailingBuilder: (_) {
          final localeService = Provider.of<LocaleService>(
            context,
            listen: false,
          );
          final currentLocale = localeService.getCurrentLocale();
          return Text(
            _getLanguageName(currentLocale.languageCode),
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
            ),
          );
        },
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LanguageSelectionScreen(),
            ),
          );
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/share.svg',
        title: AppLocalizations.of(context)!.shareApp,
        onTap: () async {
          const appLink =
              'https://play.google.com/store/apps/details?id=com.eco.habit.tracker.companion';
          Share.share('Check out Eco Habit Tracker: $appLink');
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/rate.svg',
        title: AppLocalizations.of(context)!.rateUs,
        onTap: () async {
          // Ensure context is still valid before opening external URL
          if (!context.mounted) return;
          await _openExternal(
            context,
            'https://play.google.com/store/apps/details?id=com.eco.habit.tracker.companion',
          );
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/share.svg',
        title: AppLocalizations.of(context)!.moreApps,
        onTap: () async {
          // Ensure context is still valid before opening external URL
          if (!context.mounted) return;
          // Link to Play Store developer page showing all apps
          await _openExternal(
            context,
            'https://play.google.com/store/search?q=pub%3ACodix%20Apps&c=apps',
          );
        },
      ),

      _SettingsOption(
        iconPath: 'assets/feedback.png',
        title: AppLocalizations.of(context)!.feedback,
        onTap: () async =>
            _openExternal(context, 'mailto:islam24hoursstudio@gmail.com'),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/privacypolicy.svg',
        title: AppLocalizations.of(context)!.privacyPolicy,
        onTap: () async => _openExternal(
          context,
          'https://sites.google.com/view/eco-habit-tracker/privacy-policy',
        ),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/terms.svg',
        title: AppLocalizations.of(context)!.communityGuidelines,
        onTap: () async => _openExternal(
          context,
          'https://sites.google.com/view/eco-habit-tracker/community-guidelines',
        ),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/logout.svg',
        title: AppLocalizations.of(context)!.resetAllProgress,
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Container(
                width: 0.85.sw,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.resetAllProgress,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.areYouSureYouWantToResetAllProgress,
                      style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final habitService = Provider.of<HabitService>(
                                context,
                                listen: false,
                              );
                              await habitService.resetAllProgress();
                              if (context.mounted) {
                                EcoToast.show(
                                  context,
                                  message: AppLocalizations.of(
                                    context,
                                  )!.progressResetSuccessfully,
                                  isSuccess: true,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              elevation: 0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.resetAllProgress,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // _SettingsOption(
      //   iconPath: 'assets/settings/logout.svg',
      //   title: AppLocalizations.of(context)!.logout,
      //   onTap: () {
      //     // TODO: Implement logout functionality
      //     showDialog(
      //       context: context,
      //       builder: (context) => Dialog(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(16.r),
      //         ),
      //         child: Container(
      //           width: 0.85.sw,
      //           padding: EdgeInsets.all(16.w),
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Text(
      //                 AppLocalizations.of(context)!.logout,
      //                 style: TextStyle(
      //                   fontSize: 18.sp,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.black87,
      //                 ),
      //               ),
      //               SizedBox(height: 12.h),
      //               Text(
      //                 AppLocalizations.of(context)!.areYouSureYouWantToLogout,
      //                 style: TextStyle(fontSize: 13.sp, color: Colors.black54),
      //                 textAlign: TextAlign.center,
      //               ),
      //               SizedBox(height: 16.h),
      //               Row(
      //                 children: [
      //                   Expanded(
      //                     child: OutlinedButton(
      //                       onPressed: () => Navigator.of(context).pop(),
      //                       style: OutlinedButton.styleFrom(
      //                         foregroundColor: Colors.black87,
      //                         side: BorderSide(color: Colors.grey[300]!),
      //                         shape: RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(10.r),
      //                         ),
      //                         padding: EdgeInsets.symmetric(vertical: 12.h),
      //                       ),
      //                       child: Text(
      //                         AppLocalizations.of(context)!.cancel,
      //                         style: TextStyle(
      //                           fontSize: 14.sp,
      //                           fontWeight: FontWeight.w600,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(width: 10.w),
      //                   Expanded(
      //                     child: ElevatedButton(
      //                       onPressed: () {
      //                         Navigator.of(context).pop();
      //                         // TODO: Handle logout
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           SnackBar(
      //                             content: Text(
      //                               AppLocalizations.of(
      //                                 context,
      //                               )!.logoutFunctionalityComingSoon,
      //                             ),
      //                           ),
      //                         );
      //                       },
      //                       style: ElevatedButton.styleFrom(
      //                         backgroundColor: Colors.red,
      //                         foregroundColor: Colors.white,
      //                         shape: RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(10.r),
      //                         ),
      //                         padding: EdgeInsets.symmetric(vertical: 12.h),
      //                         elevation: 0,
      //                       ),
      //                       child: Text(
      //                         AppLocalizations.of(context)!.logout,
      //                         style: TextStyle(
      //                           fontSize: 14.sp,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemBuilder: (context, index) {
            final option = options[index];
            return _SettingsTile(option: option, tapGateLocked: _tapGateLocked);
          },
          separatorBuilder: (_, __) => Divider(
            height: 1.h,
            thickness: 1.h,
            color: Colors.grey[300],
            indent: 16.w, // align with list padding
            endIndent: 16.w, // align with list padding
          ),
          itemCount: options.length,
        ),
      ),
    );
  }

  static String _getLanguageName(String code) {
    const languageNames = {
      'en': 'English',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
      'it': 'Italiano',
      'pt': 'Português',
      'ru': 'Русский',
      'zh': '中文',
      'ja': '日本語',
      'ko': '한국어',
      'ar': 'العربية',
    };
    return languageNames[code] ?? 'English';
  }

  @override
  void dispose() {
    _tapGateLocked.dispose();
    super.dispose();
  }
}

class _SettingsOption {
  _SettingsOption({
    required this.iconPath,
    required this.title,
    this.trailingBuilder,
    this.onTap,
  });

  final String iconPath;
  final String title;
  final WidgetBuilder? trailingBuilder;
  final Future<void> Function()? onTap;
}

class _SettingsTile extends StatefulWidget {
  const _SettingsTile({required this.option, required this.tapGateLocked});

  final _SettingsOption option;
  final ValueNotifier<bool> tapGateLocked;

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  Future<void> _handleTap() async {
    final onTap = widget.option.onTap;
    if (onTap == null) return;
    if (widget.tapGateLocked.value) return;

    widget.tapGateLocked.value = true;
    try {
      // Run the tap action once.
      await onTap();
    } finally {
      // Small debounce window to prevent double triggers.
      await Future<void>.delayed(const Duration(milliseconds: 450));
      widget.tapGateLocked.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: Color(0xFF2E7D32),
    );
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: InkWell(
        onTap: widget.option.onTap == null ? null : _handleTap,
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.grey.withOpacity(0.05),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: const BoxDecoration(),
                child: Center(
                  child: widget.option.iconPath.toLowerCase().endsWith('.svg')
                      ? SvgPicture.asset(
                          widget.option.iconPath,
                          width: 22.w,
                          height: 22.h,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF2E7D32),
                            BlendMode.srcIn,
                          ),
                        )
                      : Image.asset(
                          widget.option.iconPath,
                          width: 22.w,
                          height: 22.h,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(child: Text(widget.option.title, style: textStyle)),
              if (widget.option.trailingBuilder != null)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: widget.option.trailingBuilder!(context),
                ),
              Icon(Icons.chevron_right, color: Color(0xFF2E7D32), size: 22.sp),
            ],
          ),
        ),
      ),
    );
  }
}
