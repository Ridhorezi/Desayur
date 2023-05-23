import 'package:desayur/consts/firebase_consts.dart';
import 'package:desayur/inner_screens/product_details.dart';
import 'package:desayur/models/products_model.dart';
import 'package:desayur/providers/cart_provider.dart';
import 'package:desayur/providers/wishlist_provider.dart';
import 'package:desayur/services/global_methods.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/heart_btn.dart';
import 'package:desayur/widgets/price_widget.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({super.key});

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);

    final cartProvider = Provider.of<CartProvider>(context);

    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final Color color = Utils(context).color;
    // ignore: unused_local_variable
    final theme = Utils(context).getTheme;

    Size size = Utils(context).getScreenSize;

    // ignore: no_leading_underscores_for_local_identifiers
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);

    // ignore: no_leading_underscores_for_local_identifiers
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FancyShimmerImage(
                      imageUrl: productModel.imageUrl,
                      height: size.width * 0.22,
                      width: size.width * 0.22,
                      boxFit: BoxFit.fill,
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: productModel.isPiece ? '1Piece' : '1KG',
                          color: color,
                          textsize: 22,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _isInCart
                                  ? null
                                  : () async {
                                      final User? user =
                                          authInstance.currentUser;
                                      if (user == null) {
                                        GlobalMethods.errorDialog(
                                            subtitle:
                                                'No user found, please login first',
                                            context: context);
                                        return;
                                      }
                                      await GlobalMethods.addToCart(
                                        productId: productModel.id,
                                        quantity: 1,
                                        context: context,
                                      );
                                      await cartProvider.fetchCart();
                                    },
                              child: Icon(
                                _isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                                size: 22,
                                color: _isInCart ? Colors.green : color,
                              ),
                            ),
                            HeartBtn(
                              productId: productModel.id,
                              isInWishlist: _isInWishlist,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                PriceWidget(
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  textPrice: '1',
                  isOnSale: true,
                ),
                const SizedBox(height: 5),
                TextWidget(
                  text: productModel.title,
                  color: color,
                  textsize: 16,
                  isTitle: true,
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
