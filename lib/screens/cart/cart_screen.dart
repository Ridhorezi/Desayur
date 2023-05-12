import 'package:desayur/providers/cart_provider.dart';
import 'package:desayur/providers/products_provider.dart';
import 'package:desayur/screens/cart/cart_widget.dart';
import 'package:desayur/widgets/empty_screen.dart';
import 'package:desayur/services/global_methods.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();

    final Utils utils = Utils(context);
    // ignore: unused_local_variable
    final Color color = Utils(context).color;
    // ignore: unused_local_variable
    Size size = utils.getScreenSize;

    return cartItemsList.isEmpty
        // ignore: dead_code
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: 'Shope now',
            imagePath: 'assets/images/cart.png',
          )
        // ignore: dead_code
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Cart (${cartItemsList.length})',
                color: color,
                textsize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                      title: 'Empty your cart?',
                      subtitle: 'Are you sure?',
                      fct: () async {
                        await cartProvider.clearLiveCart();
                        cartProvider.clearLocalCart();
                      },
                      context: context,
                    );
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _checkout(ctx: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemsList.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                        value: cartItemsList[index],
                        child: CartWidget(
                          q: cartItemsList[index].quantity,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Utils utils = Utils(ctx);
    // ignore: unused_local_variable
    final Color color = Utils(ctx).color;
    // ignore: unused_local_variable

    // ignore: unused_local_variable
    double total = 0.0;
    // ignore: unused_local_variable
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    cartProvider.getCartItems.forEach(
      (key, value) {
        final getCurrentProduct =
            productProvider.findProductById(value.productId);
        total += (getCurrentProduct.isOnSale
                ? getCurrentProduct.salePrice
                : getCurrentProduct.price) *
            value.quantity;
      },
    );

    Size size = utils.getScreenSize;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                    text: 'Order Now',
                    color: Colors.white,
                    textsize: 20,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(
                text: 'Total \$${total.toStringAsFixed(2)}',
                color: color,
                textsize: 18,
                isTitle: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
