import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:package_ai_task/screens/event_page.dart';
import 'package:package_ai_task/services/events_service.dart';

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouritesProvider);
    if (favourites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty.png', width: 100),
            SizedBox(height: 20),
            Text('No favourites yet'),
          ],
        ),
      );
    }
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: favourites.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = favourites[index];
        final price = item.anyPrice();
        final classifications = item.topClassifications();
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  maintainState: false,
                  builder: (context) => EventPage(event: item),
                ),
              );
            },
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 120),
                  child: Image.network(item.mainImage, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 2,
                      ),
                      if (price != null) ...[
                        SizedBox(height: 8),
                        Text(price, style: TextStyle(color: Colors.green)),
                      ],
                      if (classifications.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Text(
                          classifications.join(' • '),
                          style: TextStyle(color: Colors.grey[600]),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
