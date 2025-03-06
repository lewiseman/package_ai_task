import 'package:flutter/foundation.dart';
import 'package:package_ai_task/models/event.dart';
import 'package:package_ai_task/models/events_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  factory AppPrefs() => _instance;
  AppPrefs._();
  static final AppPrefs _instance = AppPrefs._();
  static AppPrefs get instance => _instance;
  static final String _keySuffix = '$_envName-$_docVersion';
  static const String _docVersion = 'V001';
  final asyncPrefs = SharedPreferencesAsync();

  static final String eventsKey = 'eventskey-$_keySuffix';

  static final String favouritesKey = 'favouriteskey-$_keySuffix';
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

class EventsLocalRepository extends EventsRepository {
  final _appPrefs = AppPrefs.instance.asyncPrefs;
  @override
  Future<List<Event>> fetchEvents() async {
    try {
      final rawEvents = await _appPrefs.getStringList(AppPrefs.eventsKey);
      if (rawEvents == null) {
        return Future.value([]);
      }
      final events = rawEvents.map((e) => Event.fromString(e)).toList();
      return Future.value(events);
    } catch (e) {
      return Future.value([]);
    }
  }

  Future<void> saveEvents(List<Event> events) async {
    final rawEvents = events.map((e) => e.toString()).toList();
    await _appPrefs.setStringList(AppPrefs.eventsKey, rawEvents);
  }

  Future<List<Event>> getFavourites() async {
    try {
      final rawEvents = await _appPrefs.getStringList(AppPrefs.favouritesKey);
      if (rawEvents == null) {
        return Future.value([]);
      }
      final events = rawEvents.map((e) => Event.fromString(e)).toList();
      return Future.value(events);
    } catch (e) {
      return Future.value([]);
    }
  }

  Future<void> saveFavourites(List<Event> events) async {
    final rawEvents = events.map((e) => e.toString()).toList();
    await _appPrefs.setStringList(AppPrefs.favouritesKey, rawEvents);
  }
}
