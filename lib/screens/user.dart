import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desayur/consts/firebase_consts.dart';
import 'package:desayur/provider/dark_theme_provider.dart';
import 'package:desayur/screens/auth/forget_pass.dart';
import 'package:desayur/screens/auth/login.dart';
import 'package:desayur/screens/loading_manager.dart';
import 'package:desayur/screens/orders/orders_screen.dart';
import 'package:desayur/screens/viewed_recently/viewed_recently.dart';
import 'package:desayur/screens/wishlist/wishlist_screen.dart';
import 'package:desayur/services/global_methods.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");

  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? address;

  bool _isLoading = true;

  final User? user = authInstance.currentUser;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();

      // ignore: unnecessary_null_comparison
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);

    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Hi,  ',
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          // ignore: prefer_if_null_operators
                          text: _name == null ? 'user' : _name,
                          style: TextStyle(
                            color: color,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // ignore: avoid_print
                              print('My name is pressed');
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: _email == null ? 'Email' : _email!,
                    color: color,
                    textsize: 18,
                    // isTitle: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _listTiles(
                    title: 'Address 2',
                    subtitle: address,
                    icon: IconlyLight.activity,
                    onPressed: () async {
                      await _showAddressDialog();
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: 'Orders',
                    icon: IconlyLight.bag,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: OrdersScreen.routeName);
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: 'Wishlist',
                    icon: IconlyLight.heart,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: WishlistScreen.routeName);
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: 'Viewed',
                    icon: IconlyLight.show,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: ViewedRecentlyScreen.routeName);
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: 'Forgot Password',
                    icon: IconlyLight.unlock,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    color: color,
                  ),
                  SwitchListTile(
                      title: TextWidget(
                        text: themeState.getDarkTheme
                            ? 'Dark Mode'
                            : 'Light Mode',
                        color: color,
                        textsize: 18,
                        // isTitle: true,
                      ),
                      secondary: Icon(themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined),
                      onChanged: (bool value) {
                        setState(() {
                          themeState.setDarkTheme = value;
                        });
                      },
                      value: themeState.getDarkTheme),
                  _listTiles(
                    title: user == null ? 'Login' : 'Logout',
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    onPressed: () {
                      if (user == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                        return;
                      }
                      GlobalMethods.warningDialog(
                          title: 'Sign Out',
                          subtitle: 'Do you wanna sign out ?',
                          fct: () async {
                            await authInstance.signOut();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          context: context);
                    },
                    color: color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            // onChanged: (value) {
            //   print(
            //       '_addressTextController.text ${_addressTextController.text}');
            // },
            controller: _addressTextController,
            maxLines: 5,
            decoration: const InputDecoration(hintText: "Your address"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // ignore: no_leading_underscores_for_local_identifiers
                String _uid = user!.uid;
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(_uid)
                      .update({
                    'shipping-address': _addressTextController.text,
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  setState(() {
                    address = _addressTextController.text;
                  });
                } catch (error) {
                  GlobalMethods.errorDialog(
                      subtitle: error.toString(), context: context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textsize: 22,
        // isTitle: true,
      ),
      subtitle: TextWidget(
        // ignore: prefer_if_null_operators
        text: subtitle == null ? "" : subtitle,
        color: color,
        textsize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
