import 'package:intl/intl.dart';

extension FormatDate on DateTime {
  String get humanSlashDate {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String get humanWordsDate {
    return DateFormat.yMMMMd().format(this);
  }

  String get humanTime {
    return DateFormat('hh:mm a').format(this);
  }
}
