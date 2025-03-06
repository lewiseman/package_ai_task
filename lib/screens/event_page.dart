import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_ai_task/theme.dart';
import 'package:package_ai_task/models/event.dart';
import 'package:package_ai_task/widgets/event_details.dart';
import 'package:package_ai_task/widgets/event_organizers.dart';
import 'package:package_ai_task/widgets/event_tickets.dart';
import 'package:package_ai_task/services/events_service.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.event});
  final Event event;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: size.height * 0.45,
              backgroundColor: Colors.black,
              floating: false,
              pinned: true,
              leading: IconButton.filled(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
              actions: [
                Consumer(
                  builder: (context, ref, _) {
                    final isFavourite = ref
                        .watch(favouritesProvider)
                        .any((e) => e.id == widget.event.id);
                    return IconButton.filled(
                      onPressed: () {
                        ref
                            .read(favouritesProvider.notifier)
                            .toggleFavourite(widget.event);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(
                        isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavourite ? Colors.red : Colors.white,
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Image.network(
                      widget.event.images.first['url'],
                      fit: BoxFit.cover,
                      width: size.width,
                      height: double.maxFinite,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: (size.width * 0.78) / 1.4,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.event.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.all(16),
                tabs: [Text('Details'), Text('Tickets'), Text('Organizers')],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            EventDetailsSection(event: widget.event),
            EventTicketsSection(event: widget.event),
            EventOrganizers(event: widget.event),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final url = Uri.parse(widget.event.url);
          if (!await launchUrl(url)) {
            debugPrint('Could not launch $url');
          }
        },
        backgroundColor: AppTheme.primaryColor,
        icon: Icon(CupertinoIcons.tickets),
        label: Text('Get tickets'),
      ),
    );
  }
}
