import 'package:desayur/models/viewed_model.dart';
import 'package:flutter/material.dart';

class ViewedProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, ViewedModel> _viewedlistItems = {};

  Map<String, ViewedModel> get getViewedlistItems {
    return _viewedlistItems;
  }

  //! add or remove product item wishlist
  void addProductToHistory({required String productId}) {
    _viewedlistItems.putIfAbsent(
      productId,
      () => ViewedModel(
        id: DateTime.now().toString(),
        productId: productId,
      ),
    );
    notifyListeners();
  }

  //! clear all wishlist
  void clearHistory() {
    _viewedlistItems.clear();
    notifyListeners();
  }
}
