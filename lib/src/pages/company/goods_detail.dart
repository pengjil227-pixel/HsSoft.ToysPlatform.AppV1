import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/core/constants/layout_constants.dart';
import 'package:flutter_wanhaoniu/src/widgets/primart_button.dart';
import 'package:flutter_wanhaoniu/src/widgets/user_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/providers/cart_provider.dart';
import '../../core/network/modules/company.dart';
import '../../core/network/modules/product_detail.dart';
import '../../shared/models/product.dart';
import '../../shared/models/product_detail.dart';
import '../../utils/toast_utils.dart';
import '../../widgets/custom_smart_refresher.dart';
import '../../widgets/custom_swiper.dart';
import '../../widgets/custom_title.dart';
import '../../widgets/goods_item.dart';
import '../../widgets/products_view.dart';

class GoodsDetail extends StatefulWidget {
  const GoodsDetail({
    super.key,
    required this.parameters,
  });

  final ProductsParameters parameters;

  @override
  State<GoodsDetail> createState() => _GoodsDetailState();
}

class _GoodsDetailState extends State<GoodsDetail> {
  final ValueNotifier<double> _alpha = ValueNotifier<double>(0.0);

  // Future<void> _init() async {
  //   _currentPage = widget.parameters.index;
  //   _pageController = PageController(initialPage: widget.parameters.index);
  //   _pageController.addListener(_pageControllerListener);
  //   await _getDetailInfo();
  // }

  // Future<void> _getDetailInfo() async {
  //   _productDetail.value = null;
  //   final currentInfo = _products[_currentPage];
  //   final infoDetail = await CompanyService.getProductDetail({
  //     'id': currentInfo.id,
  //     'productNumber': currentInfo.productNumber,
  //   });
  //   if (infoDetail.success) {
  //     _productDetail.value = infoDetail.data;
  //   }
  // }

  // void _pageControllerListener() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     if (!_pageController.position.isScrollingNotifier.value) {
  //       final index = _pageController.page!.round();
  //       if (_currentPage != index) {
  //         _currentPage = index;
  //         _alpha.value = 0.0;
  //         await _getDetailInfo();
  //         if (!mounted) return;
  //         // final goodsDetailInfoModal = context.read<GoodsDetailInfo>();
  //         // if (_currentPage > goodsDetailInfoModal.products.length - 3) {
  //         //   goodsDetailInfoModal.loadMore.call();
  //         // }
  //       }
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    _alpha.dispose();
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
      body: _GoodsInfoWidget(
        alpha: _alpha,
        parameters: widget.parameters,
        onScroll: (double value) {
          _alpha.value = value;
        },
      ),
      // body:
      //  Consumer<GoodsDetailInfo>(
      //   builder: (context, GoodsDetailInfo value, __) {
      //     final products = value.products;
      //     return ValueListenableBuilder(
      //       valueListenable: _productDetail,
      //       builder: (context, detail, __) {
      //         return PageView.builder(
      //           itemCount: products.length,
      //           controller: _pageController,
      //           itemBuilder: (context, index) {
      //             return _DetailItem(
      //               key: ValueKey(products[index].productNumber),
      //               productDetail: _currentPage == index ? detail : null,
      //               productInfo: products[index],
      //               onScroll: (double value) {
      //                 _alpha.value = value;
      //               },
      //             );
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}

class _GoodsInfoWidget extends StatefulWidget {
  const _GoodsInfoWidget({
    required this.alpha,
    required this.parameters,
    required this.onScroll,
  });
  final ValueNotifier<double> alpha;

  final ProductsParameters parameters;

  final Function(double value) onScroll;

  @override
  State<_GoodsInfoWidget> createState() => __GoodsInfoWidgetState();
}

class __GoodsInfoWidgetState extends State<_GoodsInfoWidget> {
  late final PageController _pageController;
  late final List<ProductItem> _products;
  late int _current;

  final ValueNotifier<ProductDetail?> _productDetail = ValueNotifier<ProductDetail?>(null);

  @override
  void initState() {
    super.initState();
    _current = widget.parameters.index;
    _pageController = PageController(initialPage: _current);
    _pageController.addListener(_controllerListener);
    _products = widget.parameters.products;
    _initDetail();
  }

  Future<void> _initDetail() async {
    final currentInfo = _products[_current];
    final infoDetail = await CompanyService.getProductDetail({
      'id': currentInfo.id,
      'productNumber': currentInfo.productNumber,
    });
    if (infoDetail.success) {
      _productDetail.value = infoDetail.data;
    }
  }

  bool _canload = true;

