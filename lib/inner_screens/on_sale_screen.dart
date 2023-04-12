import 'package:desayur/models/products_model.dart';
import 'package:desayur/providers/products_providers.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/back_widget.dart';
import 'package:desayur/widgets/empty_products_widget.dart';
import 'package:desayur/widgets/on_sale_widget.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/onSaleScreen";
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProviders = Provider.of<ProductsProvider>(context);

    List<ProductModel> productOnSale = productsProviders.getOnSaleProducts;

    final Utils utils = Utils(context);
    // ignore: unused_local_variable
    final themeState = utils.getTheme;
    // ignore: unused_local_variable
    final Color color = Utils(context).color;

    Size size = utils.getScreenSize;

    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Product on Sale',
          color: color,
          textsize: 24.0,
          isTitle: true,
        ),
      ),
      body: productOnSale.isEmpty
          ? const EmptyProductWidget(
              text: 'No products on sale yet!,\nStay tuned',
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.45),
              children: List.generate(
                productOnSale.length,
                (index) {
                  return ChangeNotifierProvider.value(
                    value: productOnSale[index],
                    child: const OnSaleWidget(),
                  );
                },
              ),
            ),
    );
  }
}
