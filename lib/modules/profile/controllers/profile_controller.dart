import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/real_firebase_service.dart';
import '../../../data/models/user_model.dart';
class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxString errorMessage = ''.obs;
  static const String fixedUserId = 'Drl8VATGG8swOjJjKmBD';
  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      UserModel? userData = await RealFirebaseService.getUser(fixedUserId);
      if (userData == null) {
        userData = UserModel(
          id: fixedUserId,
          name: 'Madison Smith',
          email: 'Madison@Example.Com',
          image: '', // Empty string to use default avatar
          phone: '+123 4567 890',
          dateOfBirth: DateTime(1999, 4, 1),
          gender: 'Female',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await RealFirebaseService.createUser(fixedUserId, userData);
      } else {
      }
      user.value = userData;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error', 
        'Failed to load profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      user.value = UserModel(
        id: 'demo_user',
        name: 'Madison Smith',
        email: 'Madison@Example.Com',
        image: '', // Empty string to use default avatar
        phone: '+123 4567 890',
        dateOfBirth: DateTime(1999, 4, 1),
        gender: 'Female',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> updateProfile({
    String? name,
    String? email,
    String? mobileNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? profileImageUrl,
  }) async {
    if (user.value == null) return;
    try {
      isLoading.value = true;
      UserModel updatedUser = UserModel(
        id: user.value!.id,
        name: name ?? user.value!.name,
        email: email ?? user.value!.email,
        image: profileImageUrl ?? user.value!.image,
        phone: mobileNumber ?? user.value!.phone,
        dateOfBirth: dateOfBirth ?? user.value!.dateOfBirth,
        gender: gender ?? user.value!.gender,
        createdAt: user.value!.createdAt,
        updatedAt: DateTime.now(),
      );
      await RealFirebaseService.updateUser(user.value!.id, updatedUser);
      user.value = updatedUser;
      Get.snackbar(
        'Success', 
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error', 
        'Failed to update profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> updateProfilePicture() async {
    try {
      isLoading.value = true;
      String newProfileImageUrl = await RealFirebaseService.uploadImage(
        File('demo_image_path'), 
        user.value!.id
      );
      await updateProfile(profileImageUrl: newProfileImageUrl);
      Get.snackbar(
        'Success', 
        'Profile picture updated!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Failed to update profile picture: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  void refreshProfile() {
    loadUserProfile();
  }
  void logout() {
    Get.snackbar(
      'Info', 
      'Logout functionality - Demo Mode',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}
