import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/text_field_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class InputSearch extends ConsumerWidget {
  const InputSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Hero(
      tag: 'searchTag',
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            context.push('/search');
          },
          child: TextFieldContainer(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/search.svg',
                    colorFilter: ColorFilter.mode(
                      darkMode
                          ? AppColors.textArsenicDark.withOpacity(0.5)
                          : AppColors.textArsenic.withOpacity(0.5),
                      BlendMode.srcIn,
                    ),
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: darkMode
                          ? AppColors.textArsenicDark.withOpacity(0.5)
                          : AppColors.textArsenic.withOpacity(0.5),
                      height: 1,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
