import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/widgets/text_field_container.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomTexarea extends StatefulWidget {
  const CustomTexarea({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.focusNode,
    this.inputFormatters,
    this.keyboardType,
    this.valueProcess,
    this.onChangeProcess,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofocus = false,
    this.readOnly = false,
  });

  final FormControl<String> value;
  final String? hintText;
  final FocusNode? focusNode;
  final String Function(String value)? valueProcess;
  final String Function(String value)? onChangeProcess;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(FormControl<String> value) onChanged;
  final TextInputAction? textInputAction;
  final void Function(String value)? onFieldSubmitted;
  final bool autofocus;
  final bool readOnly;

  @override
  State<CustomTexarea> createState() => _CustomTexareaState();
}

class _CustomTexareaState extends State<CustomTexarea> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? newValue = widget.value.value;
    if (widget.valueProcess != null && newValue != null) {
      newValue = widget.valueProcess!(newValue);
    }
    controller.value = controller.value.copyWith(
      text: newValue,
    );

    return TextFieldContainer(
      height: 100,
      child: TextFormField(
        style: const TextStyle(
          color: AppColors.textYankeesBlue,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 22 / 14,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColors.textArsenic.withOpacity(0.5),
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
          if (widget.onChangeProcess != null) {
            newValue = widget.onChangeProcess!(newValue);
          }
          FormControl<String> formControl = widget.value;
          formControl.patchValue(newValue);
          formControl.markAsTouched();
          widget.onChanged(formControl);

          widget.onChanged(
            formControl,
          );
        },
        keyboardType: widget.keyboardType,
        focusNode: _focusNode,
        inputFormatters: widget.inputFormatters,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        autofocus: widget.autofocus,
        maxLines: 10,
        readOnly: widget.readOnly,
      ),
    );
  }
}
