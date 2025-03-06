import 'package:flutter/material.dart';
import 'package:package_ai_task/models/event.dart';

class EventTicketsSection extends StatelessWidget {
  const EventTicketsSection({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.priceRanges.isNotEmpty)
            Wrap(
              children: [
                for (final priceRange in event.priceRanges)
                  Card(
                    elevation: .5,
                    margin: EdgeInsets.only(bottom: 26),
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(),
                    child: ListTile(
                      title: Text(
                        (priceRange['type'] as String? ?? '').toUpperCase(),
                      ),
                      subtitle: Text(
                        'Price: ${priceRange['currency']}${priceRange['min']} - ${priceRange['currency']}${priceRange['max']}',
                      ),
                    ),
                  ),
              ],
            ),
          if (event.ticketLimit.isNotEmpty) ...[
            Text('Ticket Limit', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('${event.ticketLimit['info']}', style: TextStyle()),
            SizedBox(height: 26),
          ],
          if (event.attractions.isNotEmpty) ...[
            Text(
              'Other attractions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [
                for (final attraction in event.attractions)
                  if (attraction['name'].toString() != event.name)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: size.width / 2 - 32,
                      ),
                      child: Card(
                        elevation: .5,
                        margin: EdgeInsets.only(bottom: 26),
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(),
                        child: ListTile(
                          title: Text(attraction['name'] as String? ?? ''),
                          subtitle: () {
                            if (attraction['classifications'] == null) {
                              return null;
                            }
                            final classificationsData =
                                (attraction['classifications'] as List).map(
                                  (x) => x as Map<String, dynamic>,
                                );
                            final classifications = event
                                .availableClassifications(
                                  classificationsData.toList(),
                                );
                            if (classifications.isEmpty) {
                              return null;
                            }
                            final toUse = classifications.join(' • ');
                            return Text(
                              toUse,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            );
                          }(),
                        ),
                      ),
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
