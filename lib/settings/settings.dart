import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import '../core/services/locale_service.dart';
import '../core/services/habit_service.dart';
import '../core/widgets/eco_toast.dart';
import '../profile/edit_profile.dart';
import 'language_selection.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
        onTap: () {
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
            SettingsScreen._getLanguageName(currentLocale.languageCode),
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
            ),
          );
        },
        onTap: () {
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
        onTap: () {
          // TODO: Implement share functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.shareFunctionalityComingSoon,
              ),
            ),
          );
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/rate.svg',
        title: AppLocalizations.of(context)!.rateUs,
        onTap: () {
          // Ensure context is still valid before opening external URL
          if (!context.mounted) return;
          _openExternal(
            context,
            'https://play.google.com/store/apps/details?id=com.ecohabittracker.app',
          );
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/share.svg',
        title: AppLocalizations.of(context)!.moreApps,
        onTap: () {
          // Ensure context is still valid before opening external URL
          if (!context.mounted) return;
          // Link to Play Store developer page showing all apps
          _openExternal(
            context,
            'https://play.google.com/store/apps/developer?id=Funloft+Production',
          );
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/support.svg',
        title: AppLocalizations.of(context)!.support,
        onTap: () =>
            _openExternal(context, 'mailto:support@ecohabittracker.com'),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/support.svg',
        title: AppLocalizations.of(context)!.feedback,
        onTap: () =>
            _openExternal(context, 'mailto:feedback@ecohabittracker.com'),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/privacypolicy.svg',
        title: AppLocalizations.of(context)!.privacyPolicy,
        onTap: () => _openExternal(
          context,
          'https://sites.google.com/view/ecohabittracker/privacy-policy',
        ),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/terms.svg',
        title: AppLocalizations.of(context)!.termsOfService,
        onTap: () => _openExternal(
          context,
          'https://sites.google.com/view/ecohabittracker/terms-of-service',
        ),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/logout.svg',
        title: AppLocalizations.of(context)!.resetAllProgress,
        onTap: () {
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
            return _SettingsTile(option: option);
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
  final VoidCallback? onTap;
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.option});

  final _SettingsOption option;

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
        onTap: option.onTap,
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
                  child: SvgPicture.asset(
                    option.iconPath,
                    width: 22.w,
                    height: 22.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF2E7D32),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(child: Text(option.title, style: textStyle)),
              if (option.trailingBuilder != null)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: option.trailingBuilder!(context),
                ),
              Icon(Icons.chevron_right, color: Color(0xFF2E7D32), size: 22.sp),
            ],
          ),
        ),
      ),
    );
  }
}
