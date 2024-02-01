import "dart:io";
import "package:uuid/uuid.dart";

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation(
      {required this.lat, required this.lng, required this.address});

  final double lat;
  final double lng;
  final String address;
}

class Places {
  Places({required this.title, required this.image, required this.location, id})
      : id = id ?? uuid.v4();

  final String title;
  final String id;
  final File image;
  final PlaceLocation location;
}
