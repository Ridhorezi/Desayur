import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desayur/consts/firebase_consts.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(children: [
            Image.asset(
              'assets/images/warning-sign.png',
              height: 20,
              width: 20,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 8),
            Text(title)
          ]),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: TextWidget(
                text: 'Cancel',
                color: Colors.cyan,
                textsize: 18,
              ),
            ),
            TextButton(
              onPressed: () {
                fct();
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: TextWidget(
                text: 'OK',
                color: Colors.red,
                textsize: 18,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(children: [
            Image.asset(
              'assets/images/warning-sign.png',
              height: 20,
              width: 20,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 8),
            const Text('An Error occured')
          ]),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: TextWidget(
                text: 'Ok',
                color: Colors.cyan,
                textsize: 18,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> addToCart({
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    // ignore: no_leading_underscores_for_local_identifiers
    final _uid = user!.uid;
    final cartId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Item has been added to your cart",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey.shade600,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }
}
