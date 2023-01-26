import 'package:get/get.dart';

import '../controllers/show_post_page_controller.dart';

class ShowPostPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowPostPageController>(
      () => ShowPostPageController(),
    );
  }
}
