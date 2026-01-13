import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'language_selection.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openExternal(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      _SettingsOption(
        iconPath: 'assets/settings/accounts.svg',
        title: 'Account',
        onTap: () {
          // TODO: Navigate to account settings
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account settings coming soon')),
          );
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/language.svg',
        title: 'Language',
        trailingBuilder: (_) => const Text(
          'English',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LanguageSelectionScreen(),
            ),
          ).then((selectedLanguage) {
            if (selectedLanguage != null && context.mounted) {
              // TODO: Update app locale with selected language
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Language changed to $selectedLanguage'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          });
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/share.svg',
        title: 'Share App',
        onTap: () {
          // TODO: Implement share functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Share functionality coming soon')),
          );
        },
      ),
      _SettingsOption(
        iconPath: 'assets/settings/rate.svg',
        title: 'Rate Us',
        onTap: () => _openExternal(
          context,
          'https://play.google.com/store/apps/details?id=com.ecohabittracker.app',
        ),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/support.svg',
        title: 'Support',
        onTap: () => _openExternal(context, 'mailto:support@ecohabittracker.com'),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/privacypolicy.svg',
        title: 'Privacy Policy',
        onTap: () => _openExternal(
          context,
          'https://sites.google.com/view/ecohabittracker/privacy-policy',
        ),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/terms.svg',
        title: 'Terms of Service',
        onTap: () => _openExternal(
          context,
          'https://sites.google.com/view/ecohabittracker/terms-of-service',
        ),
      ),
      _SettingsOption(
        iconPath: 'assets/settings/logout.svg',
        title: 'Logout',
        onTap: () {
          // TODO: Implement logout functionality
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Are you sure you want to logout?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // TODO: Handle logout
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logout functionality coming soon'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
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
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          itemBuilder: (context, index) {
            final option = options[index];
            return _SettingsTile(option: option);
          },
          separatorBuilder: (_, __) => Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[300],
            indent: 50,
            endIndent: 0,
          ),
          itemCount: options.length,
        ),
      ),
    );
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
    final textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF2E7D32),
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: InkWell(
        onTap: option.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(),
                child: Center(
                  child: SvgPicture.asset(
                    option.iconPath,
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF2E7D32),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  option.title,
                  style: textStyle,
                ),
              ),
              if (option.trailingBuilder != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: option.trailingBuilder!(context),
                ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF2E7D32),
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
