import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/real_firebase_service.dart';
import 'profile_controller.dart';
class EditProfileController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  late TextEditingController nameController;
  late TextEditingController mobileController;
  final RxBool isLoading = false.obs;
  final RxBool isUploadingImage = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxString selectedImagePath = ''.obs;
  final RxString uploadedImageUrl = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString selectedGender = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    final user = profileController.user.value;
    nameController = TextEditingController(text: user?.name ?? '');
    mobileController = TextEditingController(text: user?.phone ?? '');
    selectedDate.value = user?.dateOfBirth;
    selectedGender.value = user?.gender ?? '';
    uploadedImageUrl.value = user?.image ?? '';
  }
  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    super.onClose();
  }
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    if (value.trim().length < 10) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }
  void selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value ?? DateTime(1999, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }
  void selectGender(String gender) {
    selectedGender.value = gender;
  }
  void showImageSourceBottomSheet() {
    Get.bottomSheet(
      Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await RealFirebaseService.pickImageFromCamera();
      if (image != null) {
        selectedImagePath.value = image.path;
        await _uploadProfileImage(image);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await RealFirebaseService.pickImageFromGallery();
      if (image != null) {
        selectedImagePath.value = image.path;
        await _uploadProfileImage(image);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  Future<void> _uploadProfileImage(XFile imageFile) async {
    try {
      isUploadingImage.value = true;
      uploadProgress.value = 0.0;
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false, // Prevent closing during upload
          child: AlertDialog(
            title: const Text('Uploading Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => LinearProgressIndicator(
                  value: uploadProgress.value,
                )),
                const SizedBox(height: 16),
                Obx(() => Text('${(uploadProgress.value * 100).toInt()}%')),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
      final String imageUrl = await RealFirebaseService.uploadImage(
        File(imageFile.path),
        profileController.user.value?.id ?? 'demo_user',
        onProgress: (progress) {
          uploadProgress.value = progress;
        },
      );
      uploadedImageUrl.value = imageUrl;
      Get.back(); // Close progress dialog
      Get.snackbar(
        'Success',
        'Profile image uploaded successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.back(); // Close progress dialog
      selectedImagePath.value = ''; // Reset selected image on error
      Get.snackbar(
        'Upload Failed',
        'Failed to upload image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isUploadingImage.value = false;
      uploadProgress.value = 0.0;
    }
  }
  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (selectedDate.value == null) {
      Get.snackbar(
        'Error', 
        'Please select your date of birth',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        'Error', 
        'Please select your gender',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    try {
      isLoading.value = true;
      await profileController.updateProfile(
        name: nameController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        dateOfBirth: selectedDate.value,
        gender: selectedGender.value,
        profileImageUrl: uploadedImageUrl.value, // Use uploaded image URL
      );
      Get.back(); // Go back to profile screen
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Failed to save profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  void cancelEdit() {
    Get.back();
  }
}
