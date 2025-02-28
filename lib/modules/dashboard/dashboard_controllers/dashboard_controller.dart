import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_wallet/modules/auth/controllers/auth_controller.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    // Get.put(AuthController());
    super.onInit();
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
