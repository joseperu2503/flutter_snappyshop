import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

class InputSearch extends StatefulWidget {
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
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.value = controller.value.copyWith(
      text: widget.value,
      selection: TextSelection.collapsed(
        offset: controller.selection.end,
      ),
    );

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryCultured,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: AppColors.textArsenic,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              style: const TextStyle(
                color: AppColors.textYankeesBlue,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 22 / 14,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                isDense: true,
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.textArsenic,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 22 / 14,
                ),
                contentPadding: const EdgeInsets.only(
                  left: 0,
                  right: 20,
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
    );
  }
}
