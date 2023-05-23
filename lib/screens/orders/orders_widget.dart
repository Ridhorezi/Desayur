import 'package:desayur/inner_screens/product_details.dart';
import 'package:desayur/models/orders_model.dart';
import 'package:desayur/providers/products_provider.dart';
import 'package:desayur/services/global_methods.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);

    final productProvider = Provider.of<ProductsProvider>(context);

    final getCurrentProduct =
        productProvider.findProductById(ordersModel.productId);

    final Color color = Utils(context).color;

    Size size = Utils(context).getScreenSize;

    return ListTile(
      subtitle:
          Text('Paid: \$${double.parse(ordersModel.price).toStringAsFixed(2)}'),
      onTap: () {
        GlobalMethods.navigateTo(
            ctx: context, routeName: ProductDetails.routeName);
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: getCurrentProduct.imageUrl,
        boxFit: BoxFit.fill,
      ),
      title: TextWidget(
        text: '${getCurrentProduct.title}}  x${ordersModel.quantity}',
        color: color,
        textsize: 18,
      ),
      trailing: TextWidget(
        text: orderDateToShow,
        color: color,
        textsize: 18,
      ),
    );
  }
}
