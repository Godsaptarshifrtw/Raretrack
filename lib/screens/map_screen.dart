import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

class MapScreen extends StatefulWidget {
  final double lat, lng;
  final List<Place> places;

  const MapScreen({
    Key? key,
    required this.lat,
    required this.lng,
    required this.places,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;

  // ✅ Fetch route from OpenRouteService API
  Future<void> _getRoute(double destLat, double destLng) async {
    const apiKey = '5b3ce3597851110001cf6248925003f219ed41d993c6adb36f9f93a2'; // Replace with your API Key
    final url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${widget.lng},${widget.lat}&end=$destLng,$destLat',
    );

    setState(() => _isLoadingRoute = true);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coords = data['features'][0]['geometry']['coordinates'] as List;

        setState(() {
          _routePoints = coords.map((c) => LatLng(c[1], c[0])).toList();
          _isLoadingRoute = false;
        });
      } else {
        _showError("Failed to load route (Status: ${response.statusCode})");
      }
    } catch (e) {
      _showError("Something went wrong while fetching directions.");
    }
  }

  // ✅ Show snackbar error
  void _showError(String message) {
    setState(() => _isLoadingRoute = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // ✅ Bottom sheet to show place info + button to get directions
  void _showPlaceDetails(BuildContext context, Place place) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Latitude: ${place.lat.toStringAsFixed(6)}'),
              Text('Longitude: ${place.lon.toStringAsFixed(6)}'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _getRoute(place.lat, place.lon);
                },
                icon: const Icon(Icons.directions),
                label: const Text("Show Directions"),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ Main screen build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Hospitals")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(widget.lat, widget.lng),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.goddy',
              ),
              MarkerLayer(
                markers: [
                  // Current location marker
                  Marker(
                    width: 80,
                    height: 80,
                    point: LatLng(widget.lat, widget.lng),
                    child: const Icon(Icons.my_location, color: Colors.blue, size: 40),
                  ),
                  // Place markers
                  ...widget.places.map((place) {
                    return Marker(
                      width: 200,
                      height: 80,
                      point: LatLng(place.lat, place.lon),
                      child: GestureDetector(
                        onTap: () => _showPlaceDetails(context, place),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                              ),
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: Text(
                                place.name,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Icon(Icons.local_hospital, color: Colors.red, size: 30),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
              // Route polyline
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Colors.blue,
                      strokeWidth: 5,
                    ),
                  ],
                ),
            ],
          ),

          // ✅ Loading overlay for route fetching
          if (_isLoadingRoute)
            Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
//