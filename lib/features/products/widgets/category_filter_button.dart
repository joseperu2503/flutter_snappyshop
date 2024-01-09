import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/products/models/filter_response.dart';
import 'package:flutter_snappyshop/features/products/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryFilterButton extends ConsumerWidget {
  const CategoryFilterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final CategoryFilter categoryFilter = searchState.categories.firstWhere(
        (category) => category.id == searchState.filter?.categoryId);

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
              return const _CategoryBottomSheet();
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
              color: categoryFilter.id != null
                  ? AppColors.secondaryMangoTango
                  : AppColors.textCoolBlack.withOpacity(0.3),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          children: [
            Text(
              categoryFilter.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: categoryFilter.id != null
                    ? AppColors.secondaryMangoTango
                    : AppColors.textCoolBlack.withOpacity(0.7),
                height: 1.1,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: categoryFilter.id != null
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

class _CategoryBottomSheet extends ConsumerStatefulWidget {
  const _CategoryBottomSheet();

  @override
  CategoryBottomSheetState createState() => CategoryBottomSheetState();
}

class CategoryBottomSheetState extends ConsumerState<_CategoryBottomSheet> {
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
                    'Categories',
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
                final category = searchState.categories[index];
                final selected = category.id == searchState.filter?.categoryId;
                return ListTile(
                  visualDensity: const VisualDensity(vertical: 0),
                  contentPadding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                  title: Text(
                    category.name,
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
                          searchState.filter
                              ?.copyWith(categoryId: () => category.id),
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
              itemCount: searchState.categories.length,
            ),
          ),
        ],
      ),
    );
  }
}
