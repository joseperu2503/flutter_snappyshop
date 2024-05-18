import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/search/providers/search_provider.dart';
import 'package:flutter_snappyshop/features/search/widgets/brand_filter_button.dart';
import 'package:flutter_snappyshop/features/search/widgets/category_filter_button.dart';
import 'package:flutter_snappyshop/features/search/widgets/input_search.dart';
import 'package:flutter_snappyshop/features/search/widgets/price_filter_button.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_card.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
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
    super.initState();
    Future.microtask(() {
      ref.read(searchProvider.notifier).initState();
      ref.read(searchProvider.notifier).loadMoreProducts();
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

    final showResults = searchState.products.isNotEmpty;
    final noResults =
        !searchState.loadingProducts && searchState.products.isEmpty;
    final darkMode = ref.watch(darkModeProvider);

    return VisibilityDetector(
      key: const Key('myWidgetKey'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          _focusNode.requestFocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                scrolledUnderElevation: 0,
                backgroundColor: darkMode
                    ? AppColors.backgroundColorDark
                    : AppColors.backgroundColor,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: darkMode
                      ? AppColors.backgroundColorDark
                      : AppColors.backgroundColor,
                  child: Row(
                    children: [
                      const CustomBackButton(),
                      const Spacer(),
                      Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkMode
                              ? AppColors.textYankeesBlueDark
                              : AppColors.textYankeesBlue,
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
                backgroundColor: darkMode
                    ? AppColors.backgroundColorDark
                    : AppColors.backgroundColor,
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                titleSpacing: 0,
                toolbarHeight: 131,
                title: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 24,
                        right: 24,
                        bottom: 16,
                      ),
                      child: Hero(
                        tag: 'searchTag',
                        child: Material(
                          color: Colors.transparent,
                          child: InputSearch(
                            focusNode: _focusNode,
                            value: searchState.filter?.search ?? '',
                            onChanged: (value) {
                              ref
                                  .read(searchProvider.notifier)
                                  .changeSearch(value);
                            },
                            hintText: 'Search a product...',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 46,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: const [
                          SizedBox(
                            width: 24,
                          ),
                          CategoryFilterButton(),
                          SizedBox(
                            width: 10,
                          ),
                          BrandFilterButton(),
                          SizedBox(
                            width: 10,
                          ),
                          PriceFilterButton(),
                          SizedBox(
                            width: 24,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
                pinned: true,
              ),
              if (showResults)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 24,
                      right: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Results:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: darkMode
                                ? AppColors.white
                                : AppColors.textCoolBlack,
                            height: 1.1,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (noResults)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Icon(
                        Icons.search,
                        size: 80,
                        color: AppColors.textArsenic,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'No Results',
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
              if (showResults)
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 24,
                    right: 24,
                    bottom: 20,
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
              if (searchState.loadingProducts && searchState.products.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CustomProgressIndicator(),
                  ),
                ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 40,
                  ),
                  child: Center(
                    child: searchState.loadingProducts &&
                            searchState.products.isNotEmpty
                        ? const CustomProgressIndicator()
                        : null,
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
