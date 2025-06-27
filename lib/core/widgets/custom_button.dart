import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = isOutlined
        ? OutlinedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading
                ? const SizedBox(
                    width: AppConstants.iconSizeSmall,
                    height: AppConstants.iconSizeSmall,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : (icon != null ? Icon(icon) : const SizedBox.shrink()),
            label: Text(text),
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor ?? AppConstants.primaryColor,
              minimumSize: Size(
                width ?? double.infinity,
                height ?? AppConstants.buttonHeightMedium,
              ),
              side: BorderSide(
                color: backgroundColor ?? AppConstants.primaryColor,
              ),
            ),
          )
        : ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading
                ? const SizedBox(
                    width: AppConstants.iconSizeSmall,
                    height: AppConstants.iconSizeSmall,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : (icon != null ? Icon(icon) : const SizedBox.shrink()),
            label: Text(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppConstants.primaryColor,
              foregroundColor: textColor ?? Colors.white,
              minimumSize: Size(
                width ?? double.infinity,
                height ?? AppConstants.buttonHeightMedium,
              ),
            ),
          );

    return button;
  }
}
