import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final leafHeight = 120.h;
    // Safe area bottom inset (Android 3-button nav / iPhone home indicator)
    final bottomSafeInset = ScreenUtil().bottomBarHeight;
    // Extra space so the last button/content can scroll fully above the leaf images + system bar
    final scrollBottomPadding = leafHeight + bottomSafeInset + 16.h;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F5),
      body: Stack(
        children: [
          // Bottom leaf decorations - Exact bottom background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: true,
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
                        height: leafHeight,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/right.png',
                        fit: BoxFit.fitHeight,
                        height: leafHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main content - On top of background
          SafeArea(
            bottom: true,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    // Add bottom padding so content can scroll above the leaf images
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      0,
                      20.w,
                      scrollBottomPadding,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 22.sp,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // Header Section
                        Text(
                          AppLocalizations.of(context)!.setUpYourProfile,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.letsPersonalizeYourEcoJourney,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text('🌿', style: TextStyle(fontSize: 14.sp)),
                          ],
                        ),
                        SizedBox(height: 32.h),

                        // Profile Picture Picker
                        _buildProfilePicturePicker(),
                        SizedBox(height: 20.h),

                        // Input Card
                        _buildInputCard(),
                        SizedBox(height: 16.h),
                      ],
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
              leading: Icon(Icons.photo_library, size: 22.sp),
              title: Text(
                AppLocalizations.of(context)!.chooseFromGallery,
                style: TextStyle(fontSize: 14.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, size: 22.sp),
              title: Text(
                AppLocalizations.of(context)!.takeAPhoto,
                style: TextStyle(fontSize: 14.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, size: 22.sp),
              title: Text(
                AppLocalizations.of(context)!.useDefaultImage,
                style: TextStyle(fontSize: 14.sp),
              ),
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
                  width: 160.w,
                  height: 160.h,
                  fit: BoxFit.contain,
                ),
              ),
              // Inner profile image inside a circular mask
              Container(
                width: 100.w,
                height: 100.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipOval(
                  child: _isUsingDefaultImage || _selectedImagePath == null
                      ? Image.asset(
                          'assets/profile.png',
                          fit: BoxFit.cover,
                          width: 100.w,
                          height: 100.h,
                        )
                      : Image.file(
                          File(_selectedImagePath!),
                          fit: BoxFit.cover,
                          width: 100.w,
                          height: 100.h,
                        ),
                ),
              ),
              // Camera badge - positioned slightly more right and up
              Positioned(
                bottom: 8.h,
                right: 12.w,
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/camera.svg',
                      width: 18.w,
                      height: 18.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.tapToUploadPhoto,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black54,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.yourName,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              hintText: AppLocalizations.of(context)!.nameHint,
              hintStyle: TextStyle(color: Colors.black38, fontSize: 14.sp),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CircleAvatar(
                  radius: 14.r,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile.png',
                      fit: BoxFit.cover,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 14.h,
              ),
            ),
            style: TextStyle(fontSize: 14.sp),
          ),
          SizedBox(height: 20.h),
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
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context)!.continueButton,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
