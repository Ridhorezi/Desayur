import 'package:desayur/screens/wishlist/wishlist_widget.dart';
import 'package:desayur/services/global_methods.dart';
import 'package:desayur/widgets/empty_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/back_widget.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    // ignore: unused_local_variable
    final Color color = Utils(context).color;
    // ignore: unused_local_variable
    Size size = utils.getScreenSize;
    // ignore: no_leading_underscores_for_local_identifiers
    bool _isEmpty = true;

    return _isEmpty
        ? const EmptyScreen(
            imagePath: 'assets/images/wishlist.png',
            title: 'Your wishlist is empty!',
            subtitle: 'Explore more and shortlist some items',
            buttonText: 'Add a wish',
          )
        // ignore: dead_code
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const BackWidget(),
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Wishlist (2)',
                color: color,
                textsize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                        title: 'Empty your wishlist?',
                        subtitle: 'Are you sure?',
                        fct: () {},
                        context: context);
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                ),
              ],
            ),
            body: MasonryGridView.count(
              crossAxisCount: 2,
              // mainAxisSpacing: 16,
              // crossAxisSpacing: 20,
              itemBuilder: (context, index) {
                return const WishlistWidget();
              },
            ),
          );
  }
}