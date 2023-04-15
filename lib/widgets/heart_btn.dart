import 'package:desayur/providers/wishlist_provider.dart';
import 'package:desayur/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class HeartBtn extends StatelessWidget {
  final String productId;

  final bool? isInWishlist;

  const HeartBtn(
      {super.key, required this.productId, this.isInWishlist = false});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final Color color = Utils(context).color;

    return GestureDetector(
      onTap: () {
        wishlistProvider.addRemoveProductToWishlist(productId: productId);
      },
      child: Icon(
        isInWishlist != null && isInWishlist == true
            ? IconlyBold.heart
            : IconlyLight.heart,
        size: 22,
        color:
            isInWishlist != null && isInWishlist == true ? Colors.red : color,
      ),
    );
  }
}
