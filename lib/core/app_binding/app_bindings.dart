
import 'package:get/get.dart';
import 'package:pro_wallet/data/service/firebase_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AuthController>(() => AuthController());
    Get.put(FirebaseService());
    
  }
}