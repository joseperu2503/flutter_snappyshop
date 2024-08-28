import 'package:intl/intl.dart';

class Utils {
  static String formatCurrency(double? amount, {bool withSymbol = true}) {
    NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'en',
      symbol: withSymbol ? '\$' : '',
    );

    return currencyFormat.format(amount ?? 0);
  }
}
