import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.paddingMedium,
            horizontal: AppConstants.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: isActive 
                ? AppConstants.primaryColor.withValues(alpha: 0.1)
                : AppConstants.cardColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            border: Border.all(
              color: isActive 
                  ? AppConstants.primaryColor
                  : AppConstants.dividerColor,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: isActive 
                      ? AppConstants.primaryColor
                      : AppConstants.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                ),
                child: Icon(
                  icon,
                  color: isActive 
                      ? Colors.white
                      : AppConstants.primaryColor,
                  size: AppConstants.iconSizeMedium,
                ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isActive 
                          ? AppConstants.primaryColor
                          : AppConstants.textPrimaryColor,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
