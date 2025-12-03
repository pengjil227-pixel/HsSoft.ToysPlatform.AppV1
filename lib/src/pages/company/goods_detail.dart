import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/core/constants/layout_constants.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_swiper.dart';

class GoodsDetail extends StatefulWidget {
  const GoodsDetail({super.key});

  @override
  State<GoodsDetail> createState() => _GoodsDetailState();
}

class _GoodsDetailState extends State<GoodsDetail> {
  final List<String> _actions = ['切换英文', '复制信息', '错误反馈', '加入对比'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: CustomSwiper(
                    autoplay: false,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        'https://picsum.photos/300/160?i=$index',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(LayoutConstants.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '商品名称商品名称',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '¥50.88',
                        style: TextStyle(fontSize: 24, color: Color(0xFFF30213)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          
                          children: _actions.map((item) {
                            return Align(
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              shape: Border(bottom: BorderSide.none),
              leading: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Align(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(80),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
