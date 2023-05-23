import 'package:desayur/providers/orders_provider.dart';
import 'package:desayur/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:desayur/widgets/back_widget.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'orders_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    // ignore: no_leading_underscores_for_local_identifiers
    final ordersProvider = Provider.of<OrdersProvider>(context);

    final ordersList = ordersProvider.getOrders;

    return FutureBuilder(
      future: ordersProvider.fetchOrders(),
      builder: (context, snapshot) {
        return ordersList.isEmpty
            ? const EmptyScreen(
                imagePath: 'assets/images/cart.png',
                title: 'You didnt place any order yet',
                subtitle: 'Order something and make me happy :)',
                buttonText: 'Shope now')
            : Scaffold(
                appBar: AppBar(
                  leading: const BackWidget(),
                  elevation: 0,
                  centerTitle: false,
                  title: TextWidget(
                    text: 'Your orders (${ordersList.length})',
                    color: color,
                    textsize: 24,
                    isTitle: true,
                  ),
                  backgroundColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.9),
                ),
                body: ListView.separated(
                  itemCount: ordersList.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 6),
                      child: ChangeNotifierProvider.value(
                        value: ordersList[index],
                        child: const OrderWidget(),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: color,
                      thickness: 1,
                    );
                  },
                ),
              );
      },
    );
  }
}
