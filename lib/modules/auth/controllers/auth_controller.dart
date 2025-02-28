import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_wallet/core/routing/app_pages.dart';
import 'package:pro_wallet/data/models/user_model.dart';
import 'package:pro_wallet/data/service/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);

  final RxBool isLoading = false.obs;

  RxBool isPasswordVisible = false.obs;
  RxBool isPassword1Visible = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.value = _firebaseService.currentUser;

    ever(firebaseUser, _setInitialScreen);

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      firebaseUser.value = user;
      if (user != null) {
        loadUserProfile(user.uid);
      }
    });
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      print("User:: ${user.toString()}");
      print("User:: ${user.email}");
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  Future<void> loadUserProfile(String userId) async {
    isLoading.value = true;
    try {
      userModel.value = await _firebaseService.getUserProfile(userId);
      // var useerData = await _firebaseService.getUserProfile(userId);
      print("User profile loaded: ${userModel.value!.toJson()}");
      // print("User profile loaded: ${useerData!.toJson()}");
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load user profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String signupErrorMessge = "";

  Future<void> signUp(String name, String email, String password) async {
    isLoading.value = true;
    try {
      UserCredential userCredential =
          await _firebaseService.signUp(email, password);

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        walletBalance: 1000.0,
        createdAt: DateTime.now(),
      );

      print("Saving user to Firestore: ${newUser.toJson()}");

      await _firebaseService.createUserProfile(newUser).then((_) async {
        await _firebaseService.createUserTransaction(newUser.id);
      });

      // Wait for the profile to be fully loaded
      await loadUserProfile(userCredential.user!.uid);

      Get.snackbar(
        'Success',
        'Account created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Now navigate to the dashboard
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      print("Signup error: $e");
      if (e.toString().contains("email address is already in use")) {
        signupErrorMessge = "Email address is already in use";
      } else {
        signupErrorMessge = e.toString();
      }
      Get.snackbar(
        'Error',
        'Failed to create account: $signupErrorMessge',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      await _firebaseService.signIn(email, password);

      Get.snackbar(
        'Success',
        'Logged in successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to login: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
      userModel.value = null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool get isLoggedIn => firebaseUser.value != null;
}
