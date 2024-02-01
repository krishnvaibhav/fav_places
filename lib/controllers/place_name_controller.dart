import 'package:get/get.dart';

class PlaceController extends GetxController {
  String _title = '';

  String get title => _title;

  void setTitle(newTitle) {
    _title = newTitle;
    update();
  }
}
