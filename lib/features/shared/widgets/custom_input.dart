import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/text_field_container.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomInput extends ConsumerStatefulWidget {
  const CustomInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.focusNode,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofocus = false,
    this.validationMessages,
    this.readOnly = false,
  });

  final FormControl<String> value;
  final String? hintText;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(FormControl<String> value) onChanged;
  final TextInputAction? textInputAction;
  final void Function(String value)? onFieldSubmitted;
  final bool autofocus;
  final bool readOnly;

  @override
  CustomInputState createState() => CustomInputState();
  final Map<String, ValidationMessageFunction>? validationMessages;
}

class CustomInputState extends ConsumerState<CustomInput> {
  final TextEditingController controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    }

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FormControl<String> formControl = widget.value;
        formControl.markAsTouched();
        widget.onChanged(formControl);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  String? get errorText {
    if (widget.value.hasErrors && _showErrors) {
      final errorKey = widget.value.errors.keys.first;
      final validationMessage = _findValidationMessage(errorKey);

      return validationMessage != null
          ? validationMessage(widget.value.getError(errorKey)!)
          : errorKey;
    }

    return null;
  }

  ValidationMessageFunction? _findValidationMessage(String errorKey) {
    if (widget.validationMessages != null &&
        widget.validationMessages!.containsKey(errorKey)) {
      return widget.validationMessages![errorKey];
    } else {
      final formConfig = ReactiveFormConfig.of(context);
      return formConfig?.validationMessages[errorKey];
    }
  }

  bool get _showErrors {
    return widget.value.invalid && widget.value.touched;
  }

  @override
  Widget build(BuildContext context) {
    String newValue = widget.value.value ?? '';
    if (newValue != controller.value.text) {
      if (widget.inputFormatters != null) {
        for (var inputFormatter in widget.inputFormatters!) {
          newValue = inputFormatter
              .formatEditUpdate(
                TextEditingValue(
                  text: controller.value.text,
                  selection: controller.selection.copyWith(
                    baseOffset: 0,
                  ),
                ),
                TextEditingValue(
                  text: newValue,
                  selection: controller.selection.copyWith(
                    baseOffset: 0,
                  ),
                ),
              )
              .text;
        }
      }

      controller.value = controller.value.copyWith(
        text: newValue,
      );
    }

    final darkMode = ref.watch(darkModeProvider);

    return TextFieldContainer(
      errorMessage: errorText,
      child: TextFormField(
        style: TextStyle(
          color: darkMode
              ? AppColors.textYankeesBlueDark
              : AppColors.textYankeesBlue,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 22 / 14,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          isDense: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: darkMode
                ? AppColors.textArsenicDark.withOpacity(0.5)
                : AppColors.textArsenic.withOpacity(0.5),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 22 / 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        controller: controller,
        onChanged: (value) {
          String newValue = value;

          widget.value.patchValue(newValue);
          widget.onChanged(widget.value);
        },
        keyboardType: widget.keyboardType,
        focusNode: _focusNode,
        inputFormatters: widget.inputFormatters,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
