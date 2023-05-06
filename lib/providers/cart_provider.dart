import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desayur/consts/firebase_consts.dart';
import 'package:desayur/models/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  //! add products to cart
  // void addProductsToCart({
  //   required String productId,
  //   required int quantity,
  // }) {
  //   _cartItems.putIfAbsent(
  //     productId,
  //     () => CartModel(
  //       id: DateTime.now().toString(),
  //       productId: productId,
  //       quantity: quantity,
  //     ),
  //   );
  //   notifyListeners();
  // }

  //! fetch data cart from firebase

  Future<void> fetchCart() async {
    final User? user = authInstance.currentUser;
    // ignore: no_leading_underscores_for_local_identifiers
    String _uid = user!.uid;
    // ignore: unused_local_variable
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    // ignore: unnecessary_null_comparison
    if (userDoc == null) {
      return;
    }
    final cartData = userDoc.get('userCart').length;
    for (int i = 0; i < cartData; i++) {
      _cartItems.putIfAbsent(
        userDoc.get('userCart')[i]['productId'],
        () => CartModel(
          id: userDoc.get('userCart')[i]['cartId'],
          productId: userDoc.get('userCart')[i]['productId'],
          quantity: userDoc.get('userCart')[i]['quantity'],
        ),
      );
    }

    notifyListeners();
  }

  //! reduce quantity cart by one
  void reduceQuantityByOne(String productId) {
    _cartItems.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: value.productId,
        quantity: value.quantity - 1,
      ),
    );
    notifyListeners();
  }

  //! increase quantity cart by one
  void increaseQuantityByOne(String productId) {
    _cartItems.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: value.productId,
        quantity: value.quantity + 1,
      ),
    );
    notifyListeners();
  }

  //! remove one item at the cart
  void removeOneItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  //! clear all product from cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
