import 'package:desayur/inner_screens/category_screen.dart';
import 'package:desayur/inner_screens/feeds_screen.dart';
import 'package:desayur/inner_screens/on_sale_screen.dart';
import 'package:desayur/inner_screens/product_details.dart';

import 'package:desayur/provider/dark_theme_provider.dart';
import 'package:desayur/providers/cart_provider.dart';
import 'package:desayur/providers/products_provider.dart';
import 'package:desayur/providers/wishlist_provider.dart';

import 'package:desayur/screens/auth/forget_pass.dart';
import 'package:desayur/screens/auth/login.dart';
import 'package:desayur/screens/auth/register.dart';
import 'package:desayur/screens/bottom_bar.dart';
import 'package:desayur/screens/orders/orders_screen.dart';
import 'package:desayur/screens/viewed_recently/viewed_recently.dart';
import 'package:desayur/screens/wishlist/wishlist_screen.dart';

import 'package:desayur/themes/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentApptheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentApptheme();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Desayur',
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            home: const BottomBarScreen(),
            // home: const LoginScreen(),
            routes: {
              //! Auth route
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              RegisterScreen.routeName: (ctx) => const RegisterScreen(),
              ForgetPasswordScreen.routeName: (ctx) =>
                  const ForgetPasswordScreen(),
              //! Content route
              OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
              FeedsScreen.routeName: (ctx) => const FeedsScreen(),
              ProductDetails.routeName: (ctx) => const ProductDetails(),
              WishlistScreen.routeName: (ctx) => const WishlistScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              ViewedRecentlyScreen.routeName: (ctx) =>
                  const ViewedRecentlyScreen(),
              CategoryScreen.routeName: (ctx) => const CategoryScreen(),
            },
          );
        },
      ),
    );
  }
}
