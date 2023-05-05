import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desayur/models/products_model.dart';
import 'package:flutter/material.dart';

class ProductsProvider with ChangeNotifier {
  static List<ProductModel> _productsList = [];

  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      _productsList = [];
      // ignore: avoid_function_literals_in_foreach_calls
      productSnapshot.docs.forEach((element) {
        double price = double.parse(element.get('price'));
        double salePrice = double.parse(element.get('salePrice'));
        _productsList.insert(
          0,
          ProductModel(
            id: element.get('id'),
            title: element.get('title'),
            imageUrl: element.get('imageUrl'),
            productCategoryName: element.get('productCategoryName'),
            price: price,
            salePrice: salePrice,
            isOnSale: element.get('isOnSale'),
            isPiece: element.get('isPiece'),
          ),
        );
      });
    });

    notifyListeners();
  }

  ProductModel findProductById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findProductByCategory(String categoryName) {
    // ignore: no_leading_underscores_for_local_identifiers
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    // ignore: no_leading_underscores_for_local_identifiers
    List<ProductModel> _searchList = _productsList
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }
}
