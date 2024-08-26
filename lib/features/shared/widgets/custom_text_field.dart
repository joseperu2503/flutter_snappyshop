import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/shared/plugins/formx/formx.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_label.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends ConsumerStatefulWidget {
  const CustomTextField({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.focusNode,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofocus = false,
    this.readOnly = false,
    this.label,
    this.isPassword = false,
  });

  final FormxInput<String> value;
  final String? hintText;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(FormxInput<String> value) onChanged;
  final TextInputAction? textInputAction;
  final void Function(String value)? onFieldSubmitted;
  final bool autofocus;
  final bool readOnly;
  final String? label;
  final bool isPassword;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends ConsumerState<CustomTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    setValue();

    _effectiveFocusNode.addListener(() {
      if (!_effectiveFocusNode.hasFocus) {
        widget.onChanged(widget.value.touch());
      }
    });
  }

  @override
  void dispose() {
    _effectiveFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    //actualiza el controller cada vez que el valor se actualiza desde afuera
    setValue();
    super.didUpdateWidget(oldWidget);
  }

  setValue() {
    if (widget.value.value != _controller.value.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.value.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(darkModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.label != null)
              CustomLabel(
                widget.label!,
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radiusInput),
              ),
              height: 52,
              child: Row(
                children: [
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radiusInput),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: darkMode
                                ? AppColors.textArsenic.withOpacity(0.7)
                                : AppColors.textArsenicDark.withOpacity(0.7),
                          ),
                          borderRadius: BorderRadius.circular(radiusInput),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryPearlAqua,
                          ),
                          borderRadius: BorderRadius.circular(radiusInput),
                        ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        suffixIcon: (widget.isPassword)
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: SvgPicture.asset(
                                  showPassword
                                      ? 'assets/icons/eye.svg'
                                      : 'assets/icons/eye_closed.svg',
                                  colorFilter: ColorFilter.mode(
                                    darkMode
                                        ? AppColors.textArsenicDark
                                            .withOpacity(0.5)
                                        : AppColors.textArsenic
                                            .withOpacity(0.5),
                                    BlendMode.srcIn,
                                  ),
                                  width: 22,
                                  height: 22,
                                ),
                              )
                            : null,
                      ),
                      controller: _controller,
                      onChanged: (value) {
                        widget.onChanged(
                          widget.value.updateValue(value),
                        );
                      },
                      focusNode: _effectiveFocusNode,
                      keyboardType: widget.keyboardType,
                      inputFormatters: widget.inputFormatters,
                      textInputAction: widget.textInputAction,
                      onFieldSubmitted: widget.onFieldSubmitted,
                      autofocus: widget.autofocus,
                      readOnly: widget.readOnly,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      obscureText: widget.isPassword && !showPassword,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.value.errorMessage != null && widget.value.touched)
          Container(
            padding: const EdgeInsets.only(left: 6, top: 1),
            child: Text(
              '${widget.value.errorMessage}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: AppColors.error,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          )
      ],
    );
  }
}
