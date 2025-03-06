import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_ai_task/models/event.dart';
import 'package:package_ai_task/models/events_state.dart';
import 'package:package_ai_task/services/local_data.dart';
import 'package:package_ai_task/services/remote_data.dart';

final eventsServiceProvider =
    StateNotifierProvider<EventsNotifier, EventsState>((ref) {
      final remoteRepository = EventsRemoteRepository();
      final localRepository = EventsLocalRepository();
      return EventsNotifier(
        remoteRepository: remoteRepository,
        localRepository: localRepository,
      );
    });

class EventsNotifier extends StateNotifier<EventsState> {
  EventsNotifier({
    required this.localRepository,
    required this.remoteRepository,
  }) : super(const EventsState.loading()) {
    initialize();
  }

  final EventsRemoteRepository remoteRepository;
  final EventsLocalRepository localRepository;

  void initialize() async {
    final events = await remoteRepository.fetchEvents(
      page: RemoteEvents.pageSize,
    );
    localRepository.saveEvents(events);
    state = EventsState.data(
      events,
      source: EventsDataSource.remote(
        hasMore: events.length == RemoteEvents.pageSize,
        page: 1,
      ),
    );
  }

  void nextPage() async {
    if (state is EventsData) {
      if ((state as EventsData).source is RemoteEvents) {
        final currentState = state as EventsData;
        final remoteState = currentState.source as RemoteEvents;
        if (!remoteState.hasMore || remoteState.isLoading) return;
        state = currentState.copyWith(
          source: remoteState.copyWith(isLoading: true),
        );

        final nextEvents = await remoteRepository.fetchEvents(
          page: remoteState.page,
        );
        final events = currentState.events + nextEvents;
        localRepository.saveEvents(events);
        state = EventsState.data(
          events,
          source: RemoteEvents(
            page: remoteState.page + 1,
            hasMore: nextEvents.length == RemoteEvents.pageSize,
            isLoading: false,
          ),
        );
      }
    }
  }

  Future<List<Event>> getSearchSuggestions(String query) async {
    final events = await localRepository.fetchEvents();
    return events
        .where((event) {
          return event.name.toLowerCase().contains(query.toLowerCase());
        })
        .take(7)
        .toList();
  }

  Future<List<Event>> getLiveSearchResults(String query) async {
    final suggestions = await getSearchSuggestions(query);
    return suggestions
        .where((event) {
          return event.name.toLowerCase().contains(query.toLowerCase());
        })
        .take(7)
        .toList();
  }
}

final favouritesProvider = StateNotifierProvider((ref) {
  final localRepository = EventsLocalRepository();
  return FavouritesNotifier(localRepository: localRepository);
});

class FavouritesNotifier extends StateNotifier<List<Event>> {
  FavouritesNotifier({required this.localRepository}) : super(const <Event>[]) {
    initialize();
  }

  final EventsLocalRepository localRepository;

  void initialize() async {
    final favourites = await localRepository.getFavourites();
    state = favourites;
  }

  void toggleFavourite(Event event) async {
    final favourites = state;
    if (favourites.contains(event)) {
      favourites.remove(event);
    } else {
      favourites.add(event);
    }
    await localRepository.saveFavourites(favourites);
    state = List.from(favourites);
  }
}
