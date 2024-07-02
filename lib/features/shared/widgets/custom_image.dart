import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_svg/svg.dart';

class CustomImage extends ConsumerWidget {
  const CustomImage({
    super.key,
    required this.path,
    this.width = double.infinity,
    this.height,
  });

  final String? path;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      width: width,
      height: height,
      color:
          darkMode ? AppColors.primaryCulturedDark : AppColors.primaryCultured,
      child: Stack(
        children: [
          SizedBox(
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/shopping_bag.svg',
                width: 64,
                height: 64,
                colorFilter: ColorFilter.mode(
                  darkMode
                      ? AppColors.textArsenicDark.withOpacity(0.2)
                      : AppColors.textArsenic.withOpacity(0.2),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          if (path != null)
            FadeInImage(
              width: width,
              height: height,
              image: NetworkImage(
                path!,
              ),
              fit: BoxFit.cover,
              placeholder: const AssetImage('assets/images/transparent.png'),
            ),
        ],
      ),
    );
  }
}
