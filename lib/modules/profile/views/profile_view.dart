import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/profile_menu_item.dart';
import '../../../core/widgets/profile_action_button.dart';
import '../controllers/profile_controller.dart';
import 'edit_profile_view.dart';
import 'my_orders_view.dart';
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(AppConstants.myProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.to(() => const EditProfileView()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.user.value == null) {
          return const Center(
            child: Text('No user data found'),
          );
        }
        final user = controller.user.value!;
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(AppConstants.paddingMedium),
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
                    CustomAvatar(
                      imageUrl: user.image,
                      size: AppConstants.avatarSizeXLarge,
                      onTap: () => Get.to(() => const EditProfileView()),
                      showEditIcon: false,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimaryColor,
                          ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      'ID: ${user.id}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppConstants.textSecondaryColor,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppConstants.secondaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                ),
                child: Row(
                  children: [
                    ProfileActionButton(
                      icon: Icons.person,
                      title: AppConstants.profile,
                      onTap: () => Get.to(() => const EditProfileView()),
                      isActive: true, // Current screen is profile
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    ProfileActionButton(
                      icon: Icons.favorite_border,
                      title: AppConstants.wishlist,
                      onTap: () => _showComingSoon(context, AppConstants.wishlist),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    ProfileActionButton(
                      icon: Icons.shopping_bag_outlined,
                      title: AppConstants.myOrders,
                      onTap: () => Get.to(() => const MyOrdersView()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: AppConstants.privacyPolicy,
                      onTap: () => _showComingSoon(context, AppConstants.privacyPolicy),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    ProfileMenuItem(
                      icon: Icons.payment_outlined,
                      title: AppConstants.paymentMethods,
                      onTap: () => _showComingSoon(context, AppConstants.paymentMethods),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    ProfileMenuItem(
                      icon: Icons.notifications_outlined,
                      title: AppConstants.notification,
                      onTap: () => _showComingSoon(context, AppConstants.notification),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    ProfileMenuItem(
                      icon: Icons.settings_outlined,
                      title: AppConstants.settings,
                      onTap: () => _showComingSoon(context, AppConstants.settings),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: AppConstants.help,
                      onTap: () => _showComingSoon(context, AppConstants.help),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      title: AppConstants.logout,
                      onTap: () => _showLogoutDialog(context, controller),
                      iconColor: AppConstants.errorColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
            ],
          ),
        );
      }),
    );
  }
  void _showComingSoon(BuildContext context, String feature) {
    Get.snackbar(
      'Coming Soon',
      '$feature feature will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  void _showLogoutDialog(BuildContext context, ProfileController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppConstants.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
