import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desayur/consts/firebase_consts.dart';
import 'package:desayur/models/wishlist_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  //! fetch data wishlist from firebase
  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchWishlist() async {
    final User? user = authInstance.currentUser;
    DocumentSnapshot userDoc;
    if (user != null) {
      userDoc = await userCollection.doc(user.uid).get();
    } else {
      return;
    }
    final leng = userDoc.get('userWish').length;
    for (int i = 0; i < leng; i++) {
      _wishlistItems.putIfAbsent(
        userDoc.get('userWish')[i]['productId'],
        () => WishlistModel(
          id: userDoc.get('userWish')[i]['wishlistId'],
          productId: userDoc.get('userWish')[i]['productId'],
        ),
      );
    }
    notifyListeners();
  }

  //! remove one item at the wishlist
  Future<void> removeOneItem({
    required String wishlistId,
    required String productId,
  }) async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish': FieldValue.arrayRemove([
        {'wishlistId': wishlistId, 'productId': productId}
      ])
    });
    _wishlistItems.remove(productId);
    await fetchWishlist();
    notifyListeners();
  }

  //! clear all wishlist live
  Future<void> clearLiveWishlist() async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish': [],
    });
    _wishlistItems.clear();
    notifyListeners();
  }

  //! clear all wishlist local
  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
