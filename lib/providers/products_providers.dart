import 'package:desayur/models/products_model.dart';
import 'package:flutter/material.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  ProductModel findProductById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  static final List<ProductModel> _productsList = [
    ProductModel(
      id: 'Apricots',
      title: 'Apricots',
      imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
      productCategoryName: 'Fruits',
      price: 0.99,
      salePrice: 0.35,
      isOnSale: true,
      isPiece: false,
    ),
    ProductModel(
      id: 'Green grape',
      title: 'Green Grape',
      imageUrl: 'https://i.ibb.co/bHKtc33/grape-green.png',
      productCategoryName: 'Fruits',
      price: 0.99,
      salePrice: 0.4,
      isOnSale: true,
      isPiece: false,
    ),
    ProductModel(
      id: 'Kangkong',
      title: 'Kangkong',
      imageUrl: 'https://i.ibb.co/HDSrR2Y/Kangkong.png',
      productCategoryName: 'Herbs',
      price: 0.99,
      salePrice: 0.5,
      isOnSale: true,
      isPiece: false,
    ),
    ProductModel(
      id: 'Leek',
      title: 'Leek',
      imageUrl: 'https://i.ibb.co/Pwhqkh6/Leek.png',
      productCategoryName: 'Herbs',
      price: 0.99,
      salePrice: 0.5,
      isOnSale: false,
      isPiece: true,
    ),
    ProductModel(
      id: 'Carottes',
      title: 'Carottes',
      imageUrl: 'https://i.ibb.co/TRbNL3c/Carottes.png',
      productCategoryName: 'Vegetables',
      price: 0.99,
      salePrice: 0.5,
      isOnSale: false,
      isPiece: true,
    ),
    ProductModel(
      id: 'Cauliflower',
      title: 'Cauliflower',
      imageUrl: 'https://i.ibb.co/xGWf2rH/Cauliflower.png',
      productCategoryName: 'Vegetables',
      price: 0.99,
      salePrice: 0.39,
      isOnSale: false,
      isPiece: true,
    ),
    ProductModel(
      id: 'Corn-cobs',
      title: 'Corn-cobs',
      imageUrl: 'https://i.ibb.co/8PhwVYZ/corn-cobs.png',
      productCategoryName: 'Grains',
      price: 0.99,
      salePrice: 0.35,
      isOnSale: true,
      isPiece: true,
    ),
    ProductModel(
      id: 'Peas',
      title: 'Peas',
      imageUrl: 'https://i.ibb.co/7GHM7Dp/peas.png',
      productCategoryName: 'Grains',
      price: 0.29,
      salePrice: 0.19,
      isOnSale: false,
      isPiece: false,
    ),
    ProductModel(
      id: 'Almond',
      title: 'Almond',
      imageUrl: 'https://i.ibb.co/c8QtSr2/almand.png',
      productCategoryName: 'Nuts',
      price: 0.29,
      salePrice: 0.19,
      isOnSale: false,
      isPiece: false,
    ),
    ProductModel(
      id: 'Chinese-cabbage-wombok',
      title: 'Chinese-cabbage-wombok',
      imageUrl: 'https://i.ibb.co/7yzjHVy/Chinese-cabbage-wombok.png',
      productCategoryName: 'Spices',
      price: 0.99,
      salePrice: 0.15,
      isOnSale: true,
      isPiece: true,
    ),
  ];
}
