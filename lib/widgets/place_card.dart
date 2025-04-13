import 'package:flutter/material.dart';
import '../models/place_model.dart';

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.place),
        title: Text(place.name),
        subtitle: Text("Lat: ${place.lat}, Lng: ${place.lat}"),
      ),
    );
  }
}
