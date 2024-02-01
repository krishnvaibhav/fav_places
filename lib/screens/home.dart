import 'package:fav_places/controllers/places_list_controller.dart';
import 'package:fav_places/model/places.dart';
import 'package:fav_places/screens/new_place.dart';
import 'package:fav_places/widgets/styled_list_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PlaceListController controller = Get.put(PlaceListController());

  late Future<void> placeFuture;
  late List<Places> places; // Move the places list here

  @override
  void initState() {
    super.initState();
    placeFuture = controller.loadPlaces();
    places = controller.places; // Initialize places in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Places"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(NewPlace());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading places: ${snapshot.error}'),
            );
          } else {
            return GetBuilder<PlaceListController>(
              builder: (placeListController) {
                return placeListController.places.isNotEmpty
                    ? ListView.builder(
                        itemCount: placeListController.places.length,
                        itemBuilder: (ctx, index) {
                          return StyledListText(
                            title: placeListController.places[index].title,
                            index: index,
                            image: placeListController.places[index].image,
                            address: placeListController
                                .places[index].location.address,
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "There are no places available",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      );
              },
            );
          }
        },
      ),
    );
  }
}
