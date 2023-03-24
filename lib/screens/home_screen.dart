import 'package:card_swiper/card_swiper.dart';
import 'package:desayur/services/utils.dart';
import 'package:desayur/widgets/on_sale_widget.dart';
import 'package:desayur/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _offerImages = [
    'assets/images/offres/Offer1.jpg',
    'assets/images/offres/Offer2.jpg',
    'assets/images/offres/Offer3.jpg',
    'assets/images/offres/Offer4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.33,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  _offerImages[index],
                  fit: BoxFit.fill,
                );
              },
              autoplay: true,
              itemCount: _offerImages.length,
              pagination: const SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                    color: Colors.white, activeColor: Colors.red),
              ),
              // control: const SwiperControl(color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          TextButton(
            onPressed: () {},
            child: TextWidget(
              text: "View all",
              color: Colors.blue,
              maxLines: 1,
              textsize: 20,
            ),
          ),
          Row(
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Row(
                  children: [
                    TextWidget(
                      text: 'On sale'.toUpperCase(),
                      color: Colors.red,
                      textsize: 22,
                      isTitle: true,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      IconlyLight.discount,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: SizedBox(
                  height: size.height * 0.24,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return const OnSaleWidget();
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
