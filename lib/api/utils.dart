import 'package:intl/intl.dart';

DateTime parseDate(String dateString) {
  var formatter = DateFormat('yyyy-MM-dd');
  return formatter.parse(dateString);
}

Future<String> getDate() async {
  DateTime now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  return formattedDate;
}