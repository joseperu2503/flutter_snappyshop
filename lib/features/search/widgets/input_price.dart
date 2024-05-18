import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/text_field_container.dart';

class InputPrice extends ConsumerStatefulWidget {
  const InputPrice({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final void Function(String value) onChanged;

  @override
  InputPriceState createState() => InputPriceState();
}

class InputPriceState extends ConsumerState<InputPrice> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onChanged(formatStringWithTwoDecimals(widget.value));
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

    final darkMode = ref.watch(darkModeProvider);

    return TextFieldContainer(
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Text(
            '\$',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: darkMode ? AppColors.white : AppColors.textCoolBlack,
              height: 1.1,
              leadingDistribution: TextLeadingDistribution.even,
            ),
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
                hintStyle: TextStyle(
                  color: darkMode
                      ? AppColors.textArsenicDark.withOpacity(0.5)
                      : AppColors.textArsenic.withOpacity(0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 22 / 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                MontoFormatter(),
              ],
              controller: controller,
              onChanged: (value) {
                widget.onChanged(value);
              },
              focusNode: _focusNode,
            ),
          ),
        ],
      ),
    );
  }
}

class MontoFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      final text = newValue.text;
      if (text.isEmpty) return newValue;
      double.parse(text); // Valida que sea un número
      if (text.contains('.') && text.split('.')[1].length > 2) {
        return oldValue; // Más de 2 decimales
      }
      return newValue;
    } catch (e) {
      return oldValue; // No se puede analizar como un número
    }
  }
}

String formatStringWithTwoDecimals(String input) {
  if (input.isEmpty) return input;
  // Convierte la cadena de entrada a un número
  double number = double.tryParse(input) ?? 0.0;

  // Formatea el número con exactamente dos decimales
  String formattedString = number.toStringAsFixed(2);

  return formattedString;
}
