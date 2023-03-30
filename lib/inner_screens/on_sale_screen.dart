import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/back_widget.dart';
import 'package:desayur/widgets/on_sale_widget.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/onSaleScreen";
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isEmpty = false;

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
      body: isEmpty
          // ignore: dead_code
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Image.asset(
                        'assets/images/box.png',
                      ),
                    ),
                    Text(
                      'No products on sale yet!,\nStay tuned',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: color,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            )
          // ignore: dead_code
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.45),
              children: List.generate(
                16,
                (index) {
                  return const OnSaleWidget();
                },
              ),
            ),
    );
  }
}
