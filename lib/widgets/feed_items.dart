import 'package:desayur/consts/firebase_consts.dart';
import 'package:desayur/inner_screens/product_details.dart';
import 'package:desayur/models/products_model.dart';
import 'package:desayur/providers/cart_provider.dart';
import 'package:desayur/providers/wishlist_provider.dart';
import 'package:desayur/services/global_methods.dart';
// import 'package:desayur/services/global_methods.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/heart_btn.dart';
import 'package:desayur/widgets/price_widget.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    super.key,
  });

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  late final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

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
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                height: size.width * 0.21,
                width: size.width * 0.2,
                boxFit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextWidget(
                        text: productModel.title,
                        color: color,
                        maxLines: 1,
                        textsize: 18,
                        isTitle: true,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: HeartBtn(
                        productId: productModel.id,
                        isInWishlist: _isInWishlist,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: PriceWidget(
                        salePrice: productModel.salePrice,
                        price: productModel.price,
                        textPrice: _quantityTextController.text,
                        isOnSale: productModel.isOnSale,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: FittedBox(
                              child: TextWidget(
                                text: productModel.isPiece ? 'Piece' : 'Kg',
                                color: color,
                                textsize: 20,
                                isTitle: true,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              controller: _quantityTextController,
                              key: const ValueKey('10'),
                              style: TextStyle(
                                color: color,
                                fontSize: 18,
                              ),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              enabled: true,
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _quantityTextController.text = '1';
                                    int.parse(_quantityTextController.text)
                                        .toString();
                                  } else {
                                    return;
                                  }
                                });
                              },
                              onSaved: (value) {},
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isInCart
                      ? null
                      : () {
                          // if(_isInCart) {
                          //     return;
                          // }
                          final User? user = authInstance.currentUser;
                          if (user == null) {
                            GlobalMethods.errorDialog(
                                subtitle: 'No user found, please login first',
                                context: context);
                            return;
                          }
                          cartProvider.addProductsToCart(
                            productId: productModel.id,
                            quantity: int.parse(_quantityTextController.text),
                          );
                        },
                  // ignore: sort_child_properties_last
                  child: TextWidget(
                    text: _isInCart ? 'In cart' : 'Add to Cart',
                    color: color,
                    maxLines: 1,
                    textsize: 20,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).cardColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
