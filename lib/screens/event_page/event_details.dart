import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_ai_task/config/theme.dart';
import 'package:package_ai_task/models/event.dart';
import 'package:package_ai_task/utils.dart';
import 'package:package_ai_task/widgets/expandable_text.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsSection extends StatelessWidget {
  const EventDetailsSection({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    final dateTime = event.getTime();
    final classifications = event.topClassifications().take(6);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (classifications.isNotEmpty) ...[
            Wrap(
              spacing: 16,
              children: [
                for (final classification in classifications)
                  Chip(
                    label: Text(classification),
                    backgroundColor: Colors.grey[200],
                  ),
              ],
            ),
            SizedBox(height: 26),
          ],
          if (dateTime != null)
            Card(
              margin: EdgeInsets.zero,
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(CupertinoIcons.calendar, size: 26),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date'),
                            Text(dateTime.humanWordsDate),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(CupertinoIcons.time, size: 26),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Time'), Text(dateTime.humanTime)],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 24),
          if (event.info.isNotEmpty) ...[
            Text(
              'About Event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ExpandableText(text: event.info),
            SizedBox(height: 26),
          ],

          if (event.pleaseNote.isNotEmpty &&
              event.info != event.pleaseNote) ...[
            Text(
              'Please Note',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ExpandableText(text: event.pleaseNote),
            SizedBox(height: 26),
          ],
          if (event.venues.isNotEmpty) ...[
            Text(
              'Venues',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            for (final venue in event.venues)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: () {
                          final name = venue['name'] as String?;
                          final address =
                              venue['address']['line1'] as String? ?? '';
                          final state = venue['state']['name'] as String? ?? '';
                          final city = venue['city']['name'] as String? ?? '';
                          final country =
                              venue['country']['name'] as String? ?? '';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NAME',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: AppTheme.poppinsFont,
                                ),
                              ),
                              Text(
                                name ?? 'No name',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppTheme.poppinsFont,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'ADDRESS',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: AppTheme.poppinsFont,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text:
                                      address.isNotEmpty ? '$address, ' : null,
                                  children: [
                                    TextSpan(text: city),
                                    TextSpan(text: ', '),
                                    TextSpan(text: state),
                                    TextSpan(text: ', '),
                                    TextSpan(text: country),
                                    if (address.isNotEmpty)
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.arrow_right,
                                          size: 18,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                  ],
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (address.isNotEmpty) {
                                            final encodedAddress =
                                                Uri.encodeComponent(address);
                                            final googleMapsUrl =
                                                "https://www.google.com/maps/search/?api=1&query=$encodedAddress";

                                            if (await canLaunchUrl(
                                              Uri.parse(googleMapsUrl),
                                            )) {
                                              await launchUrl(
                                                Uri.parse(googleMapsUrl),
                                                mode:
                                                    LaunchMode
                                                        .externalApplication,
                                              );
                                            } else {
                                              throw 'Could not launch Google Maps';
                                            }
                                          }
                                        },
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.poppinsFont,
                                    color:
                                        address.isNotEmpty
                                            ? Colors.blueAccent
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
