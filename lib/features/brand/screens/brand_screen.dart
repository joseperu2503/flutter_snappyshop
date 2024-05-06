import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/products/providers/products_provider.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_card.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrandScreen extends ConsumerStatefulWidget {
  const BrandScreen({
    super.key,
    required this.brandId,
  });

  final String brandId;
  @override
  BrandScreenState createState() => BrandScreenState();
}

class BrandScreenState extends ConsumerState<BrandScreen> {
  List<Product> products = [];
  int page = 1;
  int totalPages = 1;
  bool loadingProducts = false;
  final ScrollController scrollController = ScrollController();

  Future<void> getProducts() async {
    if (page > totalPages || loadingProducts) return;

    setState(() {
      loadingProducts = true;
    });

    try {
      final ProductsResponse response = await ProductsService.getProducts(
        page: page,
        brandId: int.parse(widget.brandId),
      );

      setState(() {
        products = [...products, ...response.data];
        totalPages = response.meta.lastPage;
        page = page + 1;
      });
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    setState(() {
      loadingProducts = false;
    });
  }

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
    final brand = ref
        .watch(productsProvider)
        .brands
        .firstWhere((element) => element.id.toString() == widget.brandId);

    return Layout1(
      title: brand.name,
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
                  return ProductCard(product: product);
                },
                childCount: products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                mainAxisExtent: 210,
              ),
            ),
          ),
          if (loadingProducts)
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
    );
  }
}
