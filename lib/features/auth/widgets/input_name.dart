import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/shared/inputs/name.dart';
import 'package:flutter_eshop/features/shared/widgets/text_field_container.dart';

class InputName extends StatefulWidget {
  const InputName({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Name value;
  final void Function(Name value) onChanged;

  @override
  State<InputName> createState() => _InputNameState();
}

class _InputNameState extends State<InputName> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool showText = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      showText = false;
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onChanged(Name.dirty(widget.value.value));
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
    controller.value = controller.value.copyWith(
      text: widget.value.value,
      selection: TextSelection.collapsed(
        offset: controller.selection.end,
      ),
    );
    return TextFieldContainer(
      errorMessage: widget.value.errorMessage,
      child: TextFormField(
        style: const TextStyle(
          color: AppColors.textYankeesBlue,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 22 / 14,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          isDense: true,
          hintText: 'Password',
          hintStyle: TextStyle(
            color: AppColors.textArsenic,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 22 / 14,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        controller: controller,
        onChanged: (value) {
          widget.onChanged(Name.dirty(value));
        },
      ),
    );
  }
}