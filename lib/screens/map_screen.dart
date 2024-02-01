import 'package:fav_places/model/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.location =
          const PlaceLocation(lat: 37.422, lng: -122.084, address: ''),
      this.isSelecting = true});

  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickekLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickekLocation);
              },
            )
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (pos) {
                setState(() {
                  _pickekLocation = pos;
                });
              },
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.location.lat, widget.location.lng), zoom: 16),
        markers: (_pickekLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                    markerId: const MarkerId('m1'),
                    position: LatLng(
                        _pickekLocation!.latitude, _pickekLocation!.longitude))
              },
      ),
    );
  }
}
