import 'dart:convert';

import 'package:fav_places/model/places.dart';
import 'package:fav_places/screens/map_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import "package:http/http.dart" as http;

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key, required this.onSelectLocation})
      : super(key: key);

  final void Function(PlaceLocation location) onSelectLocation;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

var isGettingLocation = false;

var API = "AIzaSyCx66LcBoTm_bNZzyczpCahGmHtakkRh9s";

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? pickedLocation;

  String get locationImage {
    if (pickedLocation == null) {
      return '';
    }

    final lat = pickedLocation!.lat;
    final lng = pickedLocation!.lng;
    const color = "red";
    const label = "V";
    const zoom = "17";

    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=$zoom&size=600x300&maptype=roadmap&markers=color:$color%7Clabel:$label%7C$lat,$lng&key=$API";
  }

  void _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$API');
    final response = await http.get(url);

    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    if (address == null) {
      return;
    }

    setState(() {
      pickedLocation = PlaceLocation(lat: lat, lng: lng, address: address);
      isGettingLocation = false;
    });

    widget.onSelectLocation(pickedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      setState(() {
        isGettingLocation = true;
      });
      locationData = await location.getLocation();
      final lat = locationData.latitude;
      final lng = locationData.longitude;

      if (lat == null || lng == null) {
        return;
      }

      _savePlace(lat, lng);
    } catch (err) {
      if (kDebugMode) {
        print("Error occurred: $err");
      }
    }
  }

  void _selectOnMap() async {
    final pickedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (context) => const MapScreen(),
    ));

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Center(
      child: Text(
        "No location chosen currently",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
    );

    if (isGettingLocation) {
      previewContent = const Center(child: CircularProgressIndicator());
    }

    if (pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: previewContent,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                _getCurrentLocation();
              },
              icon: const Icon(Icons.location_on),
              label: const Text("Get Current Location"),
            ),
            TextButton.icon(
              onPressed: () {
                _selectOnMap();
              },
              icon: const Icon(Icons.map),
              label: const Text("Select on Map"),
            ),
          ],
        ),
      ],
    );
  }
}
