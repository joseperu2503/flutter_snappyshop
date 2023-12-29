import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';

class InputPrice extends StatefulWidget {
  const InputPrice({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final void Function(String value) onChanged;

  @override
  State<InputPrice> createState() => _InputPriceState();
}

class _InputPriceState extends State<InputPrice> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onChanged(widget.value);
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
      text: widget.value,
      selection: TextSelection.collapsed(
        offset: controller.selection.end,
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryCultured,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          const Text(
            '\$',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textCoolBlack,
              height: 1.1,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
          Expanded(
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
                hintText: 'Your email',
                hintStyle: TextStyle(
                  color: AppColors.textArsenic,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 22 / 14,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              controller: controller,
              onChanged: (value) {
                widget.onChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
