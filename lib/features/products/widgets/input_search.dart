import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

class InputSearch extends StatefulWidget {
  const InputSearch({super.key});

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('myWidgetKey'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          _focusNode.requestFocus();
        }
      },
      child: Container(
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  isDense: true,
                  hintText: 'Search a product...',
                  hintStyle: TextStyle(
                    color: AppColors.textArsenic,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 22 / 14,
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 0,
                    right: 20,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {},
                focusNode: _focusNode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
