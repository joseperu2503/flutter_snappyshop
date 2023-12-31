import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/widgets/input_search.dart';
import 'package:flutter_eshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> results = [
      'Radio FRS Motorola Talkabout T600',
      'Aspiradora y trapeador Tesvor A1',
      'Mouse gamer alámbrico Logitech G G203',
      'iPhone 12 64GB',
      'GoPro Hero 11',
    ];

    final FocusNode _focusNode = FocusNode();

    return Layout1(
      title: 'Search',
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
              ),
              child: const Column(
                children: [
                  InputSearch(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  title: Text(result),
                  onTap: () {
                    context.push('/results');
                  },
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColors.textArsenic,
                    size: 15,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 14,
                );
              },
              itemCount: results.length,
            ),
          ),
        ],
      ),
    );
  }
}
