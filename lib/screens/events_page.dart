import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_ai_task/config/theme.dart';
import 'package:package_ai_task/utils.dart';
import 'package:package_ai_task/widgets/horizontal_week_calendar.dart';
import 'package:package_ai_task/models/events_state.dart';
import 'package:package_ai_task/screens/event_page/event_page.dart';
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
      EventsLoading() => Center(child: CupertinoActivityIndicator()),
      EventsError() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/warning.png', width: 100),
            SizedBox(height: 20),
            Text(eventsService.message),
            IconButton(
              onPressed: () {
                ref.invalidate(eventsServiceProvider);
              },
              icon: Icon(Icons.refresh_rounded),
            ),
          ],
        ),
      ),
      EventsData() => SingleChildScrollView(
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

            SizedBox(height: 16),
            HorizontalWeekCalendar(
              weekStartFrom: WeekStartFrom.sunday,
              key: ValueKey(selectedDate),
              minDate: DateTime(2025),
              maxDate: DateTime(2028),
              selectedDate: selectedDate,
              onDateChange: (date) {
                final isSame =
                    selectedDate?.day == date.day &&
                    selectedDate?.month == date.month &&
                    selectedDate?.year == date.year;
                if (isSame) {
                  setState(() {
                    selectedDate = null;
                  });
                } else {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              showTopNavbar: false,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 10, top: 16),
              child: Text.rich(
                TextSpan(
                  text: isToday ? "Today's Events" : 'Upcoming Events',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  children: [
                    if (!isToday && selectedDate != null)
                      TextSpan(
                        text: '\nFor ${selectedDate!.humanWordsDate}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
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
    };
  }
}
