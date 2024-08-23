import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoResults extends ConsumerWidget {
  const NoResults({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          SvgPicture.asset(
            'assets/icons/search.svg',
            colorFilter: ColorFilter.mode(
              darkMode ? AppColors.textArsenicDark : AppColors.textArsenic,
              BlendMode.srcIn,
            ),
            width: 80,
            height: 80,
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'No Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textArsenic,
              height: 1.1,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
