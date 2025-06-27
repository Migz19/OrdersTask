import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;
  final bool showEditIcon;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.size = AppConstants.avatarSizeLarge,
    this.onTap,
    this.showEditIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppConstants.dividerColor,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: _convertToDirectImageUrl(imageUrl!) ?? imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppConstants.secondaryColor.withValues(alpha: 0.3),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return _buildDefaultAvatar();
                      },
                      httpHeaders: const {
                        'User-Agent': 'Flutter App',
                      },
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
          if (showEditIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: AppConstants.iconSizeLarge,
                height: AppConstants.iconSizeLarge,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppConstants.cardColor,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: AppConstants.iconSizeSmall,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppConstants.secondaryColor,
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: AppConstants.primaryColor,
      ),
    );
  }

  String? _convertToDirectImageUrl(String? url) {
    if (url == null || url.isEmpty) return url;
    
    if (url.contains('drive.google.com/file/d/')) {
      try {
        RegExp regExp = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
        Match? match = regExp.firstMatch(url);
        if (match != null) {
          String fileId = match.group(1)!;
          return 'https://drive.google.com/uc?export=view&id=$fileId';
        }
      } catch (e) {
        return url;
      }
    }
    
    return url;
  }
}
