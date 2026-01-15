import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:habit_tracker/l10n/app_localizations.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../core/services/profile_service.dart';
import '../core/widgets/eco_toast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isUsingDefaultImage = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // Load current profile data
    final profileService = Provider.of<ProfileService>(context, listen: false);
    final currentName = profileService.getUserName();
    final currentImagePath = profileService.getProfileImagePath();

    _nameController = TextEditingController(text: currentName);
    _selectedImagePath = currentImagePath;
    _isUsingDefaultImage = currentImagePath == null;

    // Listen for text changes
    _nameController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final profileService = Provider.of<ProfileService>(context, listen: false);
    final currentName = profileService.getUserName();
    final currentImagePath = profileService.getProfileImagePath();

    final nameChanged = _nameController.text.trim() != currentName;

    // Check if image changed:
    // - If user is using default image now but had custom image before
    // - If user is using custom image now but had default image before
    // - If both are custom images but paths are different
    final currentIsDefault = currentImagePath == null;
    final newIsDefault = _isUsingDefaultImage || _selectedImagePath == null;

    final imageChanged =
        (currentIsDefault != newIsDefault) ||
        (!newIsDefault && currentImagePath != _selectedImagePath);

    setState(() {
      _hasChanges = nameChanged || imageChanged;
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkForChanges);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leafHeight = 120.h;
    final bottomSafeInset = ScreenUtil().bottomBarHeight;
    final scrollBottomPadding = leafHeight + bottomSafeInset + 16.h;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 22.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.editProfile,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Bottom leaf decorations
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

          // Main content
          SafeArea(
            bottom: true,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
        // Validate that the image contains a human face
        final hasFace = await _validateFaceInImage(image.path);

        if (!hasFace) {
          if (mounted) {
            EcoToast.show(
              context,
              message: AppLocalizations.of(context)!.noFaceDetected,
              isSuccess: false,
            );
          }
          return;
        }

        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(image.path);
        final savedImage = File(path.join(appDir.path, fileName));
        await File(image.path).copy(savedImage.path);

        setState(() {
          _selectedImagePath = savedImage.path;
          _isUsingDefaultImage = false;
        });
        _checkForChanges();
      }
    } catch (e) {
      if (mounted) {
        EcoToast.show(
          context,
          message: AppLocalizations.of(
            context,
          )!.errorPickingImage(e.toString()),
          isSuccess: false,
        );
      }
    }
  }

  /// Validate that the image contains at least one human face
  Future<bool> _validateFaceInImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: false,
          enableLandmarks: false,
          enableClassification: false,
          enableTracking: false,
          minFaceSize: 0.1,
          performanceMode: FaceDetectorMode.fast,
        ),
      );

      final List<Face> faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();

      // Return true if at least one face is detected
      return faces.isNotEmpty;
    } catch (e) {
      // If face detection fails, reject the image for safety
      return false;
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
                _checkForChanges();
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
              Opacity(
                opacity: 0.85,
                child: Image.asset(
                  'assets/ellipse.png',
                  width: 160.w,
                  height: 160.h,
                  fit: BoxFit.contain,
                ),
              ),
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
              onPressed: _hasChanges
                  ? () async {
                      if (_nameController.text.trim().isNotEmpty) {
                        final profileService = Provider.of<ProfileService>(
                          context,
                          listen: false,
                        );
                        await profileService.saveProfile(
                          name: _nameController.text.trim(),
                          imagePath: _isUsingDefaultImage
                              ? null
                              : _selectedImagePath,
                        );

                        if (mounted) {
                          EcoToast.show(
                            context,
                            message: AppLocalizations.of(
                              context,
                            )!.profileUpdatedSuccessfully,
                            isSuccess: true,
                          );
                          Navigator.of(context).pop();
                        }
                      } else {
                        EcoToast.show(
                          context,
                          message: AppLocalizations.of(
                            context,
                          )!.pleaseEnterYourName,
                          isSuccess: false,
                        );
                      }
                    }
                  : null,
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
                AppLocalizations.of(context)!.saveChanges,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
