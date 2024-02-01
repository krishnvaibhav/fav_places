// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:fav_places/controllers/places_list_controller.dart';
import 'package:fav_places/main.dart';
import 'package:fav_places/screens/selected_place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StyledListText extends StatelessWidget {
  StyledListText(
      {super.key,
      required this.title,
      required this.index,
      required this.image,
      required this.address});

  final String title;
  final int index;
  final File image;
  final String address;

  PlaceListController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
          style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              shape: const BeveledRectangleBorder()),
          onPressed: () {
            controller.selectPlace(index);
            Get.to(() => SelectedPlace());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(backgroundImage: FileImage(image)),
                  ),
                  Text(
                    "${title[0].toUpperCase()}${title.substring(1)}",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(address,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              )
            ],
          )),
    );
  }
}
