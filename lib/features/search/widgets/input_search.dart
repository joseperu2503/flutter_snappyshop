import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/text_field_container.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputSearch extends ConsumerStatefulWidget {
  const InputSearch({
    super.key,
    required this.focusNode,
    required this.value,
    required this.onChanged,
    this.hintText,
  });

  final FocusNode focusNode;
  final String value;
  final void Function(String value) onChanged;
  final String? hintText;

  @override
  InputSearchState createState() => InputSearchState();
}

class InputSearchState extends ConsumerState<InputSearch> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.value = controller.value.copyWith(
      text: widget.value,
      selection: TextSelection.collapsed(
        offset: controller.selection.end,
      ),
    );
    final darkMode = ref.watch(darkModeProvider);

    return TextFieldContainer(
      child: Container(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: ColorFilter.mode(
                darkMode
                    ? AppColors.textArsenicDark.withOpacity(0.5)
                    : AppColors.textArsenic.withOpacity(0.5),
                BlendMode.srcIn,
              ),
              width: 28,
              height: 28,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
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
                  contentPadding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    right: 20,
                    left: 0,
                  ),
                ),
                focusNode: widget.focusNode,
                controller: controller,
                onChanged: (value) {
                  widget.onChanged(value);
                },
                textInputAction: TextInputAction.search,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
