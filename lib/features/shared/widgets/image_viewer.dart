import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.images,
    required this.radius,
  });

  final List<String> images;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Icon(
        Icons.image_not_supported,
        color: AppColors.textYankeesBlue.withOpacity(0.5),
        size: 40,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image(
        image: NetworkImage(
          images[0],
        ),
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
      ),
    );
  }
}
