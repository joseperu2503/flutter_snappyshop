import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageViewer extends ConsumerWidget {
  const ImageViewer({
    super.key,
    required this.images,
    required this.radius,
  });

  final List<String> images;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    if (images.isEmpty) {
      return SvgPicture.asset(
        'assets/icons/no_image.svg',
        colorFilter: ColorFilter.mode(
          darkMode
              ? AppColors.textArsenicDark.withOpacity(0.5)
              : AppColors.textArsenic.withOpacity(0.5),
          BlendMode.srcIn,
        ),
        width: 40,
        height: 40,
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
