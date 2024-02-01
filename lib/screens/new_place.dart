import 'dart:io';

import 'package:fav_places/controllers/places_list_controller.dart';
import 'package:fav_places/model/places.dart';
import 'package:fav_places/widgets/image_input.dart';
import 'package:fav_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPlace extends StatelessWidget {
  File? selectedImage;
  PlaceLocation? selectedLocation;
  NewPlace({super.key});

  final _placeNameController = TextEditingController();
  PlaceListController controller = Get.find();

  void handleAdd(context) {
    if (_placeNameController.text != "" ||
        selectedImage != null ||
        selectedLocation != null) {
      controller.addPlace(
          _placeNameController.text, selectedImage!, selectedLocation!);
      _placeNameController.clear();
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Please enter a valid place name!')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new place")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          Column(
            children: [
              TextField(
                style: const TextStyle(
                    color: Colors.white, decorationColor: Colors.white),
                controller: _placeNameController,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                    hintText: "Place Name",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                height: 20,
              ),
              ImageInput(
                onPickImage: (image) {
                  selectedImage = image;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              LocationInput(
                onSelectLocation: (location) {
                  selectedLocation = location;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    handleAdd(context);
                  },
                  child: const Text("Add"))
            ],
          ),
        ]),
      ),
    );
  }
}
