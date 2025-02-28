import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_wallet/app_theme.dart';
import 'package:pro_wallet/core/routing/app_pages.dart';
import 'package:pro_wallet/data/models/transaction_model.dart';
import 'package:pro_wallet/modules/dashboard/dashboard_controllers/dashboard_controller.dart';
import 'package:pro_wallet/modules/history/history_controllers/history_controller.dart';
import 'package:pro_wallet/modules/history/views/history_view.dart';
import 'package:pro_wallet/modules/home/controllers/home_controller.dart';
import 'package:pro_wallet/modules/home/views/home_view.dart';
import 'package:pro_wallet/modules/profile/views/profile_view.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeView(),
            HistoryView(),
            ProfileView(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          elevation: 8,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() {
        
        // Only show FAB on home screen
        return controller.currentIndex.value == 0
            ? FloatingActionButton(
                onPressed: () => _showTransactionModal(context),
                backgroundColor: AppTheme.primaryColor,
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink();
      }),
    );
  }

  void _showTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TransactionBottomSheet(),
    );
  }
}

class _TransactionBottomSheet extends StatelessWidget {
  _TransactionBottomSheet({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Transaction',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description field
            TextField(
              onChanged: (value) =>
                  homeController.transactionDescription.value = value,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Amount field
            TextField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  homeController.transactionAmount.value =
                      double.tryParse(value) ?? 0.0;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),

            // Transaction type buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        homeController.addTransaction(TransactionType.income),
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text('Income'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.incomeColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        homeController.addTransaction(TransactionType.expense),
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('Expense'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.expenseColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
