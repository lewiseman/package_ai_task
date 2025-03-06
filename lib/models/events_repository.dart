import 'package:package_ai_task/models/event.dart';

abstract class EventsRepository {
  Future<List<Event>> fetchEvents();
}