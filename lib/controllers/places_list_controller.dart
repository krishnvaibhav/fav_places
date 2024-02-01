import 'dart:io';

import 'package:fav_places/model/places.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import "package:sqflite/sqflite.dart" as sql;
import "package:sqflite/sqlite_api.dart";

class PlaceListController extends GetxController {
  List<Places> _places = [];

  List<Places> get places => _places;

  Places _selectedPlace = Places(
      title: '',
      image: File(''),
      location: const PlaceLocation(address: '', lat: 0, lng: 0));

  Places get selectedPlace => _selectedPlace;

  Future<Database> _openDB() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT);",
      );
    }, version: 1);

    return db;
  }

  Future<void> loadPlaces() async {
    final db = await _openDB();
    final data = await db.query('user_places');

    final places = data
        .map((row) => Places(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
                address: row['address'] as String,
                lat: row['lat'] as double,
                lng: row['lng'] as double)))
        .toList();

    _places = places;
  }

  void addPlace(title, File image, location) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy("${appDir.path}/$fileName");
    final place = Places(title: title, image: copiedImage, location: location);

    final db = await _openDB();

    db.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.location.lat,
      'lng': place.location.lng,
      'address': place.location.address
    });

    _places.add(place);

    update();
  }

  void selectPlace(n) {
    _selectedPlace = _places[n];
    update();
  }
}
