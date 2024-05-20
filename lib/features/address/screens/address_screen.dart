import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_input.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_label.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_textarea.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:flutter_svg/svg.dart';

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
    final darkMode = ref.watch(darkModeProvider);

    return Loader(
      loading: addressState.savingAddress == LoadingStatus.loading,
      child: Layout1(
        title: 'Address',
        action: addressState.formType == FormType.edit
            ? Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: SvgPicture.asset(
                    'assets/icons/delete.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondaryPastelRed,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                ),
              )
            : null,
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
                    const CustomLabel('Address'),
                    const SizedBox(
                      height: labelInputSpacing,
                    ),
                    CustomInput(
                      value: addressState.address,
                      onChanged: (value) {
                        changeForm(AddressForm.address, value);
                      },
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    const CustomLabel('Detail: apt/flat/house'),
                    const SizedBox(
                      height: labelInputSpacing,
                    ),
                    CustomInput(
                      value: addressState.detail,
                      onChanged: (value) {
                        changeForm(AddressForm.detail, value);
                      },
                      hintText: 'ex. Rio de oro building apt 201',
                      validationMessages: {
                        'required': (error) => 'We need this information.'
                      },
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(28),
                      ],
                      readOnly: addressState.formType == FormType.edit,
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    const CustomLabel('Name'),
                    const SizedBox(
                      height: labelInputSpacing,
                    ),
                    CustomInput(
                      value: addressState.recipientName,
                      onChanged: (value) {
                        changeForm(AddressForm.recipientName, value);
                      },
                      hintText: 'ex. James Hetfield',
                      validationMessages: {
                        'required': (error) => 'We need this information.',
                      },
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(28),
                      ],
                      readOnly: addressState.formType == FormType.edit,
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    const CustomLabel('Phone Number'),
                    const SizedBox(
                      height: labelInputSpacing,
                    ),
                    CustomInput(
                      value: addressState.phone,
                      onChanged: (value) {
                        changeForm(AddressForm.phone, value);
                      },
                      validationMessages: {
                        'required': (error) => 'We need this information.'
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(12),
                      ],
                      readOnly: addressState.formType == FormType.edit,
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    const CustomLabel('References'),
                    const SizedBox(
                      height: labelInputSpacing,
                    ),
                    CustomTexarea(
                      value: addressState.references,
                      onChanged: (value) {
                        changeForm(AddressForm.references, value);
                      },
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                      readOnly: addressState.formType == FormType.edit,
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
          color: darkMode
              ? AppColors.backgroundColorDark
              : AppColors.backgroundColor,
          child: Column(
            children: [
              if (addressState.formType == FormType.edit)
                CustomButton(
                  onPressed: () {
                    ref.read(addressProvider.notifier).markAsPrimary();
                  },
                  text: 'Save as primary address',
                  type: ButtonType.text,
                ),
              if (addressState.formType == FormType.create)
                CustomButton(
                  onPressed: () {
                    ref.read(addressProvider.notifier).saveAddress();
                  },
                  disabled: !addressState.isFormValue,
                  text: 'Save Address',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
