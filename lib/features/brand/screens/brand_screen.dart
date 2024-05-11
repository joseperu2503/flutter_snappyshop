import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/products/providers/products_provider.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_card.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
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
        brandId: int.parse(widget.brandId),
      );

      setState(() {
        products = [...products, ...response.data];
        totalPages = response.meta.lastPage;
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
    final brand = ref
        .watch(productsProvider)
        .brands
        .firstWhere((element) => element.id.toString() == widget.brandId);

    return Layout1(
      title: brand.name,
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
          if (loadingProducts == LoadingStatus.loading && products.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 40,
                ),
                child: Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: kIsWeb || Platform.isAndroid
                        ? const CircularProgressIndicator(
                            color: AppColors.primaryPearlAqua,
                          )
                        : const CupertinoActivityIndicator(
                            radius: 16,
                            color: AppColors.primaryPearlAqua,
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
