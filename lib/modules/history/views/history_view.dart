import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pro_wallet/app_theme.dart';
import 'package:pro_wallet/modules/history/history_controllers/history_controller.dart';

class HistoryViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HistoryController>(HistoryController());
  }
}

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadAllTransactions,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.allTransactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your transaction history will appear here',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Summary cards
              _buildSummaryCards(context),

              // Transactions list
              // Expanded(
              //   child: ListView.builder(
              //     padding: const EdgeInsets.all(16),
              //     itemCount: controller.allTransactions.length,
              //     itemBuilder: (context, index) {
              //       final transaction = controller.allTransactions[index];

              //       // Group transactions by date
              //       if (index == 0 ||
              //           !_isSameDay(
              //               controller.allTransactions[index - 1].createdAt,
              //               transaction.createdAt)) {
              //         return Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             if (index > 0) const SizedBox(height: 16),
              //             _buildDateHeader(context, transaction.createdAt),
              //             const SizedBox(height: 8),
              //             _buildTransactionItem(context, transaction),
              //           ],
              //         );
              //       }

              //       return _buildTransactionItem(context, transaction);
              //     },
              //   ),
              // ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          // Income Card
          Expanded(
              child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.incomeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.arrow_downward,
                                  color: AppTheme.incomeColor,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ]),
                  )))
        ]));
  }
}
