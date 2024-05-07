import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/address/constants/constants.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_input.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_textarea.dart';

class BottomModal extends ConsumerWidget {
  const BottomModal({
    super.key,
    required this.screen,
  });
  final MediaQueryData screen;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressProvider);

    final double minHeight = (minHeightBottomSheet) /
        (screen.size.height -
            toolbarHeight -
            screen.padding.top -
            heightBottomSheet);
    final double maxHeight = (maxHeightBottomSheet) /
        (screen.size.height -
            toolbarHeight -
            screen.padding.top -
            heightBottomSheet);

    return DraggableScrollableSheet(
      initialChildSize: minHeight,
      minChildSize: minHeight,
      maxChildSize: maxHeight,
      snap: true,
      snapSizes: [minHeight, maxHeight],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radiusBottomSheet),
              topRight: Radius.circular(radiusBottomSheet),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(63, 76, 95, 0.12),
                offset: Offset(0, -4),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 40,
                    right: 24,
                    left: 24,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textYankeesBlue,
                          height: 22 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        height: labelInputSpacing,
                      ),
                      CustomInput(
                        value: addressState.address,
                        onChanged: (value) {
                          ref
                              .read(addressProvider.notifier)
                              .changeAddress(value);
                        },
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: formInputSpacing,
                      ),
                      const Text(
                        'Detail: apt/flat/house',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textYankeesBlue,
                          height: 22 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        height: labelInputSpacing,
                      ),
                      CustomInput(
                        value: addressState.detail,
                        onChanged: (value) {
                          ref
                              .read(addressProvider.notifier)
                              .changeDetail(value);
                        },
                        hintText: 'ex. Rio de oro building apt 201',
                        validationMessages: {
                          'required': (error) => 'We need this information.'
                        },
                      ),
                      const SizedBox(
                        height: formInputSpacing,
                      ),
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textYankeesBlue,
                          height: 22 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        height: labelInputSpacing,
                      ),
                      CustomInput(
                        value: addressState.name,
                        onChanged: (value) {
                          ref.read(addressProvider.notifier).changeName(value);
                        },
                        hintText: 'ex. James Hetfield',
                        validationMessages: {
                          'required': (error) => 'We need this information.'
                        },
                      ),
                      const SizedBox(
                        height: formInputSpacing,
                      ),
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textYankeesBlue,
                          height: 22 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        height: labelInputSpacing,
                      ),
                      CustomInput(
                        value: addressState.phone,
                        onChanged: (value) {
                          ref.read(addressProvider.notifier).changePhone(value);
                        },
                        validationMessages: {
                          'required': (error) => 'We need this information.'
                        },
                      ),
                      const SizedBox(
                        height: formInputSpacing,
                      ),
                      const Text(
                        'References',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textYankeesBlue,
                          height: 22 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const SizedBox(
                        height: labelInputSpacing,
                      ),
                      CustomTexarea(
                        value: addressState.references,
                        onChanged: (value) {
                          ref
                              .read(addressProvider.notifier)
                              .changeReferences(value);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
