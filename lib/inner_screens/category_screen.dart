import 'package:desayur/models/products_model.dart';
import 'package:desayur/providers/products_providers.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/back_widget.dart';
import 'package:desayur/widgets/empty_products_widget.dart';
import 'package:desayur/widgets/feed_items.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/CategoryScreenState";
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // ignore: unnecessary_nullable_for_final_variable_declarations
  final TextEditingController? _searchTextController = TextEditingController();

  final FocusNode _searchTextFocusNode = FocusNode();

  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProviders = Provider.of<ProductsProvider>(context);

    final catName = ModalRoute.of(context)!.settings.arguments as String;

    List<ProductModel> productByCategory =
        productsProviders.findProductByCategory(catName);

    final Utils utils = Utils(context);
    // ignore: unused_local_variable
    final themeState = utils.getTheme;
    // ignore: unused_local_variable
    final Color color = Utils(context).color;
    // ignore: unused_local_variable
    Size size = utils.getScreenSize;

    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: TextWidget(
          text: 'All Products',
          color: color,
          textsize: 20.0,
          isTitle: true,
        ),
      ),
      body: productByCategory.isEmpty
          ? const EmptyProductWidget(
              text: 'No products belong to this category',
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: TextField(
                        focusNode: _searchTextFocusNode,
                        controller: _searchTextController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent, width: 1),
                          ),
                          hintText: "What's in your mind",
                          prefixIcon: const Icon(Icons.search),
                          suffix: IconButton(
                            onPressed: () {
                              _searchTextController!.clear();
                              _searchTextFocusNode.unfocus();
                            },
                            icon: Icon(
                              Icons.close,
                              color: _searchTextFocusNode.hasFocus
                                  ? Colors.red
                                  : color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    padding: EdgeInsets.zero,
                    // crossAxisSpacing: 10,
                    childAspectRatio: size.width / (size.height * 0.59),
                    children: List.generate(
                      productByCategory.length,
                      (index) {
                        return ChangeNotifierProvider.value(
                          value: productByCategory[index],
                          child: const FeedsWidget(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
