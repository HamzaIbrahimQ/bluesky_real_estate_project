import 'package:intl/intl.dart';



String formatCurrency(int amount, {int decimalCount = 0}){
  final formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: decimalCount,);
  return formatCurrency.format(amount);
  // amount type is int

}