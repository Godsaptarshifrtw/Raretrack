class Place {
  final String name;
  final double lat;
  final double lon;

  Place({
    required this.name,
    required this.lat,
    required this.lon,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['display_name'] ?? json['name'] ?? 'Unnamed',
      lat: double.tryParse(json['lat'] ?? '') ?? 0.0,
      lon: double.tryParse(json['lon'] ?? '') ?? 0.0,
    );
  }
}
