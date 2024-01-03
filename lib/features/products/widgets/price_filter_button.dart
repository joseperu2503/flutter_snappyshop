import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/models/filter.dart';
import 'package:flutter_eshop/features/products/providers/search_provider.dart';
import 'package:flutter_eshop/features/products/widgets/input_price.dart';
import 'package:flutter_eshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_eshop/features/shared/widgets/custom_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PriceFilterButton extends ConsumerWidget {
  const PriceFilterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final hasFilter = (searchState.filter?.minPrice != '' ||
        searchState.filter?.maxPrice != '');

    final label = hasFilter
        ? ((searchState.filter?.minPrice != ''
                ? 'min: \$${searchState.filter?.minPrice}'
                : '') +
            (searchState.filter?.minPrice != '' &&
                    searchState.filter?.maxPrice != ''
                ? ' - '
                : '') +
            (searchState.filter?.maxPrice != ''
                ? 'max: \$${searchState.filter?.maxPrice}'
                : ''))
        : 'Price';

    return FilledButton(
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showModalBottomSheet(
          backgroundColor: AppColors.white,
          elevation: 0,
          showDragHandle: false,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return _PriceBottomSheet(
              filter: searchState.filter,
            );
          },
        );
      },
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: hasFilter
                ? AppColors.secondaryMangoTango
                : AppColors.textCoolBlack.withOpacity(0.7),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: hasFilter
              ? AppColors.secondaryMangoTango
              : AppColors.textCoolBlack.withOpacity(0.7),
          height: 1.1,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      ),
    );
  }
}

class _PriceBottomSheet extends ConsumerStatefulWidget {
  const _PriceBottomSheet({required this.filter});

  final Filter? filter;

  @override
  PriceBottomSheetState createState() => PriceBottomSheetState();
}

class PriceBottomSheetState extends ConsumerState<_PriceBottomSheet> {
  @override
  void initState() {
    super.initState();
    if (widget.filter != null) {
      minPrice = widget.filter!.minPrice;
      maxPrice = widget.filter!.maxPrice;
    }
  }

  String minPrice = '';
  String maxPrice = '';

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 10,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 24, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
              child: Container(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                child: Column(
                  children: [
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
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              InputPrice(
                                value: minPrice,
                                onChanged: (value) {
                                  setState(() {
                                    minPrice = value;
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
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              InputPrice(
                                value: maxPrice,
                                onChanged: (value) {
                                  setState(() {
                                    maxPrice = value;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
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
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                minPrice = '';
                                maxPrice = '';
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
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            onPressed: () {
                              ref.read(searchProvider.notifier).changeFilter(
                                    searchState.filter?.copyWith(
                                      maxPrice:
                                          formatStringWithTwoDecimals(maxPrice),
                                      minPrice:
                                          formatStringWithTwoDecimals(minPrice),
                                    ),
                                  );
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
            ),
          ],
        ),
      ),
    );
  }
}
