import 'package:intl/intl.dart';
import '../constants/currency_config.dart';
import '../controllers/currency_controller.dart';

class CurrencyFormatter {
  static String format(num amount, {int decimalDigits = 2}) {
    final config = CurrencyController.to.currency.value;
    
    // We use an empty symbol in NumberFormat so we can control position ourselves.
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalDigits,
    );
    
    final formattedNumber = formatter.format(amount).trim();
    
    if (config.position == CurrencyPosition.left) {
      return '${config.symbol}$formattedNumber';
    } else {
      return '$formattedNumber${config.symbol}';
    }
  }
}
