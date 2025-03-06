import 'package:flutter/material.dart';
import 'package:package_ai_task/theme.dart';
import 'package:package_ai_task/screens/events_page.dart';
import 'package:package_ai_task/screens/explore_page.dart';
import 'package:package_ai_task/screens/favourites_page.dart';
import 'package:package_ai_task/widgets/search.dart';

class EventsApp extends StatefulWidget {
  const EventsApp({super.key});

  @override
  State<EventsApp> createState() => _EventsAppState();
}

class _EventsAppState extends State<EventsApp> {
  int _selectedIndex = 0;
  bool _isBottomNavVisible = true;
  double _lastOffset = 0.0;

  void _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.axis == Axis.horizontal) return;
      double currentOffset = notification.metrics.pixels;

      if (currentOffset > _lastOffset + 20) {
        // Scroll down, hide bottom bar
        if (_isBottomNavVisible) {
          setState(() {
            _isBottomNavVisible = false;
          });
        }
      } else if (currentOffset < _lastOffset) {
        // Scroll up, show bottom bar immediately
        if (!_isBottomNavVisible) {
          setState(() {
            _isBottomNavVisible = true;
          });
        }
      }

      _lastOffset = currentOffset;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _navigations[_selectedIndex];
    final theme = Theme.of(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        _onScroll(scrollInfo);
        return true;
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(
            selected.label,
            style: TextStyle(
              fontFamily: AppTheme.paintFont,
              color: Colors.grey[800],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (selected.label == 'Events') ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Hello',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppTheme.poppinsFont,
                    ),
                  ),
                  Text(
                    'Dwight Johnson',
                    style: TextStyle(fontFamily: AppTheme.poppinsFont),
                  ),
                ],
              ),
              IconButton(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/avatar.jpg',
                    width: 34,
                    height: 34,
                    fit: BoxFit.cover,
                  ),
                ),
                onPressed: () {},
              ),
              SizedBox(width: 8),
            ],
            if (selected.label == 'Explore') ...[
              IconButton(
                icon: Image.asset(
                  'assets/images/notification.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                onPressed: () {},
              ),
            ],
          ],
          bottom:
              (selected.label == 'Events')
                  ? PreferredSize(
                    preferredSize: Size.fromHeight(74),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.grey[200],
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: () {
                                  showSearch(
                                    context: context,
                                    delegate: EventsSearch(),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search),
                                      SizedBox(width: 8),
                                      Text(
                                        'Search events',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                          fontFamily: AppTheme.poppinsFont,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Material(
                            color: Colors.grey[200],
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: () {
                                showSearch(
                                  context: context,
                                  delegate: EventsSearch(),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(Icons.filter_alt_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : null,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: selected.destination,
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              constraints: BoxConstraints(maxWidth: 800),
              height: _isBottomNavVisible ? theme.navigationBarTheme.height : 0,
              child: Wrap(
                children: [
                  NavigationBar(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelBehavior:
                        NavigationDestinationLabelBehavior.onlyShowSelected,
                    labelPadding: EdgeInsets.only(bottom: 16),
                    destinations:
                        _navigations
                            .map(
                              (navigation) => NavigationDestination(
                                icon: Image.asset(
                                  'assets/images/${navigation.image}',
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.fill,
                                ),
                                selectedIcon: Image.asset(
                                  'assets/images/${navigation.activeImage}',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.fill,
                                ),
                                label: navigation.label,
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _navigations = [
  (
    label: 'Events',
    image: 'cheers.png',
    activeImage: 'cheers_filled.png',
    destination: EventsPage(),
  ),
  (
    label: 'Explore',
    image: 'planet.png',
    activeImage: 'planet_filled.png',
    destination: ExplorePage(),
  ),
  (
    label: 'Favorites',
    image: 'star.png',
    activeImage: 'star_filled.png',
    destination: FavouritesPage(),
  ),
];
