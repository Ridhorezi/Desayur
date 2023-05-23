import 'package:desayur/inner_screens/product_details.dart';
import 'package:desayur/models/wishlist_model.dart';
import 'package:desayur/providers/products_provider.dart';
import 'package:desayur/providers/wishlist_provider.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/heart_btn.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);

    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final wishlistModel = Provider.of<WishlistModel>(context);

    final getCurrentProduct =
        productProvider.findProductById(wishlistModel.productId);

    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;

    final Utils utils = Utils(context);
    // ignore: unused_local_variable
    final Color color = Utils(context).color;
    // ignore: unused_local_variable
    Size size = utils.getScreenSize;

    // ignore: no_leading_underscores_for_local_identifiers
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // width: size.width * 0.2,
                  height: size.width * 0.25,
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              IconlyLight.bag2,
                              color: color,
                            ),
                          ),
                          HeartBtn(
                            productId: getCurrentProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                        ],
                      ),
                    ),
                    TextWidget(
                      text: getCurrentProduct.title,
                      color: color,
                      textsize: 20.0,
                      maxLines: 1,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textsize: 18,
                      maxLines: 1,
                      isTitle: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
