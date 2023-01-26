import 'package:get/get.dart';

import '../controllers/all_post_screen_controller.dart';

class AllPostScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllPostScreenController>(
      () => AllPostScreenController(),
    );
  }
}
