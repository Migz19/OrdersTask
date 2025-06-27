import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_date_field.dart';
import '../../../core/widgets/custom_gender_field.dart';
import '../controllers/edit_profile_controller.dart';
class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(AppConstants.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.cancelEdit,
        ),
      ),
      body: Obx(() {
        return Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppConstants.cardColor,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          if (controller.selectedImagePath.value.isNotEmpty && 
                              !controller.selectedImagePath.value.startsWith('http'))
                            Container(
                              width: AppConstants.avatarSizeXLarge,
                              height: AppConstants.avatarSizeXLarge,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppConstants.dividerColor,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.file(
                                  File(controller.selectedImagePath.value),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppConstants.secondaryColor,
                                      child: Icon(
                                        Icons.person,
                                        size: AppConstants.avatarSizeXLarge * 0.6,
                                        color: AppConstants.primaryColor,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          else
                            CustomAvatar(
                              imageUrl: controller.uploadedImageUrl.value.isNotEmpty 
                                  ? controller.uploadedImageUrl.value 
                                  : '', // Use uploaded image URL or empty for default
                              size: AppConstants.avatarSizeXLarge,
                              showEditIcon: false,
                            ),
                          if (controller.isUploadingImage.value)
                            Container(
                              width: AppConstants.avatarSizeXLarge,
                              height: AppConstants.avatarSizeXLarge,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.7),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Uploading...',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: controller.isUploadingImage.value 
                                  ? null // Disable tap during upload
                                  : controller.showImageSourceBottomSheet,
                              child: Container(
                                width: AppConstants.iconSizeLarge,
                                height: AppConstants.iconSizeLarge,
                                decoration: BoxDecoration(
                                  color: controller.isUploadingImage.value 
                                      ? Colors.grey 
                                      : AppConstants.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppConstants.cardColor,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  controller.isUploadingImage.value 
                                      ? Icons.hourglass_empty 
                                      : Icons.camera_alt,
                                  color: Colors.white,
                                  size: AppConstants.iconSizeSmall,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        controller.profileController.user.value?.name ?? 'User Name',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textPrimaryColor,
                            ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        'ID: ${controller.profileController.user.value?.id ?? 'Unknown'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppConstants.textSecondaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppConstants.cardColor,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        label: AppConstants.fullName,
                        controller: controller.nameController,
                        validator: controller.validateName,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      CustomTextField(
                        label: AppConstants.email,
                        controller: TextEditingController(
                          text: controller.profileController.user.value?.email ?? '',
                        ),
                        enabled: false,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      CustomTextField(
                        label: AppConstants.mobileNumber,
                        controller: controller.mobileController,
                        validator: controller.validateMobile,
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      CustomDateField(
                        label: AppConstants.dateOfBirth,
                        selectedDate: controller.selectedDate.value,
                        onDateSelected: (date) => controller.selectedDate.value = date,
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      CustomGenderField(
                        label: AppConstants.gender,
                        selectedGender: controller.selectedGender.value,
                        onGenderSelected: (gender) => controller.selectedGender.value = gender ?? '',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingXLarge),
                CustomButton(
                  text: AppConstants.updateProfile,
                  onPressed: controller.isUploadingImage.value 
                      ? () {} // Empty callback when disabled
                      : () => controller.saveProfile(),
                  isLoading: controller.isLoading.value || controller.isUploadingImage.value,
                  icon: Icons.save_outlined,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
              ],
            ),
          ),
        );
      }),
    );
  }
}
