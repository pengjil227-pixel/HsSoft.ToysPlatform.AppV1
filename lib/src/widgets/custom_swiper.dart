import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CustomSwiper extends Swiper {
  CustomSwiper({
    super.key,
    required super.itemCount,
    required super.itemBuilder,
    super.autoplay = true,
    super.duration = 300,
    super.autoplayDelay = 4000,
    super.allowImplicitScrolling = true,
    SwiperPagination? pagination,
    bool defaultPagination = true,
    super.loop,
  }) : super(
          pagination: !defaultPagination
              ? pagination
              : SwiperPagination(
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  builder: SwiperCustomPagination(
                    builder: (context, config) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints.expand(height: 50.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(50),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${config.activeIndex + 1}/${config.itemCount}',
                              style: const TextStyle(fontSize: 13.0, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
}
