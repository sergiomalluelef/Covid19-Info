import 'package:intl/intl.dart';

class Utils{
  static String setFormatNumberToString(int number){
    final formatter = new NumberFormat("#,###");
    return formatter.format(number).toString().replaceAll(',', '.');
  }
}