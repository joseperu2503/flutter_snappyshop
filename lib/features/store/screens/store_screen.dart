import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_item.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
import 'package:flutter_snappyshop/features/store/providers/store_provider.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({
    super.key,
    required this.storeId,
  });

  final String storeId;
  @override
  StoreScreenState createState() => StoreScreenState();
}

class StoreScreenState extends ConsumerState<StoreScreen> {
  List<Product> products = [];
  int page = 1;
  int totalPages = 1;
  LoadingStatus loadingProducts = LoadingStatus.none;
  final ScrollController scrollController = ScrollController();

  Future<void> getProducts() async {
    if (page > totalPages || loadingProducts == LoadingStatus.loading) return;

    setState(() {
      loadingProducts = LoadingStatus.loading;
    });

    try {
      final ProductsResponse response = await ProductsService.getProducts(
        page: page,
        storeId: int.parse(widget.storeId),
      );

      setState(() {
        products = [...products, ...response.results];
        totalPages = response.info.lastPage;
        page = page + 1;
        loadingProducts = LoadingStatus.success;
      });
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      setState(() {
        loadingProducts = LoadingStatus.error;
      });
    }
  }

  bool get firstLoad => loadingProducts == LoadingStatus.loading && page == 1;

  @override
  void initState() {
    super.initState();
    getProducts();
    scrollController.addListener(() {
      if (scrollController.position.pixels + 400 >=
          scrollController.position.maxScrollExtent) {
        getProducts();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref
        .watch(storeProvider)
        .stores
        .firstWhere((element) => element.id.toString() == widget.storeId);

    final MediaQueryData screen = MediaQuery.of(context);

    return Layout1(
      title: store.name,
      loading: firstLoad,
      body: CustomScrollView(
        slivers: [
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
                  final product = products[index];
                  return ProductItem(product: product);
                },
                childCount: products.length,
              ),
              gridDelegate: productSliverGridDelegate(screen.size.width),
            ),
          ),
          if (loadingProducts == LoadingStatus.loading && products.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 40,
                ),
                child: const Center(
                  child: CustomProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
