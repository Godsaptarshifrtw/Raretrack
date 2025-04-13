import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

class OSMService {
  static Future<List<Place>> getNearbyPlaces(double lat, double lon, String category) async {
    final delta = 0.05; // approx 5 km radius
    final viewBox = '${lon - delta},${lat - delta},${lon + delta},${lat + delta}';

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$category'
          '&format=json&limit=10&viewbox=$viewBox&bounded=1',
    );

    final response = await http.get(url, headers: {
      'User-Agent': 'FlutterApp/1.0 (your@email.com)', // Required by OSM
    });

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Place(
        name: item['display_name'],
        lat: double.parse(item['lat']),
        lon: double.parse(item['lon']), // ✅ Correct field
      )).toList();
    } else {
      throw Exception("Failed to fetch nearby places");
    }
  }
}//
