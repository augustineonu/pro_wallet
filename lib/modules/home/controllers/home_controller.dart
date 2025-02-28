import 'package:get/get.dart';
import 'package:pro_wallet/data/models/transaction_model.dart';
import 'package:pro_wallet/data/service/firebase_service.dart';
import 'package:pro_wallet/modules/auth/controllers/auth_controller.dart';
import 'package:pro_wallet/modules/history/history_controllers/history_controller.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final AuthController _authController = Get.find<AuthController>();
  final HistoryController _historyController = Get.find<HistoryController>();

  final RxList<TransactionModel> recentTransactions = <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString transactionDescription = ''.obs;
  final RxDouble transactionAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    loadRecentTransactions();
  }

  Future<void> loadRecentTransactions() async {
    if (_authController.firebaseUser.value == null) return;

    isLoading.value = true;
    try {
      String userId = _authController.firebaseUser.value!.uid;

      List<TransactionModel> allTransactions =
          await _firebaseService.getUserTransactions(userId);
      print("Recent transactions: ${allTransactions.first.toString()}");

      // Get only 5 most recent transactions
      recentTransactions.value = allTransactions.take(5).toList();
    } catch (e) {
      print("Error loading transactions: ${e.toString()}");
      Get.snackbar('Error', 'Failed to load transactions: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTransaction(TransactionType type) async {
    if (_authController.firebaseUser.value == null) return;
    if (transactionAmount.value <= 0) {
      Get.snackbar('Error', 'Amount must be greater than 0');
      return;
    }

    isLoading.value = true;
    try {
      String userId = _authController.firebaseUser.value!.uid;

      TransactionModel newTransaction = TransactionModel(
        id: '',
        userId: userId,
        amount: transactionAmount.value,
        type: type,
        description: transactionDescription.value,
        createdAt: DateTime.now(),
      );

      await _firebaseService.addTransaction(newTransaction);

      // Refresh user data and transactions
      await _authController.loadUserProfile(userId);
      await loadRecentTransactions();
      await _historyController.loadAllTransactions();

      // Reset form
      transactionDescription.value = '';
      transactionAmount.value = 0.0;

      Get.back(); // Close dialog

      Get.snackbar(
        'Success',
        '${type == TransactionType.income ? "Income" : "Expense"} added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add transaction: ${e.toString()}');
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
