import 'package:get/get.dart';
import 'package:pro_wallet/data/models/transaction_model.dart';
import 'package:pro_wallet/data/service/firebase_service.dart';
import 'package:pro_wallet/modules/auth/controllers/auth_controller.dart';

class HistoryController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final AuthController _authController = Get.find<AuthController>();
  
  final RxList<TransactionModel> allTransactions = <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadAllTransactions();
  }
  
  Future<void> loadAllTransactions() async {
    if (_authController.firebaseUser.value == null) return;
    
    isLoading.value = true;
    try {
      String userId = _authController.firebaseUser.value!.uid;
      allTransactions.value = await _firebaseService.getUserTransactions(userId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load transactions: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  
  double get totalIncome {
    return allTransactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0, (sum, item) => sum + item.amount);
  }
  
  double get totalExpense {
    return allTransactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0, (sum, item) => sum + item.amount);
  }
}