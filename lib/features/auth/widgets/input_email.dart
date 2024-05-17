import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/inputs/email.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/text_field_container.dart';

class InputEmail extends ConsumerStatefulWidget {
  const InputEmail({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Email value;
  final void Function(Email value) onChanged;

  @override
  InputEmailState createState() => InputEmailState();
}

class InputEmailState extends ConsumerState<InputEmail> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onChanged(Email.dirty(widget.value.value));
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

    final darkMode = ref.watch(darkModeProvider);

    return TextFieldContainer(
      errorMessage: widget.value.errorMessage,
      child: TextFormField(
        style: TextStyle(
          color: darkMode ? AppColors.white : AppColors.textYankeesBlue,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 22 / 14,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          isDense: true,
          hintText: 'Your email',
          hintStyle: TextStyle(
            color: darkMode
                ? AppColors.textCultured.withOpacity(0.5)
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
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        onChanged: (value) {
          widget.onChanged(
            widget.value.isPure ? Email.pure(value) : Email.dirty(value),
          );
        },
        focusNode: _focusNode,
      ),
    );
  }
}
