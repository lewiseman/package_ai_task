import 'dart:convert';

import 'package:package_ai_task/models/event.dart';
import 'package:package_ai_task/models/events_repository.dart';
import 'package:http/http.dart' as http;
import 'package:package_ai_task/models/events_state.dart';

class EventsRemoteRepository extends EventsRepository {
  final baseUrl = 'https://app.ticketmaster.com/discovery/v2';
  final apiKey = 'msmAgH99VsgUbobINRc99qRREiCTWqdX';
  @override
  Future<List<Event>> fetchEvents({
    int page = 0,
    int size = RemoteEvents.pageSize,
  }) async {
    final now = DateTime.now();
    final today =
        "${DateTime(now.year, now.month, now.day).toUtc().toIso8601String().split('.')[0]}Z";
    final response = await http.get(
      Uri.parse(
        '$baseUrl/events.json?startEndDateTime=$today,*&apikey=$apiKey&size=$size&page=$page',
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load events');
    }
    final bodyData = jsonDecode(response.body) as Map<String, dynamic>;
    final eventsData = bodyData['_embedded']['events'] as List;
    final data = eventsData.map((e) => Event.fromJson(e)).toList();
    return data;
  }
}
