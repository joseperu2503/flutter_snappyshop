import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/providers/products_provider.dart';
import 'package:flutter_eshop/features/products/widgets/filter_bottom_sheet.dart';
import 'package:flutter_eshop/features/products/widgets/input_search.dart';
import 'package:flutter_eshop/features/products/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return VisibilityDetector(
      key: const Key('myWidgetKey'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          _focusNode.requestFocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                scrolledUnderElevation: 0,
                backgroundColor: AppColors.white,
                automaticallyImplyLeading: false,
                title: Container(
                  color: AppColors.white,
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryCultured,
                        ),
                        child: TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/arrow-back.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textYankeesBlue,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 46,
                        height: 46,
                      )
                    ],
                  ),
                ),
                floating: true,
              ),
              SliverAppBar(
                backgroundColor: AppColors.white,
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                titleSpacing: 0,
                toolbarHeight: 90,
                title: Container(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 24,
                    right: 24,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputSearch(
                          focusNode: _focusNode,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primaryPearlAqua,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            foregroundColor: Colors.white60,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return FilterBottomSheet(
                                  filter: productsState.filter,
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.tune,
                            color: AppColors.textCultured,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 24,
                    right: 24,
                  ),
                  // ignore: prefer_const_constructors
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text(
                        'Results:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textCoolBlack,
                          height: 1.1,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 24,
                  right: 24,
                  bottom: 56,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final product = productsState.products[index];
                      return ProductCard(product: product);
                    },
                    childCount: productsState.products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 210,
                  ),
                ),
              ),
              if (productsState.loadingProducts)
                const SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
