import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_input.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_textarea.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  AddressScreenState createState() => AddressScreenState();
}

class AddressScreenState extends ConsumerState<AddressScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData screen = MediaQuery.of(context);
    final addressState = ref.watch(addressProvider);
    final changeForm = ref.read(addressProvider.notifier).changeForm;

    return Loader(
      loading: addressState.savingAddress == LoadingStatus.loading,
      child: Layout1(
        title: 'Address',
        body: CustomScrollView(
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
                        changeForm(FormAddress.address, value);
                      },
                      readOnly: true,
                      textInputAction: TextInputAction.next,
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
                        changeForm(FormAddress.detail, value);
                      },
                      hintText: 'ex. Rio de oro building apt 201',
                      validationMessages: {
                        'required': (error) => 'We need this information.'
                      },
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(28),
                      ],
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
                        changeForm(FormAddress.name, value);
                      },
                      hintText: 'ex. James Hetfield',
                      validationMessages: {
                        'required': (error) => 'We need this information.',
                      },
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(28),
                      ],
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
                        changeForm(FormAddress.phone, value);
                      },
                      validationMessages: {
                        'required': (error) => 'We need this information.'
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(12),
                      ],
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
                        changeForm(FormAddress.references, value);
                      },
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(
            right: 24,
            left: 24,
            bottom: screen.padding.bottom,
          ),
          height: 120,
          color: AppColors.white,
          child: Center(
            child: CustomButton(
              onPressed: () {
                ref.read(addressProvider.notifier).saveAddress();
              },
              disabled: !addressState.isFormValue,
              text: 'Save Address',
            ),
          ),
        ),
      ),
    );
  }
}
