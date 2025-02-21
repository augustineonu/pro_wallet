import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_wallet/modules/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  
  final RxBool isEditing = false.obs;
  final TextEditingController nameController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    nameController.text = _authController.userModel.value?.name ?? '';
  }
  
  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // Reset to original value if canceled
      nameController.text = _authController.userModel.value?.name ?? '';
    }
  }
  
  Future<void> signOut() async {
    await _authController.signOut();
  }
}