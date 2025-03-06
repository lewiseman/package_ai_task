import 'dart:convert';

class Event {
  const Event({
    required this.id,
    required this.name,
    required this.type,
    required this.info,
    required this.url,
    required this.pleaseNote,
    required this.accessibility,
    required this.priceRanges,
    required this.promoters,
    required this.classifications,
    required this.images,
    required this.dates,
    required this.ticketLimit,
    required this.ageRestrictions,
    required this.venues,
    required this.attractions,
    required this.ticketing,
    required this.products,
  });

  final String id;
  final String name;
  final String type;
  final String url;
  final String info;
  final String pleaseNote;
  final Map<String, dynamic> accessibility;
  final List<Map<String, dynamic>> priceRanges;
  final List<Map<String, dynamic>> promoters;
  final List<Map<String, dynamic>> classifications;
  final List<Map<String, dynamic>> images;
  final Map<String, dynamic> dates;
  final Map<String, dynamic> ticketLimit;
  final Map<String, dynamic> ageRestrictions;
  final List<Map<String, dynamic>> venues;
  final List<Map<String, dynamic>> attractions;
  final Map<String, dynamic> ticketing;
  final List<Map<String, dynamic>> products;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      info: json['info'] as String? ?? '',
      url: json['url'] as String? ?? '',
      pleaseNote: json['pleaseNote'] as String? ?? '',
      accessibility: json['accessibility'] as Map<String, dynamic>? ?? {},
      priceRanges:
          json['priceRanges'] != null
              ? List<Map<String, dynamic>>.from(json['priceRanges'] as List)
              : [],
      promoters:
          json['promoters'] != null
              ? List<Map<String, dynamic>>.from(json['promoters'] as List)
              : [],

      classifications:
          json['classifications'] != null
              ? List<Map<String, dynamic>>.from(json['classifications'] as List)
              : [],
      images:
          json['images'] != null
              ? List<Map<String, dynamic>>.from(json['images'] as List)
              : [],
      dates: json['dates'] as Map<String, dynamic>? ?? {},
      ticketLimit: json['ticketLimit'] as Map<String, dynamic>? ?? {},
      ageRestrictions: json['ageRestrictions'] as Map<String, dynamic>? ?? {},
      venues:
          json['_embedded']['venues'] != null
              ? List<Map<String, dynamic>>.from(
                json['_embedded']['venues'] as List,
              )
              : [],
      attractions:
          json['_embedded']['attractions'] != null
              ? List<Map<String, dynamic>>.from(
                json['_embedded']['attractions'] as List,
              )
              : [],
      ticketing: json['ticketing'] as Map<String, dynamic>? ?? {},
      products:
          json['products'] != null
              ? List<Map<String, dynamic>>.from(json['products'] as List)
              : [],
    );
  }

  factory Event.fromString(String json) {
    return Event.fromJson(jsonDecode(json));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'info': info,
      'url': url,
      'pleaseNote': pleaseNote,
      'accessibility': accessibility,
      'priceRanges': priceRanges,
      'images': images,
      'classifications': classifications,
      'promoters': promoters,
      'dates': dates,
      'ticketLimit': ticketLimit,
      'ageRestrictions': ageRestrictions,
      '_embedded': {'venues': venues, 'attractions': attractions},
      'ticketing': ticketing,
      'products': products,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  DateTime? getTime() {
    final datetime = dates['start']['dateTime'] as String?;
    if (datetime == null) return null;
    return DateTime.tryParse(datetime);
  }

  String? anyPrice() {
    if (priceRanges.isEmpty) return null;
    return priceRanges.first['min'] != null
        ? '\$${priceRanges.first['min']} - \$${priceRanges.first['max']}'
        : null;
  }

  List<String> availableClassifications(
    List<Map<String, dynamic>> classifications,
  ) {
    if (classifications.isEmpty) return [];
    final toUse =
        classifications.map((main) {
          final toUse = <String>[];
          if (main['segment'] != null) {
            toUse.add(main['segment']['name'].toString());
          }
          if (main['genre'] != null) {
            toUse.add(main['genre']['name'].toString());
          }
          if (main['subGenre'] != null) {
            toUse.add(main['subGenre']['name'].toString());
          }
          if (main['type'] != null) toUse.add(main['type']['name'].toString());
          if (main['subType'] != null) {
            toUse.add(main['subType']['name'].toString());
          }
          toUse.removeWhere((element) => element == 'Undefined');
          return toUse;
        }).toList();
    return toUse.isNotEmpty ? toUse.expand((element) => element).toList() : [];
  }

  List<String> topClassifications() {
    return availableClassifications(classifications);
  }

  String get mainImage {
    if (images.isEmpty) return '';
    return images.first['url'] as String? ?? '';
  }
}
