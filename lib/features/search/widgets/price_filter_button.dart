import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/search/models/filter.dart';
import 'package:flutter_snappyshop/features/search/providers/search_provider.dart';
import 'package:flutter_snappyshop/features/search/widgets/input_price.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_label.dart';
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

    final darkMode = ref.watch(darkModeProvider);

    final color = hasFilter
        ? AppColors.secondaryMangoTango
        : darkMode
            ? AppColors.textCultured.withOpacity(0.5)
            : AppColors.textCoolBlack.withOpacity(0.3);
    return SizedBox(
      height: 45,
      child: FilledButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          showModalBottomSheet(
            backgroundColor: darkMode
                ? AppColors.backgroundColorDark
                : AppColors.backgroundColor,
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
              color: color,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
            height: 1.1,
            leadingDistribution: TextLeadingDistribution.even,
          ),
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
    final darkMode = ref.watch(darkModeProvider);

    return SafeArea(
      child: Padding(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Filter by price',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: darkMode
                              ? AppColors.textYankeesBlueDark
                              : AppColors.textYankeesBlue,
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
                      color: darkMode
                          ? AppColors.textYankeesBlueDark
                          : AppColors.textYankeesBlue,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
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
                                const CustomLabel('Min price'),
                                const SizedBox(
                                  height: 4,
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
                                const CustomLabel('Max price'),
                                const SizedBox(
                                  height: 4,
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
                          CustomButton(
                            width: 100,
                            text: 'Reset',
                            onPressed: () {
                              setState(() {
                                minPrice = '';
                                maxPrice = '';
                              });
                            },
                            type: ButtonType.text,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomButton(
                              text: 'Apply',
                              onPressed: () {
                                ref.read(searchProvider.notifier).changeFilter(
                                      searchState.filter?.copyWith(
                                        maxPrice: formatStringWithTwoDecimals(
                                            maxPrice),
                                        minPrice: formatStringWithTwoDecimals(
                                            minPrice),
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
      ),
    );
  }
}
