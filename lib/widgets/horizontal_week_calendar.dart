import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:intl/intl.dart';
import 'package:package_ai_task/theme.dart';

enum WeekStartFrom { sunday, monday }

class HorizontalWeekCalendar extends StatefulWidget {
  const HorizontalWeekCalendar({
    required this.minDate,
    required this.maxDate,
    required this.selectedDate,
    super.key,
    this.onDateChange,
    this.weekStartFrom = WeekStartFrom.monday,
    this.showTopNavbar = true,
  }) : super();
  final WeekStartFrom? weekStartFrom;
  final void Function(DateTime)? onDateChange;

  // ignore: avoid_field_initializers_in_const_classes
  final String monthFormat = 'MMMM yyyy';

  final DateTime minDate;

  final DateTime maxDate;

  final DateTime? selectedDate;

  final bool showTopNavbar;

  @override
  State<HorizontalWeekCalendar> createState() => _HorizontalWeekCalendarState();
}

class _HorizontalWeekCalendarState extends State<HorizontalWeekCalendar> {
  CarouselSliderController carouselController = CarouselSliderController();

  final int _initialPage = 1;

  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<DateTime> currentWeek = [];
  int currentWeekIndex = 0;

  List<List<DateTime>> listOfWeeks = [];

  @override
  void initState() {
    initCalender();
    super.initState();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void initCalender() {
    final date = widget.selectedDate ?? today;
    selectedDate = widget.selectedDate ?? today;

    final startOfCurrentWeek =
        widget.weekStartFrom == WeekStartFrom.monday
            ? getDate(date.subtract(Duration(days: date.weekday - 1)))
            : getDate(date.subtract(Duration(days: date.weekday % 7)));

    currentWeek.add(startOfCurrentWeek);
    for (var index = 0; index < 6; index++) {
      final addDate = startOfCurrentWeek.add(Duration(days: index + 1));
      currentWeek.add(addDate);
    }

    listOfWeeks.add(currentWeek);

    _getMorePreviousWeeks();

    _getMoreNextWeeks();
  }

  void _getMorePreviousWeeks() {
    final minus7Days = <DateTime>[];
    final startFrom = listOfWeeks[currentWeekIndex].first;

    var canAdd = false;
    for (var index = 0; index < 7; index++) {
      final minusDate = startFrom.add(Duration(days: -(index + 1)));
      minus7Days.add(minusDate);
      // if (widget.minDate != null) {
      if (minusDate.add(const Duration(days: 1)).isAfter(widget.minDate)) {
        canAdd = true;
      }
      // } else {
      //   canAdd = true;
      // }
    }
    if (canAdd == true) {
      listOfWeeks.add(minus7Days.reversed.toList());
    }
    setState(() {});
  }

  void _getMoreNextWeeks() {
    final plus7Days = <DateTime>[];
    // DateTime startFrom = currentWeek.last;
    final startFrom = listOfWeeks[currentWeekIndex].last;
    for (var index = 0; index < 7; index++) {
      final addDate = startFrom.add(Duration(days: index + 1));
      plus7Days.add(addDate);
    }
    listOfWeeks.insert(0, plus7Days);
    currentWeekIndex = 1;
    setState(() {});
  }

  void _onDateSelect(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    widget.onDateChange?.call(selectedDate);
  }

  void _onBackClick() {
    carouselController.nextPage();
  }

  void _onNextClick() {
    carouselController.previousPage();
  }

  void onWeekChange(int index) {
    if (currentWeekIndex < index) {
      // on back
    }
    if (currentWeekIndex > index) {
      // on next
    }

    currentWeekIndex = index;
    currentWeek = listOfWeeks[currentWeekIndex];

    if (currentWeekIndex + 1 == listOfWeeks.length) {
      _getMorePreviousWeeks();
    }

    if (index == 0) {
      _getMoreNextWeeks();
      carouselController.nextPage();
    }
  }

  // =================

  bool _isReachMinimum(DateTime dateTime) {
    return widget.minDate.add(const Duration(days: -1)).isBefore(dateTime);
  }

  bool _isReachMaximum(DateTime dateTime) {
    return widget.maxDate.add(const Duration(days: 1)).isAfter(dateTime);
  }

  bool _isNextDisabled() {
    final lastDate = listOfWeeks[currentWeekIndex].last;
    // if (widget.maxDate != null) {
    final lastDateFormatted = DateFormat('yyyy/MM/dd').format(lastDate);
    final maxDateFormatted = DateFormat('yyyy/MM/dd').format(widget.maxDate);
    if (lastDateFormatted == maxDateFormatted) return true;
    // }

    final isAfter =
    // widget.maxDate == null ? false :
    lastDate.isAfter(widget.maxDate);

    return isAfter;
    // return listOfWeeks[currentWeekIndex].last.isBefore(DateTime.now());
  }

  bool isBackDisabled() {
    final firstDate = listOfWeeks[currentWeekIndex].first;
    // if (widget.minDate != null) {
    final firstDateFormatted = DateFormat('yyyy/MM/dd').format(firstDate);
    final minDateFormatted = DateFormat('yyyy/MM/dd').format(widget.minDate);
    if (firstDateFormatted == minDateFormatted) return true;
    // }

    final isBefore =
    // widget.minDate == null ? false :
    firstDate.isBefore(widget.minDate);

    return isBefore;
    // return listOfWeeks[currentWeekIndex].last.isBefore(DateTime.now());
  }

  bool isCurrentYear() {
    return DateFormat('yyyy').format(currentWeek.first) ==
        DateFormat('yyyy').format(today);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return currentWeek.isEmpty
        ? const SizedBox()
        : Column(
          children: [
            if (widget.showTopNavbar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: isBackDisabled() ? null : _onBackClick,
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: 17,
                          color:
                              isBackDisabled()
                                  ? Colors.grey
                                  : theme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Back',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color:
                                isBackDisabled()
                                    ? Colors.grey
                                    : theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.monthFormat.isEmpty
                        ? (isCurrentYear()
                            ? DateFormat('MMMM').format(currentWeek.first)
                            : DateFormat('MMMM yyyy').format(currentWeek.first))
                        : DateFormat(
                          widget.monthFormat,
                        ).format(currentWeek.first),
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: _isNextDisabled() ? null : _onNextClick,
                    child: Row(
                      children: [
                        Text(
                          'Next',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color:
                                _isNextDisabled()
                                    ? Colors.grey
                                    : theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                          color:
                              _isNextDisabled()
                                  ? Colors.grey
                                  : theme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (widget.showTopNavbar) const SizedBox(height: 12),
            CarouselSlider(
              controller: carouselController,
              items: [
                if (listOfWeeks.isNotEmpty)
                  for (int ind = 0; ind < listOfWeeks.length; ind++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (
                              int weekIndex = 0;
                              weekIndex < listOfWeeks[ind].length;
                              weekIndex++
                            )
                              Builder(
                                builder: (_) {
                                  final currentDate =
                                      listOfWeeks[ind][weekIndex];
                                  final notdisabled =
                                      _isReachMaximum(currentDate) &&
                                      _isReachMinimum(currentDate);
                                  if (!notdisabled) {
                                    return const Expanded(
                                      child: SizedBox.shrink(),
                                    );
                                  }

                                  final boxSelected =
                                      DateFormat(
                                            'dd-MM-yyyy',
                                          ).format(currentDate) ==
                                          DateFormat(
                                            'dd-MM-yyyy',
                                          ).format(selectedDate) &&
                                      widget.selectedDate != null;

                                  final isToday =
                                      currentDate.day == today.day &&
                                      currentDate.month == today.month &&
                                      currentDate.year == today.year;

                                  final isNotActive = today
                                      .subtract(Duration(days: 1))
                                      .isAfter(currentDate);

                                  return Expanded(
                                    child: GestureDetector(
                                      onTap:
                                          isNotActive
                                              ? null
                                              : () {
                                                _onDateSelect(
                                                  listOfWeeks[ind][weekIndex],
                                                );
                                              },
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          color:
                                              boxSelected
                                                  ? AppTheme.primaryColor
                                                  : (isNotActive
                                                      ? Colors.grey[200]
                                                      : Colors.transparent),
                                          border:
                                              (boxSelected || isNotActive)
                                                  ? null
                                                  : Border.all(
                                                    width: .5,
                                                    color:
                                                        isToday
                                                            ? AppTheme
                                                                .primaryColor
                                                            : theme
                                                                .dividerColor,
                                                  ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('EEE')
                                                  .format(
                                                    listOfWeeks[ind][weekIndex],
                                                  )
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppTheme.poppinsFont,
                                                fontSize: 12,
                                                color:
                                                    boxSelected
                                                        ? Colors.white
                                                        : theme
                                                            .textTheme
                                                            .bodyMedium!
                                                            .color,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            if (boxSelected)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  left: 4,
                                                  right: 4,
                                                ),
                                                alignment: Alignment.center,
                                                width: double.maxFinite,
                                                height: 34,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  '${currentDate.day}',
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        AppTheme.poppinsFont,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            else
                                              Text(
                                                '${currentDate.day}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.poppinsFont,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color:
                                                      theme
                                                          .textTheme
                                                          .bodyMedium!
                                                          .color,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
              ],
              options: CarouselOptions(
                initialPage: _initialPage,
                scrollPhysics: const ClampingScrollPhysics(),
                height: 75,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                reverse: true,
                onPageChanged: (index, reason) {
                  onWeekChange(index);
                },
              ),
            ),
          ],
        );
  }
}
