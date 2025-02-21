import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;
  
  void changePage(int index) {
    currentIndex.value = index;
  }
}