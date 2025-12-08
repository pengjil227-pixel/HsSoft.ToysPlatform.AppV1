import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/core/constants/layout_constants.dart';
import 'package:flutter_wanhaoniu/src/core/providers/goods_detail_info.dart';
import 'package:flutter_wanhaoniu/src/core/providers/home_infos.dart';
import 'package:flutter_wanhaoniu/src/widgets/primart_button.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';

import '../../core/network/modules/company.dart';
import '../../core/network/modules/product_detail.dart';
import '../../shared/models/paginated_response.dart';
import '../../shared/models/product.dart';
import '../../shared/models/product_detail.dart';
import '../../widgets/custom_swiper.dart';
import '../../widgets/goods_item.dart';

class GoodsDetail extends StatefulWidget {
  const GoodsDetail({
    super.key,
    required this.currentPage,
  });

  final int currentPage;

  @override
  State<GoodsDetail> createState() => _GoodsDetailState();
}

class _GoodsDetailState extends State<GoodsDetail> {
  final ValueNotifier<double> _alpha = ValueNotifier<double>(0.0);

  late final PageController _pageController;

  late int _currentPage;

  final ValueNotifier<ProductDetail?> _productDetail = ValueNotifier<ProductDetail?>(null);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _currentPage = widget.currentPage;
    _pageController = PageController(initialPage: widget.currentPage);
    _pageController.addListener(_pageControllerListener);
    await _getDetailInfo();
  }

  Future<void> _getDetailInfo() async {
    _productDetail.value = null;
    final products = context.read<GoodsDetailInfo>().products;
    final currentInfo = products[_currentPage];
    final infoDetail = await CompanyService.getProductDetail({
      'id': currentInfo.id,
      'productNumber': currentInfo.productNumber,
    });
    if (infoDetail.success) {
      _productDetail.value = infoDetail.data;
    }
  }

  void _pageControllerListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_pageController.position.isScrollingNotifier.value) {
        final index = _pageController.page!.round();
        if (_currentPage != index) {
          _currentPage = index;
          _alpha.value = 0.0;
          await _getDetailInfo();
          if (!mounted) return;
          final goodsDetailInfoModal = context.read<GoodsDetailInfo>();
          if (_currentPage > goodsDetailInfoModal.products.length - 3) {
            goodsDetailInfoModal.loadMore.call();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _alpha.dispose();
    _productDetail.dispose();
    _pageController.removeListener(_pageControllerListener);
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(theme.appBarTheme.toolbarHeight ?? 44),
        child: ValueListenableBuilder<double>(
          valueListenable: _alpha,
          builder: (_, double value, __) {
            return _AppBar(alpha: value);
          },
        ),
      ),
      body: Consumer<GoodsDetailInfo>(
        builder: (context, GoodsDetailInfo value, __) {
          final products = value.products;
          return ValueListenableBuilder(
            valueListenable: _productDetail,
            builder: (context, detail, __) {
              return PageView.builder(
                itemCount: products.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  return _DetailItem(
                    key: ValueKey(products[index].productNumber),
                    productDetail: _currentPage == index ? detail : null,
                    productInfo: products[index],
                    onScroll: (double value) {
                      _alpha.value = value;
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// class _AppBar extends StatefulWidget {
//   const _AppBar({
//     required this.alpha,
//   });

//   final double alpha;

//   @override
//   State<_AppBar> createState() => __AppBarState();
// }

// class __AppBarState extends State<_AppBar> {
//   // final double _gap = 250;
//   // double _alpha = 0;

//   // void _updateAlpha(double value) {}

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   widget.scrollController.addListener(_controllerListener);
//   // }

//   // void _controllerListener() {
//   //   final offset = widget.scrollController.offset;

//   //   final double alpha = ((offset - 50) / _gap).clamp(0, 1);

//   //   if (alpha == _alpha) return;
//   //   setState(() {
//   //     _alpha = alpha;
//   //   });
//   // }

//   // @override
//   // void dispose() {
//   //   super.dispose();
//   //   widget.scrollController.removeListener(_controllerListener);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       // notificationPredicate: (notification) {
//       //   _updateAlpha(notification.metrics.pixels);
//       //   return notification.depth == 0;
//       // },
//       backgroundColor: Colors.transparent,
//       // backgroundColor: Colors.white.withAlpha((_alpha * 255).toInt().clamp(0, 255)),
//       shape: Border(bottom: BorderSide.none),
//       leading: GestureDetector(
//         onTap: () {
//           context.pop();
//         },
//         child: Align(
//           child: Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               color: Colors.black.withAlpha(((1 - _alpha) * 130).toInt().clamp(0, 130)),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Icon(
//               Icons.arrow_back_ios_new_outlined,
//               color: Color.lerp(Colors.white, Colors.black, _alpha),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.alpha,
  });

  final double alpha;

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              color: Colors.black.withAlpha(((1 - alpha) * 130).toInt().clamp(0, 130)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color.lerp(Colors.white, Colors.black, alpha),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatefulWidget {
  const _DetailItem({
    super.key,
    required this.onScroll,
    this.productDetail,
    required this.productInfo,
  });

  final Function(double value) onScroll;

  final ProductDetail? productDetail;

  final ProductItem productInfo;

  @override
  State<_DetailItem> createState() => __DetailItemState();
}

class __DetailItemState extends State<_DetailItem> {
  ProductDetail? get _product => widget.productDetail;
  ProductItem get _info => widget.productInfo;

  final List<String> _actions = ['切换英文', '复制信息', '错误反馈', '加入对比'];

  final ScrollController _controller = ScrollController();

  final double _gap = 250;
  final ValueNotifier<double> _alpha = ValueNotifier<double>(0.0);

  final double _bottomHeight = 50;

  final ValueNotifier<PaginatedResponse<ProductItem>?> _recommended = ValueNotifier<PaginatedResponse<ProductItem>?>(null);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_controllerListener);
    _getRecommended();
  }

  @override
  void dispose() {
    super.dispose();
    _alpha.dispose();
    _controller.removeListener(_controllerListener);
    _recommended.dispose();
  }

  Future<void> _getRecommended() async {
    final response = await ProductDetailService.queryDetailRecommendProductPage({});
    _recommended.value = response.data;
  }

  void _controllerListener() {
    final offset = _controller.offset;

    final double alpha = ((offset - 50) / _gap).clamp(0, 1);

    if (alpha == _alpha.value) return;
    _alpha.value = alpha;
    widget.onScroll(alpha);
  }

  Widget _detaiBuilder(
    String leading,
    String title,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 90),
          child: Text(
            leading,
            style: TextStyle(color: Color(0xFF929292)),
          ),
        ),
        Text(title)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool hasDetail = _product != null;

    return Stack(
      children: [
        CustomScrollView(
          controller: _controller,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              key: ValueKey(hasDetail),
              child: SizedBox(
                height: 300,
                child: hasDetail
                    ? CustomSwiper(
                        autoplay: false,
                        itemCount: _product!.imgList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CachedNetworkImage(
                            imageUrl: _product!.imgList[index].filePath,
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : CachedNetworkImage(
                        imageUrl: _info.imgUrl,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _info.maNa,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '¥${_info.faPr}',
                      style: TextStyle(fontSize: 24, color: Color(0xFFF30213)),
                    ),
                    if (hasDetail)
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(_actions.length, (index) {
                            return Expanded(
                              child: Row(
                                children: [
                                  if (index != 0)
                                    SizedBox(
                                      height: 20,
                                      child: VerticalDivider(
                                        width: 0,
                                        thickness: 0.6,
                                      ),
                                    ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 34,
                                      child: Align(
                                        child: Text(_actions[index]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (hasDetail)
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
                  padding: EdgeInsets.all(LayoutConstants.pagePadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 15, color: Color(0xFF111111)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                Text(
                                  '产品信息',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.2),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [0.0, 1.0],
                                        colors: [
                                          Color(0xFFF30213).withAlpha(160),
                                          Colors.white.withAlpha(100),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            PrimartButton(
                              onPressed: () {},
                              child: Icon(
                                Iconfont.fuzhi1,
                                size: 16,
                                color: Color(0xFF929292),
                              ),
                            )
                          ],
                        ),
                        _detaiBuilder('来源展厅', _product!.exhibitionName),
                        _detaiBuilder('包装', _product!.chPa),
                        _detaiBuilder('种类名称', _product!.clNa),
                        _detaiBuilder('外箱规格', '${_product!.inLe}x${_product!.inWi}x${_product!.inHi}(cm)'),
                        _detaiBuilder('装箱量', '${_product!.attestationCount}'),
                        _detaiBuilder('外箱规格', '${_product!.ouLe}x${_product!.ouWi}x${_product!.ouHi}(cm)'),
                        _detaiBuilder('毛重/净重', '${_product!.neWePr}'),
                        _detaiBuilder('体积/材积', '${_product!.prLe}x${_product!.prWi}x${_product!.prHi}(cm)'),
                        _detaiBuilder('更新时间', _product!.createdTime),
                        _detaiBuilder('上架时间', _product!.updatedTime),
                      ],
                    ),
                  ),
                ),
              ),
            if (hasDetail)
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(LayoutConstants.pagePadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SizedBox(
                    height: 86,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 60,
                              height: 60,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('耀昇玩具展厅', style: TextStyle(fontSize: 18)),
                                  Row(
                                    children: [
                                      Text(
                                        '产品:',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PrimartButton(
                                padding: EdgeInsets.zero,
                                borderRadius: BorderRadius.zero,
                                sizeStyle: CupertinoButtonSize.small,
                                onPressed: () {},
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Color(0xFFF30213)),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Iconfont.lianxiwomen, color: Color(0xFFF30213)),
                                      SizedBox(width: 4),
                                      Text(
                                        '关注',
                                        style: TextStyle(color: Color(0xFFF30213)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              PrimartButton(
                                padding: EdgeInsets.zero,
                                borderRadius: BorderRadius.zero,
                                sizeStyle: CupertinoButtonSize.small,
                                onPressed: () {},
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Color(0xFFFF9700)),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Iconfont.lianxiwomen, color: Color(0xFFFF9700)),
                                      SizedBox(width: 4),
                                      Text(
                                        '联系',
                                        style: TextStyle(color: Color(0xFFFF9700)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ValueListenableBuilder(
              valueListenable: _recommended,
              builder: (context, value, _) {
                if (_product == null || value == null) return SliverPadding(padding: EdgeInsets.zero);
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 44,
                    child: Align(
                      child: Text(
                        '产品推荐',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _recommended,
              builder: (context, value, _) {
                if (_product == null || value == null) return SliverPadding(padding: EdgeInsets.zero);
                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding),
                  sliver: ProductsBuilder(
                    item: value,
                    loadMore: () {},
                  ),
                );
              },
            ),
            // SliverList.builder(
            //   itemCount: 10,
            //   itemBuilder: (context, index) {
            //     return Image.network(
            //       width: double.infinity,
            //       'https://picsum.photos/300/160?i=$index',
            //       fit: BoxFit.contain,
            //     );
            //   },
            // ),
            // SliverPadding(
            //   padding: EdgeInsets.fromLTRB(
            //       LayoutConstants.pagePadding, 0, LayoutConstants.pagePadding, LayoutConstants.pagePadding * 3 + View.of(context).padding.bottom / View.of(context).devicePixelRatio + 44),
            //   sliver: SliverGrid.builder(
            //     itemCount: 10,
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       crossAxisSpacing: LayoutConstants.pagePadding,
            //       mainAxisSpacing: LayoutConstants.pagePadding,
            //       childAspectRatio: 0.9,
            //     ),
            //     itemBuilder: (context, index) {
            //       return Container(
            //         height: 50,
            //         color: Colors.greenAccent,
            //         margin: EdgeInsets.all(10),
            //       );
            //     },
            //   ),
            // ),

            SliverPadding(padding: EdgeInsets.only(bottom: LayoutConstants.pagePadding * 2 + View.of(context).padding.bottom / View.of(context).devicePixelRatio + _bottomHeight))
          ],
        ),
        ValueListenableBuilder<double>(
          valueListenable: _alpha,
          builder: (_, double value, __) {
            return Container(
              color: Colors.white.withAlpha((value * 255).toInt().clamp(0, 255)),
              height: View.of(context).padding.top / View.of(context).devicePixelRatio + (theme.appBarTheme.toolbarHeight ?? 44),
            );
          },
        ),
        if (hasDetail)
          Positioned(
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(4, LayoutConstants.pagePadding, 8, LayoutConstants.pagePadding + View.of(context).padding.bottom / View.of(context).devicePixelRatio),
              child: SizedBox(
                height: _bottomHeight,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Iconfont.dianpu1,
                            color: Color(0xFF929292),
                            size: 18,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '店铺',
                            style: TextStyle(fontSize: 12, color: Color(0xFF929292)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Iconfont.shoucang1,
                            color: Color(0xFF929292),
                            size: 18,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '收藏',
                            style: TextStyle(fontSize: 12, color: Color(0xFF929292)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Iconfont.fenxiang1,
                            color: Color(0xFF929292),
                            size: 18,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '店铺',
                            style: TextStyle(fontSize: 12, color: Color(0xFF929292)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: PrimartButton(
                          color: theme.primaryColor,
                          onPressed: () {
                            context.pushNamed(
                              'goodsDetail',
                              pathParameters: {
                                'index': '9',
                              },
                            );
                          },
                          child: Text(
                            '加入购物车',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
