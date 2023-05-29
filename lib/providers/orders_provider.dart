import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desayur/consts/firebase_consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:desayur/models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }

  //! clear all orders local
  void clearLocalOrders() {
    _orders.clear();
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    User? user = authInstance.currentUser;
    if (user == null) {
      // error handling user null
      return;
    }
    var uid = user.uid;
    await FirebaseFirestore.instance
        .collection('orders')
        .where("userId", isEqualTo: uid)
        .orderBy('orderDate', descending: false)
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      _orders = [];
      // ignore: avoid_function_literals_in_foreach_calls
      ordersSnapshot.docs.forEach((element) {
        _orders.insert(
          0,
          OrderModel(
            orderId: element.get('orderId'),
            userId: element.get('userId'),
            productId: element.get('productId'),
            userName: element.get('userName'),
            price: element.get('price').toString(),
            imageUrl: element.get('imageUrl'),
            quantity: element.get('quantity').toString(),
            orderDate: element.get('orderDate'),
          ),
        );
      });
    });
    notifyListeners();
  }
}
