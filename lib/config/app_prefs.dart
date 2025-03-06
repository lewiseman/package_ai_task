import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  factory AppPrefs() => _instance;
  AppPrefs._();
  static final AppPrefs _instance = AppPrefs._();
  static AppPrefs get instance => _instance;
  static final String _keySuffix = '$_envName-$_docVersion';
  static const String _docVersion = 'V001';
  final _asyncPrefs = SharedPreferencesAsync();

  static final String _clientsKey = 'clientskey-$_keySuffix';

  getPartnerClientsData() async {
    final data = await _asyncPrefs.getString(_clientsKey);
  }

  Future<void> updatePartnerClientsData(clients) async {
    await _asyncPrefs.setString(_clientsKey, clients.toString());
  }
}

final String _envName = () {
  if (kReleaseMode) {
    return 'Prod';
  } else if (kProfileMode) {
    return 'Test';
  } else {
    return 'Dev';
  }
}();
