import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/cards/providers/card_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:go_router/go_router.dart';

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  CardsScreenState createState() => CardsScreenState();
}

class CardsScreenState extends ConsumerState<CardsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(cardProvider.notifier).getCards();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData screen = MediaQuery.of(context);
    final cardState = ref.watch(cardProvider);

    return Loader(
      loading: false,
      child: Layout1(
        title: cardState.listType == ListType.list ? 'My Cards' : 'Select Card',
        floatingActionButton: SizedBox(
          width: 60,
          height: 60,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryPearlAqua,
            ),
            icon: const Icon(
              Icons.add,
              color: AppColors.white,
            ),
            onPressed: () {
              ref.read(cardProvider.notifier).resetForm();
              context.push('/card');
            },
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList.separated(
                itemBuilder: (context, index) {
                  final card = cardState.cards[index];
                  return GestureDetector(
                    onTap: () {
                      ref.read(cardProvider.notifier).selectCard(card);
                    },
                    child: CreditCardWidget(
                      height: screen.size.width * 0.5,
                      padding: 0,
                      cardNumber: card.cardNumber,
                      expiryDate: card.expired,
                      cardHolderName: card.cardHolderName,
                      cvvCode: '',
                      showBackView: false,
                      isHolderNameVisible: true,
                      isSwipeGestureEnabled: false,
                      onCreditCardWidgetChange: (CreditCardBrand brand) {},
                      cardBgColor: AppColors.textCoolBlack,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: cardState.cards.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
