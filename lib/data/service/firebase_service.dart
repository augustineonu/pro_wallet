import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pro_wallet/data/models/transaction_model.dart';
import 'package:pro_wallet/data/models/user_model.dart';

class FirebaseService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FirebaseService> init() async {
    print('FirebaseService initialized');
    return this;
  }

  // Authentication methods
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  // User methods
  Future<void> createUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson());
  }

  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      print("Firebase Service:: profile loaded: ${doc.data()}");
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  Future<void> updateUserWalletBalance(String userId, double newBalance) async {
    await _firestore.collection('users').doc(userId).update({
      'walletBalance': newBalance,
    });
  }

  // Transaction methods

  Future<void> createUserTransaction(String userId) async {
    await _firestore.collection('transactions').doc(userId).set(
      TransactionModel(
        id: userId,
        userId: userId,
        type: TransactionType.income,
        amount: 1000,
        description: 'Initial balance',
        createdAt: DateTime.now(),
      ).toJson(),
    );
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final docRef = _firestore.collection('transactions').doc();
    await docRef.set({
      ...transaction.toJson(),
      'id': docRef.id,
    });

    // Update user balance
    final userDoc =
        await _firestore.collection('users').doc(transaction.userId).get();
    if (userDoc.exists) {
      final userData = userDoc.data();
      double currentBalance = (userData?['walletBalance'] ?? 0.0).toDouble();
      double newBalance = transaction.type == TransactionType.income
          ? currentBalance + transaction.amount
          : currentBalance - transaction.amount;

      await updateUserWalletBalance(transaction.userId, newBalance);
    }
  }

  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    final snapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
}
