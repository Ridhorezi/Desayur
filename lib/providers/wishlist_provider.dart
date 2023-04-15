import 'package:desayur/models/wishlist_model.dart';
import 'package:flutter/material.dart';

class WishlistProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  //! add or remove product item wishlist
  void addRemoveProductToWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      removeOneItem(productId);
    } else {
      _wishlistItems.putIfAbsent(
        productId,
        () => WishlistModel(
          id: DateTime.now().toString(),
          productId: productId,
        ),
      );
    }
    notifyListeners();
  }

  //! remove one wishlist
  void removeOneItem(String productId) {
    _wishlistItems.remove(productId);
    notifyListeners();
  }

  //! clear all wishlist
  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
