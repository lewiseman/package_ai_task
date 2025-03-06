import 'package:flutter/material.dart';
import 'package:package_ai_task/config/theme.dart';
import 'package:package_ai_task/models/event.dart';

class EventOrganizers extends StatelessWidget {
  const EventOrganizers({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.promoters.isNotEmpty) ...[
            Text(
              'Promoters',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppTheme.poppinsFont,
              ),
            ),
            SizedBox(height: 8),
            for (final promoter in event.promoters.indexed)
              ListTile(
                leading: Text(
                  '${promoter.$1 + 1} .',
                  style: TextStyle(fontFamily: AppTheme.poppinsFont),
                ),
                minLeadingWidth: 5,
                title: Text(
                  promoter.$2['name'] as String? ?? '',
                  style: TextStyle(fontFamily: AppTheme.poppinsFont),
                ),
                subtitle: Text(
                  promoter.$2['description'] as String? ?? '',
                  style: TextStyle(fontFamily: AppTheme.poppinsFont),
                ),
              ),
            SizedBox(height: 26),
          ],
          if (event.products.isNotEmpty) ...[
            Text(
              'Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppTheme.poppinsFont,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [
                for (final product in event.products)
                  if (product['name'].toString() != event.name)
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
                          title: Text(
                            product['name'] as String? ?? '',
                            style: TextStyle(
                              fontFamily: AppTheme.poppinsFont,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: () {
                            if (product['classifications'] == null) {
                              return null;
                            }
                            final classificationsData =
                                (product['classifications'] as List).map(
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
