import 'package:package_ai_task/models/event.dart';

sealed class EventsState {
  const factory EventsState.loading(EventsLoadingType type) = EventsLoading;
  // const factory EventsState.loading() = Loading;
  const factory EventsState.data(
    List<Event> events, {
    required EventsDataSource source,
  }) = EventsData;
  const factory EventsState.error(EventsErrorType type) = EventsError;
}

class EventsLoading implements EventsState {
  const EventsLoading(this.type);

  final EventsLoadingType type;
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
  const EventsError(this.type);

  final EventsErrorType type;
}

sealed class EventsDataSource {
  const factory EventsDataSource.remote({
    int page,
    required bool hasMore,
    bool isLoading,
    DateTime? date,
  }) = RemoteEvents;
  const factory EventsDataSource.local(LocalEventsReason rason) = LocalEvents;
}

class RemoteEvents implements EventsDataSource {
  const RemoteEvents({
    this.page = 0,
    required this.hasMore,
    this.isLoading = false,
    this.date,
  });

  static const pageSize = 15;

  final int page;
  final bool hasMore;
  final bool isLoading;
  final DateTime? date;

  RemoteEvents copyWith({
    int? page,
    bool? hasMore,
    bool? isLoading,
    DateTime? date,
  }) {
    return RemoteEvents(
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      date: date ?? this.date,
    );
  }
}

class LocalEvents implements EventsDataSource {
  const LocalEvents(this.reason);

  final LocalEventsReason reason;
}

enum LocalEventsReason { networkError, genericError }

enum EventsLoadingType { full, date }

enum EventsErrorType { unknown, fromDate }
