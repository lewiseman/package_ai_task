import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_ai_task/theme.dart';
import 'package:package_ai_task/widgets/events_page_header.dart';
import 'package:package_ai_task/models/events_state.dart';
import 'package:package_ai_task/services/events_service.dart';
import 'package:package_ai_task/widgets/landscape_event_card.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  DateTime? selectedDate;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(eventsServiceProvider.notifier).nextPage();
    }
  }

  bool get isToday {
    final today = DateTime.now();
    return today.day == selectedDate?.day &&
        today.month == selectedDate?.month &&
        today.year == selectedDate?.year;
  }

  @override
  Widget build(BuildContext context) {
    final eventsService = ref.watch(eventsServiceProvider);
    return switch (eventsService) {
      EventsLoading() =>
        eventsService.type == EventsLoadingType.full
            ? Center(child: CupertinoActivityIndicator())
            : Column(
              children: [
                EventsPageHeader(
                  selectedDate: selectedDate,
                  ref: ref,
                  updateDate: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  isToday: isToday,
                ),
                Expanded(child: Center(child: CupertinoActivityIndicator())),
              ],
            ),
      EventsError() =>
        eventsService.type == EventsErrorType.unknown
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/warning.png', width: 100),
                  SizedBox(height: 20),
                  Text('An error occurred while loading data'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedDate = null;
                      });
                      ref.invalidate(eventsServiceProvider);
                    },
                    icon: Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
            )
            : Column(
              children: [
                EventsPageHeader(
                  selectedDate: selectedDate,
                  ref: ref,
                  updateDate: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  isToday: isToday,
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Can't filter by date while not connected, try again later",
                            textAlign: TextAlign.center,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                selectedDate = null;
                              });
                              ref.invalidate(eventsServiceProvider);
                            },
                            icon: Icon(Icons.refresh_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      EventsData() => RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            setState(() {
              selectedDate = null;
            });
            ref.invalidate(eventsServiceProvider);
          });
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100),
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eventsService.source is LocalEvents)
                () {
                  final reason = (eventsService.source as LocalEvents).reason;
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 8,
                    ),
                    child: ListTile(
                      tileColor: Colors.orange[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      leading:
                          reason == LocalEventsReason.networkError
                              ? Image.asset(
                                'assets/images/network_error.png',
                                width: 30,
                              )
                              : Image.asset(
                                'assets/images/warning.png',
                                width: 30,
                              ),
                      title: Text(
                        reason == LocalEventsReason.networkError
                            ? 'Network Error'
                            : 'Error Loading Data',

                        style: TextStyle(
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.poppinsFont,
                        ),
                      ),
                      subtitle: Text(
                        reason == LocalEventsReason.networkError
                            ? 'Please check your internet connection and try again'
                            : 'Please try again later',
                        style: TextStyle(
                          color: Colors.orange[900],
                          fontSize: 13,
                          fontFamily: AppTheme.poppinsFont,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          ref.invalidate(eventsServiceProvider);
                        },
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  );
                }(),
              EventsPageHeader(
                selectedDate: selectedDate,
                ref: ref,
                updateDate: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                isToday: isToday,
              ),
              ListView.builder(
                itemCount: eventsService.events.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final event = eventsService.events[index];
                  return LandscapeEventCard(event: event);
                },
              ),
              if (eventsService.source is RemoteEvents &&
                  (eventsService.source as RemoteEvents).isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(child: CupertinoActivityIndicator()),
                ),
            ],
          ),
        ),
      ),
    };
  }
}
