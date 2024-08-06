import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_image.dart';
import 'package:flutter_snappyshop/features/store/models/stores_response.dart';
import 'package:go_router/go_router.dart';

class StoreItem extends ConsumerWidget {
  const StoreItem({
    super.key,
    required this.store,
  });

  final Store store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return SizedBox(
      height: 32,
      child: TextButton(
        onPressed: () {
          context.push('/store/${store.id}');
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
        ),
        child: Row(
          children: [
            if (store.isotype != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CustomImage(
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                  path: store.isotype,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            if (store.isotype == null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: darkMode
                        ? AppColors.primaryCulturedDark
                        : AppColors.primaryCultured,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      store.name.substring(0, 1),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: darkMode
                            ? AppColors.textCultured
                            : AppColors.textCoolBlack,
                        height: 22 / 16,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ),
                ),
              ),
            Text(
              store.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color:
                    darkMode ? AppColors.textCultured : AppColors.textCoolBlack,
                height: 22 / 16,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
