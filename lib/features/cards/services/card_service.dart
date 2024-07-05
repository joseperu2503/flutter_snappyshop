import 'package:flutter_snappyshop/config/constants/storage_keys.dart';
import 'package:flutter_snappyshop/features/cards/models/bank_card.dart';
import 'package:flutter_snappyshop/features/core/services/storage_service.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

class CardService {
  static Future<List<BankCard>> getCards() async {
    try {
      final cards = await StorageService.get<List<dynamic>>(StorageKeys.cards);
      if (cards == null) return [];

      return List<BankCard>.from(cards.map((x) => BankCard.fromJson(x)));
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while getting the credit cards.');
    }
  }

  static Future<void> saveCard(BankCard card) async {
    try {
      final List<BankCard> cardsStorage = await getCards();
      cardsStorage.add(card);
      await StorageService.set<List<dynamic>>(StorageKeys.cards, cardsStorage);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while saving the credit card information.');
    }
  }

  static Future<void> deleteCard(String? cardNumber) async {
    try {
      List<BankCard> cardsStorage = await getCards();
      cardsStorage =
          cardsStorage.where((p) => p.cardNumber != cardNumber).toList();
      await StorageService.set<List<dynamic>>(StorageKeys.cards, cardsStorage);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while deleting the credit card information.');
    }
  }
}