  void _controllerListener() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_pageController.position.isScrollingNotifier.value) {
        final index = _pageController.page!.round();
        if (_current != index) {
          _current = index;
          widget.onScroll(0.0);
          _initDetail();
        }
      }
    });

    if (!_canload) return;
    final double pageCurrent = _pageController.page!;
    if (pageCurrent > _products.length - 3) {
      _canload = false;
      final total = _products.length;
      try {
        await widget.parameters.loadmore();
        final newTotal = _products.length;
        if (total != newTotal) {
          setState(() {
            /// update
          });
        }
        _canload = true;
      } catch (_) {
        _canload = true;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.removeListener(_controllerListener);
    _pageController.dispose();
    _productDetail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _productDetail,
      builder: (context, ProductDetail? value, _) {
        return PageView.builder(
          itemCount: _products.length,
          controller: _pageController,
          itemBuilder: (context, index) {
            return _DetailItem(
              key: ValueKey(_products[index].productNumber),
              alpha: widget.alpha,
              productInfo: _products[index],
              productDetail: _current == index ? value : null,
              onScroll: widget.onScroll,
            );
          },
        );
      },
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
    required this.alpha,
    required this.onScroll,
    this.productDetail,
    required this.productInfo,
  });
  final ValueNotifier<double> alpha;

  final Function(double value) onScroll;

  final ProductDetail? productDetail;

  final ProductItem productInfo;

  @override
  State<_DetailItem> createState() => __DetailItemState();
}

class __DetailItemState extends State<_DetailItem> {
  final RefreshController _refreshController = RefreshController();
  ProductDetail? get _product => widget.productDetail;
  ProductItem get _info => widget.productInfo;

  final List<String> _actions = ['切换英文', '复制信息', '错误反馈', '加入对比'];

  final ScrollController _controller = ScrollController();

  final double _gap = 250;

  final double _bottomHeight = 50;

  int? _alpha = 0;

  late final SmartRefresherParameter _smartRefresherParameter;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_controllerListener);
    _smartRefresherParameter = SmartRefresherParameter(
      loadList: (int page) => ProductDetailService.queryDetailRecommendProductPage(page),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _controller.removeListener(_controllerListener);
    _controller.dispose();
  }

  void _controllerListener() {
    if (_alpha != null) _alpha = null;
    final offset = _controller.offset;

    final double alpha = ((offset - 50) / _gap).clamp(0, 1);

    if (alpha == widget.alpha.value) return;
    widget.onScroll(alpha);
  }

  void _onLoading() async {
    final bool? hasMore = await _smartRefresherParameter.loadmore?.call();
    if (hasMore == false) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
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
        Padding(
          padding: EdgeInsets.only(bottom: LayoutConstants.pagePadding * 2 + View.of(context).padding.bottom / View.of(context).devicePixelRatio + _bottomHeight),
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            header: SmartRefresherHeader(),
            footer: SmartRefresherFooter(),
            controller: _refreshController,
            onLoading: _onLoading,
            child: CustomScrollView(
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
                                CustomTitle(title: '产品信息'),
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
                      child: UserTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 60,
                            height: 60,
                          ),
                        ),
                        title: Text('耀昇玩具展厅'),
                        subtitle: Row(
                          children: [
                            Text('关注: '),
                            Text(
                              '99',
                              style: TextStyle(color: Color(0xFF111111)),
                            )
                          ],
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PrimartButton(
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.zero,
                              sizeStyle: CupertinoButtonSize.small,
                              onPressed: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Color(0xFFF30213)),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Iconfont.guanzhuchangshang, color: Color(0xFFF30213)),
                                    SizedBox(width: 4),
                                    Text(
                                      '联系',
                                      style: TextStyle(color: Color(0xFFF30213), height: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            PrimartButton(
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.zero,
                              sizeStyle: CupertinoButtonSize.small,
                              onPressed: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Color(0xFFFF9700)),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Iconfont.lianxiwomen, color: Color(0xFFFF9700)),
                                    SizedBox(width: 4),
                                    Text(
                                      '联系',
                                      style: TextStyle(color: Color(0xFFFF9700), height: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (hasDetail)
                  SliverPadding(
                    padding: EdgeInsets.all(LayoutConstants.pagePadding),
                    sliver: ProductsView(
                      parameter: _smartRefresherParameter,
                    ),
                  ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder<double>(
          valueListenable: widget.alpha,
          builder: (_, double value, __) {
            return Container(
              color: Colors.white.withAlpha((_alpha ?? value * 255).toInt().clamp(0, 255)),
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
                          onPressed: () async {
                            await context.read<CartProvider>().addToCart(_info);
                            if (!mounted) return;
                            ToastUtils.showSuccess(context);
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
