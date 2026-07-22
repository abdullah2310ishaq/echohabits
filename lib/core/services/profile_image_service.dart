import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:habit_tracker/core/ads/app_open_ad_manager.dart';

enum ProfileImagePickError {
  cancelled,
  noFaceDetected,
  failed,
}

class ProfileImagePickResult {
  const ProfileImagePickResult({
    this.imagePath,
    this.error,
    this.errorMessage,
  });

  final String? imagePath;
  final ProfileImagePickError? error;
  final String? errorMessage;

  bool get isSuccess => imagePath != null && error == null;
}

class ProfileImageService {
  ProfileImageService._();

  static final ImagePicker _imagePicker = ImagePicker();

  static Future<ProfileImagePickResult> pickFromGalleryAndCrop(
    BuildContext context,
  ) async {
    try {
      AppOpenAdManager.suppressNextResumeOnce();
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) {
        return const ProfileImagePickResult(
          error: ProfileImagePickError.cancelled,
        );
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: const Color(0xFF2E7D32),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) {
        return const ProfileImagePickResult(
          error: ProfileImagePickError.cancelled,
        );
      }

      final hasFace = await _validateFaceInImage(croppedFile.path);
      if (!hasFace) {
        return const ProfileImagePickResult(
          error: ProfileImagePickError.noFaceDetected,
        );
      }

      final savedPath = await _saveToAppDirectory(croppedFile.path);
      return ProfileImagePickResult(imagePath: savedPath);
    } catch (error) {
      return ProfileImagePickResult(
        error: ProfileImagePickError.failed,
        errorMessage: error.toString(),
      );
    }
  }

  static Future<String> _saveToAppDirectory(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final extension = path.extension(sourcePath);
    final fileName =
        'profile_${DateTime.now().millisecondsSinceEpoch}$extension';
    final savedImage = File(path.join(appDir.path, fileName));
    await File(sourcePath).copy(savedImage.path);
    return savedImage.path;
  }

  static Future<bool> _validateFaceInImage(String imagePath) async {
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

      final faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();

      return faces.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
