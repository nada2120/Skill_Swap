import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  var showGameFirst = false.obs;

  @override
  void onInit() {
    bool isFirst = box.read("isFirstLaunch") ?? true;

    if (isFirst) {
      showGameFirst.value = true;
      box.write("isFirstLaunch", false);
    }
    super.onInit();
  }
}
