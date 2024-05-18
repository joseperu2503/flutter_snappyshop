import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

class Otp extends StatefulWidget {
  const Otp({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final void Function(String value) onChanged;
  final String value;

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final int numberDigits = 4;

  List<FocusNode> focusNodeList = [];

  void addCharacter(String character) {
    if (character.isNotEmpty) {
      String newValue = widget.value + character;

      widget.onChanged(newValue);

      if (newValue.length < numberDigits) {
        focusNodeList[newValue.length].requestFocus();
      } else {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }
  }

  void removeCharacter(position) {
    if (widget.value.isNotEmpty) {
      final newValue = widget.value.substring(0, widget.value.length - 1);
      focusNodeList[newValue.length].requestFocus();
      widget.onChanged(newValue);
    }
  }

  @override
  void didUpdateWidget(Otp oldWidget) {
    super.didUpdateWidget(oldWidget);
    //caso que el value sea modificado programaticamente, por ejm desde algun provider
    // Verificar si la propiedad 'value' ha cambiado
    if (widget.value != oldWidget.value) {
      //verifica si el otp tiene focus en alguno de sus inputs
      final currentFocusIndex =
          focusNodeList.indexWhere((node) => node.hasFocus);

      if (currentFocusIndex != -1) {
        if (widget.value.length < numberDigits) {
          focusNodeList[widget.value.length].requestFocus();
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    focusNodeList = List.generate(numberDigits, (index) => FocusNode());
    if (widget.value.isEmpty) {
      focusNodeList[0].requestFocus();
    } else {
      focusNodeList[widget.value.length - 1].requestFocus();
    }
  }

  setFocus() {
    if (widget.value.length < numberDigits) {
      focusNodeList[widget.value.length].requestFocus();
    } else {
      focusNodeList[numberDigits - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (var focusNode in focusNodeList) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setFocus();
      },
      child: AbsorbPointer(
        absorbing: true,
        child: SizedBox(
          height: 52,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 15,
            children: focusNodeList.asMap().entries.map(
              (entry) {
                final index = entry.key;
                return _TextFiledOTP(
                  add: (value) {
                    addCharacter(value);
                  },
                  delete: () {
                    removeCharacter(index);
                  },
                  value: index < widget.value.length ? widget.value[index] : '',
                  focusNode: focusNodeList[index],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class _TextFiledOTP extends ConsumerStatefulWidget {
  const _TextFiledOTP({
    required this.add,
    required this.delete,
    required this.value,
    required this.focusNode,
  });

  final void Function(String value) add;
  final void Function() delete;
  final FocusNode focusNode;
  final String value;

  @override
  TextFiledOTPState createState() => TextFiledOTPState();
}

class TextFiledOTPState extends ConsumerState<_TextFiledOTP> {
  final TextEditingController controller = TextEditingController();
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      hasFocus = widget.focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.value = controller.value.copyWith(
      text: widget.value,
      selection: TextSelection.collapsed(
        offset: widget.value.length,
      ),
    );
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: darkMode
            ? AppColors.primaryCulturedDark
            : AppColors.primaryCultured,
        borderRadius: BorderRadius.circular(10),
        border: hasFocus
            ? Border.all(
                width: 2,
                color: AppColors.primaryPearlAqua,
              )
            : null,
      ),
      child: Center(
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (value) {
            if (value.logicalKey.keyLabel == 'Backspace' &&
                value.runtimeType.toString() == 'RawKeyDownEvent') {
              widget.delete();
            }
          },
          child: TextFormField(
            focusNode: widget.focusNode,
            onChanged: (value) {
              widget.add(value);
            },
            controller: controller,
            showCursor: true,
            readOnly: false,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: darkMode
                  ? AppColors.textCoolBlackDark
                  : AppColors.textCoolBlack,
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
          ),
        ),
      ),
    );
  }
}
