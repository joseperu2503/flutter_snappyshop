import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/inputs/name.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/text_field_container.dart';

class InputName extends ConsumerStatefulWidget {
  const InputName({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Name value;
  final void Function(Name value) onChanged;

  @override
  InputNameState createState() => InputNameState();
}

class InputNameState extends ConsumerState<InputName> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

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
    final darkMode = ref.watch(darkModeProvider);

    return TextFieldContainer(
      errorMessage: widget.value.errorMessage,
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
          hintText: 'Name',
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
        controller: controller,
        onChanged: (value) {
          widget.onChanged(
            widget.value.isPure ? Name.pure(value) : Name.dirty(value),
          );
        },
        focusNode: _focusNode,
      ),
    );
  }
}
