import 'package:fav_places/controllers/places_list_controller.dart';
import 'package:fav_places/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedPlace extends StatelessWidget {
  SelectedPlace({super.key});

  var API = "AIzaSyCx66LcBoTm_bNZzyczpCahGmHtakkRh9s";

  String locationImage(location) {
    if (location == null) {
      return '';
    }

    final lat = location!.lat;
    final lng = location!.lng;
    const color = "red";
    const label = "V";
    const zoom = "17";

    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=$zoom&size=600x300&maptype=roadmap&markers=color:$color%7Clabel:$label%7C$lat,$lng&key=$API";
  }

  void handleNavigationToMap() {
    Get.to(() => const MapScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<PlaceListController>(
          builder: (controller) => Text(controller.selectedPlace.title),
        ),
      ),
      body: GetBuilder<PlaceListController>(
        builder: (controller) => Stack(
          children: [
            Image.file(
              controller.selectedPlace.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: handleNavigationToMap,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                              locationImage(controller.selectedPlace.location)),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.transparent, Colors.black54])),
                      alignment: Alignment.center,
                      child: Text(
                        controller.selectedPlace.location.address,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
