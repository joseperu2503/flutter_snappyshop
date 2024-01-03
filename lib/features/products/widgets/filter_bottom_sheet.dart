import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/models/filter.dart';
import 'package:flutter_eshop/features/products/providers/search_provider.dart';
import 'package:flutter_eshop/features/products/widgets/input_price.dart';
import 'package:flutter_eshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_eshop/features/shared/widgets/custom_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.filter,
  });

  final Filter? filter;

  @override
  FilterBottomSheetState createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  @override
  void initState() {
    setState(() {
      if (widget.filter != null) {
        filter = widget.filter!;
      }
    });
    super.initState();
  }

  Filter filter = Filter(
    categoryId: null,
    brandId: null,
    minPrice: '',
    maxPrice: '',
    search: '',
  );

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Filter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textYankeesBlue,
                height: 32 / 24,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const SizedBox(
              height: 0,
            ),
            Divider(
              color: AppColors.textArsenic.withOpacity(0.2),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textCoolBlack,
                height: 1.1,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 45,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = searchState.categories[index];
                  final selected = category.id == filter.categoryId;

                  return FilledButton(
                    onPressed: () {
                      setState(() {
                        filter = filter.copyWith(
                          categoryId: () => category.id,
                        );
                      });
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: selected
                              ? AppColors.secondaryPastelRed
                              : AppColors.textCoolBlack.withOpacity(0.3),
                        ),
                      ),
                      backgroundColor: selected
                          ? AppColors.secondaryPastelRed
                          : Colors.transparent,
                    ),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? AppColors.white
                            : AppColors.textCoolBlack.withOpacity(0.7),
                        height: 1.1,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
                itemCount: searchState.categories.length,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Min price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textCoolBlack,
                          height: 1.1,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputPrice(
                        value: filter.minPrice,
                        onChanged: (value) {
                          setState(() {
                            filter = filter.copyWith(
                              minPrice: value,
                            );
                          });
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Max price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textCoolBlack,
                          height: 1.1,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputPrice(
                        value: filter.maxPrice,
                        onChanged: (value) {
                          setState(() {
                            filter = filter.copyWith(
                              maxPrice: value,
                            );
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Divider(
              color: AppColors.textArsenic.withOpacity(0.2),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: CustomTextButton(
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textYankeesBlue,
                        height: 22 / 16,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        filter = filter.copyWith(
                          categoryId: null,
                          brandId: null,
                          minPrice: '',
                          maxPrice: '',
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomButton(
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textCultured,
                        height: 22 / 16,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    onPressed: () {
                      ref.read(searchProvider.notifier).changeFilter(filter);
                      context.pop();
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
