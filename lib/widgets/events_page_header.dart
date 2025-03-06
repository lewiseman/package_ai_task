import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_ai_task/theme.dart';
import 'package:package_ai_task/services/events_service.dart';
import 'package:package_ai_task/utils.dart';
import 'package:package_ai_task/widgets/horizontal_week_calendar.dart';

class EventsPageHeader extends StatelessWidget {
  const EventsPageHeader({
    super.key,
    required this.selectedDate,
    required this.updateDate,
    required this.isToday,
    required this.ref,
  });
  final DateTime? selectedDate;
  final Function(DateTime? date) updateDate;
  final bool isToday;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Text(
            selectedDate == null
                ? 'Tap to filter by a specific date'
                : 'Tap on the selected date to remove filter',
          ),
        ),
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
              updateDate(null);
              ref.read(eventsServiceProvider.notifier).onDateRemoved();
            } else {
              updateDate(date);
              ref.read(eventsServiceProvider.notifier).onDateTapped(date);
            }
          },
          showTopNavbar: false,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 10, top: 16),
          child: Text.rich(
            TextSpan(
              text: isToday ? "Today's Events" : 'Upcoming & Ongoing Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: AppTheme.poppinsFont,
              ),
              children: [
                if (!isToday && selectedDate != null)
                  TextSpan(
                    text: '\nOn ${selectedDate!.humanWordsDate}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppTheme.poppinsFont,
                    ),
                  )
                else
                  TextSpan(
                    text: '\nFrom ${DateTime.now().humanWordsDate}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppTheme.poppinsFont,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
