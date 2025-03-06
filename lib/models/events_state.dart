import 'package:package_ai_task/models/event.dart';

sealed class EventsState {
  const factory EventsState.loading() = EventsLoading;
  // const factory EventsState.loading() = Loading;
  const factory EventsState.data(
    List<Event> events, {
    required EventsDataSource source,
  }) = EventsData;
  const factory EventsState.error(String message) = EventsError;
}

class EventsLoading implements EventsState {
  const EventsLoading();
}

class EventsData implements EventsState {
  const EventsData(this.events, {required this.source});

  final List<Event> events;
  final EventsDataSource source;

  EventsData copyWith({List<Event>? events, EventsDataSource? source}) {
    return EventsData(events ?? this.events, source: source ?? this.source);
  }
}

class EventsError implements EventsState {
  const EventsError(this.message);

  final String message;
}

sealed class EventsDataSource {
  const factory EventsDataSource.remote({
    int page,
    required bool hasMore,
    bool isLoading,
  }) = RemoteEvents;
  const factory EventsDataSource.local(LocalEventsReason rason) = LocalEvents;
}

class RemoteEvents implements EventsDataSource {
  const RemoteEvents({
    this.page = 0,
    required this.hasMore,
    this.isLoading = false,
  });

  static const pageSize = 15;

  final int page;
  final bool hasMore;
  final bool isLoading;

  RemoteEvents copyWith({int? page, bool? hasMore, bool? isLoading}) {
    return RemoteEvents(
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LocalEvents implements EventsDataSource {
  const LocalEvents(this.reason);

  final LocalEventsReason reason;
}

enum LocalEventsReason { networkError, genericError }
