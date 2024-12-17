import 'package:intl/intl.dart';
//The intl package is used for internationalization and localization.
void main() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  print('Formatted date: $formattedDate');
}