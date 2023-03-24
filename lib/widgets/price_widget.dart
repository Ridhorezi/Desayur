import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return FittedBox(
      child: Row(
        children: [
          TextWidget(
            text: '1.59\$',
            color: Colors.green,
            textsize: 22,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '2.59\$',
            style: TextStyle(
              fontSize: 15,
              color: color,
              decoration: TextDecoration.lineThrough,
            ),
          )
        ],
      ),
    );
  }
}
