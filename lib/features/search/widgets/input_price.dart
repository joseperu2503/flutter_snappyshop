import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

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
              keyboardType: TextInputType.number,
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
