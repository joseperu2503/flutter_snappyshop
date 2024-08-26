import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_text_field.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_textarea.dart';
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
    final darkMode = ref.watch(darkModeProvider);

    return Layout(
      loading: addressState.savingAddress == LoadingStatus.loading,
      title: 'Address',
      action: addressState.selectedAddress != null
          ? Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: TextButton(
                onPressed: () {
                  ref.read(addressProvider.notifier).deleteAddress();
                },
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
                  CustomTextField(
                    label: 'Address',
                    hintText: 'Your address',
                    value: addressState.address,
                    onChanged: (value) {
                      ref.read(addressProvider.notifier).changeAddress(value);
                    },
                    textInputAction: TextInputAction.next,
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: formInputSpacing,
                  ),
                  CustomTextField(
                    label: 'Detail: apt/flat/house',
                    hintText: 'ex. Rio de oro building apt 201',
                    value: addressState.detail,
                    onChanged: (value) {
                      ref.read(addressProvider.notifier).changeDetail(value);
                    },
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(28),
                    ],
                    readOnly: addressState.selectedAddress != null,
                  ),
                  const SizedBox(
                    height: formInputSpacing,
                  ),
                  CustomTextField(
                    label: 'Name',
                    hintText: 'ex. James Hetfield',
                    value: addressState.recipientName,
                    onChanged: (value) {
                      ref
                          .read(addressProvider.notifier)
                          .changeRecipientName(value);
                    },
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(28),
                    ],
                    readOnly: addressState.selectedAddress != null,
                  ),
                  const SizedBox(
                    height: formInputSpacing,
                  ),
                  CustomTextField(
                    label: 'Phone Number',
                    value: addressState.phone,
                    onChanged: (value) {
                      ref.read(addressProvider.notifier).changePhone(value);
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(12),
                    ],
                    readOnly: addressState.selectedAddress != null,
                  ),
                  const SizedBox(
                    height: formInputSpacing,
                  ),
                  CustomTextArea(
                    label: 'References',
                    value: addressState.references,
                    onChanged: (value) {
                      ref
                          .read(addressProvider.notifier)
                          .changeReferences(value);
                    },
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    readOnly: addressState.selectedAddress != null,
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
            if (addressState.selectedAddress == null)
              CustomButton(
                onPressed: () {
                  ref.read(addressProvider.notifier).createAddress();
                },
                disabled: !addressState.isFormValid,
                text: 'Save Address',
              ),
          ],
        ),
      ),
    );
  }
}
