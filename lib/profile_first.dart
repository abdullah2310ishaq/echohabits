import 'package:flutter/material.dart';
import 'home/home_shell.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:habit_tracker/l10n/app_localizations.dart';
import '../core/services/profile_service.dart';

class ProfileFirst extends StatefulWidget {
  const ProfileFirst({super.key});

  @override
  State<ProfileFirst> createState() => _ProfileFirstState();
}

class _ProfileFirstState extends State<ProfileFirst> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isUsingDefaultImage = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F5),
      body: Stack(
        children: [
          // Bottom leaf decorations - Exact bottom background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      'assets/left.png',
                      fit: BoxFit.fitHeight,
                      height: 150,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      'assets/right.png',
                      fit: BoxFit.fitHeight,
                      height: 150,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content - On top of background
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Header Section
                        Text(
                          AppLocalizations.of(context)!.setUpYourProfile,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.letsPersonalizeYourEcoJourney,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text('🌿', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Profile Picture Picker
                        _buildProfilePicturePicker(),
                        const SizedBox(height: 24),

                        // Input Card
                        _buildInputCard(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Spacer to push content up, leaving space for leaf images
                const SizedBox(height: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        // Copy image to app directory for persistence
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(image.path);
        final savedImage = File(path.join(appDir.path, fileName));
        await File(image.path).copy(savedImage.path);

        setState(() {
          _selectedImagePath = savedImage.path;
          _isUsingDefaultImage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorPickingImage(e.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.takeAPhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(AppLocalizations.of(context)!.useDefaultImage),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedImagePath = null;
                  _isUsingDefaultImage = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicturePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ellipse image (lighter and slightly inset)
              Opacity(
                opacity: 0.85,
                child: Image.asset(
                  'assets/ellipse.png',
                  width: 190,
                  height: 190,
                  fit: BoxFit.contain,
                ),
              ),
              // Inner profile image inside a circular mask
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipOval(
                  child: _isUsingDefaultImage || _selectedImagePath == null
                      ? Image.asset('assets/profile.png', fit: BoxFit.cover)
                      : Image.file(
                          File(_selectedImagePath!),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              // Camera badge - positioned slightly more right and up
              Positioned(
                bottom: 10,
                right: 14,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/camera.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.tapToUploadPhoto,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black54,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.yourName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              hintText: AppLocalizations.of(context)!.nameHint,
              hintStyle: const TextStyle(color: Colors.black38),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile.png',
                      fit: BoxFit.cover,
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_nameController.text.trim().isNotEmpty) {
                  // Save profile data to Hive
                  await ProfileService.saveProfile(
                    name: _nameController.text.trim(),
                    imagePath: _isUsingDefaultImage ? null : _selectedImagePath,
                  );

                  if (mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeShell(),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.pleaseEnterYourName,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context)!.continueButton,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
