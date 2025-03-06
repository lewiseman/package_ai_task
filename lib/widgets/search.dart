import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_ai_task/services/events_service.dart';
import 'package:package_ai_task/widgets/landscape_event_card.dart';

class EventsSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return FutureBuilder(
          future: ref
              .read(eventsServiceProvider.notifier)
              .getLiveSearchResults(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.hasData) {
              final results = snapshot.data ?? [];
              if (results.isEmpty) {
                return Center(child: Text('No results found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(22),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return LandscapeEventCard(event: result);
                },
              );
            }
            return SizedBox.shrink();
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return FutureBuilder(
          future: ref
              .read(eventsServiceProvider.notifier)
              .getSearchSuggestions(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.hasData) {
              final suggestions = snapshot.data ?? [];
              return ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return ListTile(
                    leading: Icon(Icons.history_rounded),
                    title: _buildHighlightedText(suggestion.name, query),
                    onTap: () {
                      query = suggestion.name;
                      showResults(context);
                    },
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                    thickness: 1,
                    color: Colors.grey[300],
                  );
                },
              );
            }
            return SizedBox.shrink();
          },
        );
      },
    );
  }
}


Widget _buildHighlightedText(String text, String query) {
  if (query.isEmpty) return Text(text);

  String lowerText = text.toLowerCase();
  String lowerQuery = query.toLowerCase();

  int startIndex = lowerText.indexOf(lowerQuery);
  if (startIndex == -1) return Text(text);

  int endIndex = startIndex + query.length;

  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: text.substring(0, startIndex),
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        TextSpan(
          text: text.substring(startIndex, endIndex),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: text.substring(endIndex),
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ],
    ),
  );
}
