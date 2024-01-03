import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/models/filter_response.dart';
import 'package:flutter_eshop/features/products/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BrandFilterButton extends ConsumerWidget {
  const BrandFilterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final BrandFilter brandFilter = searchState.brands
        .firstWhere((brand) => brand.id == searchState.filter?.brandId);

    return SizedBox(
      height: 45,
      child: FilledButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          showModalBottomSheet(
            backgroundColor: AppColors.white,
            elevation: 0,
            showDragHandle: false,
            context: context,
            builder: (context) {
              return const _BrandBottomSheet();
            },
          );
        },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.only(
            left: 20,
            right: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: brandFilter.id != null
                  ? AppColors.secondaryMangoTango
                  : AppColors.textCoolBlack.withOpacity(0.3),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          children: [
            Text(
              brandFilter.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: brandFilter.id != null
                    ? AppColors.secondaryMangoTango
                    : AppColors.textCoolBlack.withOpacity(0.7),
                height: 1.1,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: brandFilter.id != null
                  ? AppColors.secondaryMangoTango
                  : AppColors.textCoolBlack.withOpacity(0.7),
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandBottomSheet extends ConsumerStatefulWidget {
  const _BrandBottomSheet();

  @override
  BrandBottomSheetState createState() => BrandBottomSheetState();
}

class BrandBottomSheetState extends ConsumerState<_BrandBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 24, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: const Text(
                    'Brands',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textYankeesBlue,
                      height: 1,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                  color: AppColors.textYankeesBlue,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                bottom: 20,
                top: 5,
              ),
              itemBuilder: (context, index) {
                final brand = searchState.brands[index];
                final selected = brand.id == searchState.filter?.brandId;
                return ListTile(
                  visualDensity: const VisualDensity(vertical: 0),
                  contentPadding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                  title: Text(
                    brand.name,
                    style: TextStyle(
                      color: selected
                          ? AppColors.primaryPearlAqua
                          : AppColors.textArsenic,
                      fontSize: selected ? 17 : 16,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    ref.read(searchProvider.notifier).changeFilter(
                          searchState.filter?.copyWith(brandId: () => brand.id),
                        );
                    context.pop();
                  },
                  trailing: selected ? const Icon(Icons.check) : null,
                  selected: selected,
                  selectedColor: AppColors.primaryPearlAqua,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 0,
                );
              },
              itemCount: searchState.brands.length,
            ),
          ),
        ],
      ),
    );
  }
}
