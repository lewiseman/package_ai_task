import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_ai_task/theme.dart';
import 'package:package_ai_task/models/event.dart';
import 'package:package_ai_task/screens/event_page.dart';
import 'package:package_ai_task/utils.dart';

class LandscapeEventCard extends StatelessWidget {
  const LandscapeEventCard({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    final dateTimes = event.getTime();
    final price = event.anyPrice();
    final classifications = event.topClassifications();
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              maintainState: false,
              builder: (context) => EventPage(event: event),
            ),
          );
        },
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (event.mainImage != null)
                CachedNetworkImage(
                  imageUrl: event.mainImage!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          Center(child: CupertinoActivityIndicator()),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dateTimes.start != null || dateTimes.end != null)
                        Row(
                          children: [
                            if (dateTimes.start != null)
                              Text(
                                '${dateTimes.start!.humanSlashDate}${dateTimes.end == null ? ' • ${dateTimes.start!.humanTime}' : ' → '}',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontFamily: AppTheme.poppinsFont,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            if (dateTimes.end != null)
                              Text(
                                '${dateTimes.end!.humanSlashDate}${dateTimes.start == null ? ' • ${dateTimes.end!.humanTime}' : ''}',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontFamily: AppTheme.poppinsFont,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      Text(
                        event.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: AppTheme.poppinsFont,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      if (price != null)
                        Text(
                          price,
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: AppTheme.poppinsFont,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else if (classifications.isNotEmpty)
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: classifications.join(', '),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: AppTheme.poppinsFont,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
