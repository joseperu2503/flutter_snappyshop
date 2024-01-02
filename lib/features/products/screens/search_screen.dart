import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/providers/search_provider.dart';
import 'package:flutter_eshop/features/products/widgets/filter_bottom_sheet.dart';
import 'package:flutter_eshop/features/products/widgets/input_search.dart';
import 'package:flutter_eshop/features/products/widgets/product_card.dart';
import 'package:flutter_eshop/features/shared/widgets/back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
    Future.microtask(() {
      ref.read(searchProvider.notifier).initState();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels + 400 >=
          scrollController.position.maxScrollExtent) {
        ref.read(searchProvider.notifier).loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final hasFilter = searchState.filter?.brand != null ||
        searchState.filter?.category != null ||
        (searchState.filter?.maxPrice != null &&
            searchState.filter?.maxPrice != '') ||
        (searchState.filter?.minPrice != null &&
            searchState.filter?.minPrice != '') ||
        (searchState.filter?.search != null &&
            searchState.filter?.search != '');
    final showResults = !searchState.loadingProducts &&
        hasFilter &&
        searchState.products.isNotEmpty;
    final noResults = !searchState.loadingProducts &&
        hasFilter &&
        searchState.products.isEmpty;

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
            controller: scrollController,
            slivers: [
              SliverAppBar(
                scrolledUnderElevation: 0,
                backgroundColor: AppColors.white,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: AppColors.white,
                  child: const Row(
                    children: [
                      CustomBackButton(),
                      Spacer(),
                      Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textYankeesBlue,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
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
                          value: searchState.filter?.search ?? '',
                          onChanged: (value) {
                            ref
                                .read(searchProvider.notifier)
                                .changeSearch(value);
                          },
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
                                  filter: searchState.filter,
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
              if (showResults)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 24,
                      right: 24,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
              if (noResults)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      const Icon(
                        Icons.search,
                        size: 80,
                        color: AppColors.textArsenic,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'No Results for "${searchState.filter?.search}"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textCoolBlack,
                          height: 1.1,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Check the spelling or try a new search',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textCoolBlack.withOpacity(0.6),
                          height: 1.1,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    ],
                  ),
                ),
              if (showResults)
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
                        final product = searchState.products[index];
                        return ProductCard(product: product);
                      },
                      childCount: searchState.products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 210,
                    ),
                  ),
                ),
              if (searchState.loadingProducts)
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
