// transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final TransactionType type;
  final String description;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: json['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}