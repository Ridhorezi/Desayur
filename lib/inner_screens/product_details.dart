import 'package:desayur/consts/firebase_consts.dart';
import 'package:desayur/providers/cart_provider.dart';
import 'package:desayur/providers/products_provider.dart';
import 'package:desayur/providers/viewed_provider.dart';
import 'package:desayur/providers/wishlist_provider.dart';
import 'package:desayur/services/global_methods.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:desayur/widgets/heart_btn.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final productProvider = Provider.of<ProductsProvider>(context);

    final cartProvider = Provider.of<CartProvider>(context);

    final viewedProvider = Provider.of<ViewedProvider>(context);

    final getCurrentProduct = productProvider.findProductById(productId);

    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final Color color = Utils(context).color;

    Size size = Utils(context).getScreenSize;

    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;

    double totalPrice = usedPrice * int.parse(_quantityTextController.text);

    // ignore: no_leading_underscores_for_local_identifiers
    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);

    // ignore: no_leading_underscores_for_local_identifiers
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);

    return WillPopScope(
      onWillPop: () async {
        viewedProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () =>
                  Navigator.canPop(context) ? Navigator.pop(context) : null,
              child: Icon(
                IconlyLight.arrowLeft2,
                color: color,
                size: 24,
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        body: Column(children: [
          Flexible(
            flex: 2,
            child: FancyShimmerImage(
              imageUrl: getCurrentProduct.imageUrl,
              boxFit: BoxFit.scaleDown,
              width: size.width,
              // height: screenHeight * .4,
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: getCurrentProduct.title,
                            color: color,
                            textsize: 25,
                            isTitle: true,
                          ),
                        ),
                        HeartBtn(
                          productId: getCurrentProduct.id,
                          isInWishlist: _isInWishlist,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: '\$${usedPrice.toStringAsFixed(2)}/',
                          color: Colors.green,
                          textsize: 22,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: getCurrentProduct.isPiece ? 'Piece' : 'Kg',
                          color: color,
                          textsize: 12,
                          isTitle: false,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: getCurrentProduct.isOnSale ? true : false,
                          child: Text(
                            '\$${getCurrentProduct.price.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 15,
                                color: color,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(63, 200, 101, 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextWidget(
                            text: 'Free delivery',
                            color: Colors.white,
                            textsize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      quantityControl(
                        fct: () {
                          if (_quantityTextController.text == '1') {
                            return;
                          } else {
                            setState(() {
                              _quantityTextController.text =
                                  (int.parse(_quantityTextController.text) - 1)
                                      .toString();
                            });
                          }
                        },
                        icon: CupertinoIcons.minus,
                        color: Colors.red,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _quantityTextController,
                          key: const ValueKey('quantity'),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.green,
                          enabled: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                _quantityTextController.text = '1';
                              } else {}
                            });
                          },
                        ),
                      ),
                      quantityControl(
                        fct: () {
                          setState(() {
                            _quantityTextController.text =
                                (int.parse(_quantityTextController.text) + 1)
                                    .toString();
                          });
                        },
                        icon: CupertinoIcons.add,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'Total',
                                color: Colors.red.shade300,
                                textsize: 20,
                                isTitle: true,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    TextWidget(
                                      text:
                                          '\$${totalPrice.toStringAsFixed(2)}/',
                                      color: color,
                                      textsize: 20,
                                      isTitle: true,
                                    ),
                                    TextWidget(
                                      text: '${_quantityTextController.text}Kg',
                                      color: color,
                                      textsize: 16,
                                      isTitle: false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Material(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
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
                                        productId: getCurrentProduct.id,
                                        quantity: int.parse(
                                            _quantityTextController.text),
                                        context: context,
                                      );
                                      await cartProvider.fetchCart();
                                      // cartProvider.addProductsToCart(
                                      //   productId: getCurrentProduct.id,
                                      //   quantity: int.parse(
                                      //       _quantityTextController.text),
                                      // );
                                    },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextWidget(
                                  text: _isInCart ? 'In cart' : 'Add to cart',
                                  color: Colors.white,
                                  textsize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget quantityControl(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            fct();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
