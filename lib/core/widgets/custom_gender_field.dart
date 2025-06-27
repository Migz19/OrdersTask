import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomGenderField extends StatelessWidget {
  final String label;
  final String? selectedGender;
  final Function(String?) onGenderSelected;
  final String? Function(String?)? validator;

  const CustomGenderField({
    super.key,
    required this.label,
    this.selectedGender,
    required this.onGenderSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                context,
                AppConstants.male,
                Icons.male,
                selectedGender == AppConstants.male,
                () => onGenderSelected(AppConstants.male),
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: _buildGenderOption(
                context,
                AppConstants.female,
                Icons.female,
                selectedGender == AppConstants.female,
                () => onGenderSelected(AppConstants.female),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(
    BuildContext context,
    String gender,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppConstants.primaryColor.withValues(alpha: 0.1)
              : AppConstants.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: isSelected 
                ? AppConstants.primaryColor
                : AppConstants.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                    ? AppConstants.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected 
                      ? AppConstants.primaryColor
                      : AppConstants.dividerColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Text(
              gender,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected 
                        ? AppConstants.primaryColor
                        : AppConstants.textPrimaryColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
