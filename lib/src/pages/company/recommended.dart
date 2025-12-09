import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/constants/layout_constants.dart';
import '../../core/network/modules/company.dart';
import '../../core/providers/home_infos.dart';
import '../../shared/models/company_origin.dart';
import '../../shared/models/exhibition.dart';
import '../../shared/models/paginated_response.dart';
import '../../shared/models/product.dart';
import '../../shared/models/sales_ads_list.dart';
import '../../widgets/custom_smart_refresher.dart';
import '../../widgets/custom_swiper.dart';
import '../../widgets/products_view.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({super.key});

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  final RefreshController _refreshController = RefreshController();

  late final SmartRefresherParameter _smartRefresherParameter;

  @override
  void initState() {
    super.initState();
    _smartRefresherParameter = SmartRefresherParameter(
      loadList: (int page) => CompanyService.getRecomendProduct(page),
    );
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<HomeInfos>().updateHomeInfos(),
      Future.delayed(Duration(milliseconds: 500)),
    ]);
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    final bool? hasMore = await _smartRefresherParameter.loadmore?.call();
    if (hasMore == false) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  Widget _mainItemBuilder({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, 0, 0, LayoutConstants.pagePadding),
      margin: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
            leading: Icon(icon, color: color, size: 16),
            title: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: SmartRefresherHeader(),
      footer: SmartRefresherFooter(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
              child: SizedBox(
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Selector<HomeInfos, List<SalesAdsList>?>(
                    selector: (_, model) => model.salesAdsList,
                    builder: (context, List<SalesAdsList>? value, __) {
                      if (value == null) return SizedBox.shrink();
                      return CustomSwiper(
                        itemCount: value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CachedNetworkImage(
                            imageUrl: value[index].imgUrl,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<HomeInfos, List<Exhibition>?>(
              selector: (_, model) => model.onlineExhibitionList,
              builder: (context, List<Exhibition>? value, __) {
                if (value == null || value.isEmpty) return SizedBox.shrink();
                final itemCount = (value.length / 3).ceil();
                return _mainItemBuilder(
                  icon: Iconfont.zhanting,
                  title: '线上展厅',
                  color: theme.primaryColor,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final gap = LayoutConstants.pagePadding;
                      final itemWidth = (constraints.maxWidth - gap * 3) / 3;

                      return SizedBox(
                        height: itemWidth * 2 / 3,
                        child: CustomSwiper(
                          itemCount: itemCount,
                          autoplay: false,
                          defaultPagination: false,
                          loop: false,
                          itemBuilder: (BuildContext context, int pageIndex) {
                            return Padding(
                              padding: EdgeInsets.only(right: LayoutConstants.pagePadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(3, (itemIndex) {
                                  final dataIndex = pageIndex * 3 + itemIndex;
                                  if (dataIndex >= value.length) {
                                    return SizedBox.shrink();
                                  }
                                  final exhibition = value[dataIndex];

                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      width: itemWidth,
                                      height: double.infinity,
                                      imageUrl: exhibition.bgImg,
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<HomeInfos, PaginatedResponse<ProductItem>?>(
              selector: (_, model) => model.newProduct,
              builder: (context, PaginatedResponse<ProductItem>? value, __) {
                if (value == null) return SizedBox.shrink();
                return _mainItemBuilder(
                  icon: Iconfont.xinpin,
                  title: '新品推荐',
                  color: theme.primaryColor,
                  child: GridView.builder(
                    padding: EdgeInsets.only(right: LayoutConstants.pagePadding),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: math.min(value!.rows.length, 3),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: LayoutConstants.pagePadding,
                      mainAxisSpacing: LayoutConstants.pagePadding,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: value!.rows[index].imgUrl,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<HomeInfos, PaginatedResponse<CompanyOrigin>?>(
              selector: (_, model) => model.companyOrigin,
              builder: (context, PaginatedResponse<CompanyOrigin>? value, __) {
                if (value == null || value.rows.isEmpty) return SizedBox.shrink();
                final itemCount = (value.rows.length / 3).ceil();

                return _mainItemBuilder(
                  icon: Iconfont.chandi,
                  title: '玩具产地',
                  color: theme.primaryColor,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final gap = LayoutConstants.pagePadding;
                      final itemWidth = (constraints.maxWidth - gap * 3) / 3;

                      return SizedBox(
                        height: itemWidth * 2 / 3,
                        child: CustomSwiper(
                          itemCount: itemCount,
                          defaultPagination: false,
                          autoplayDelay: 5000,
                          itemBuilder: (BuildContext context, int pageIndex) {
                            return Padding(
                              padding: EdgeInsets.only(right: LayoutConstants.pagePadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(3, (itemIndex) {
                                  final dataIndex = pageIndex * 3 + itemIndex;
                                  if (dataIndex >= value.rows.length) {
                                    return SizedBox();
                                  }
                                  final exhibition = value.rows[dataIndex];

                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      width: itemWidth,
                                      height: double.infinity,
                                      imageUrl: exhibition.coverImgUrl,
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                    //  OctoImage(
                                    //   width: itemWidth,
                                    //   height: double.infinity,
                                    //   image: NetworkImage(exhibition.coverImgUrl),
                                    //   errorBuilder: OctoError.icon(color: Colors.red),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                margin: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
                width: double.infinity,
                height: 160,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: 'https://testerp-1303814652.cos.ap-guangzhou.myqcloud.com/Uploads/ProImg/Custom/2063/17642057706011.jpg',
                )),
          ),
          // SliverToBoxAdapter(
          //   child: Selector<HomeInfos, PaginatedResponse<ProductItem>?>(
          //     selector: (_, model) => model.recomendProduct,
          //     builder: (context, PaginatedResponse<ProductItem>? value, __) {
          //       if (value == null || value.rows.isEmpty) return SizedBox.shrink();
          //       return SizedBox(
          //         height: 34,
          //         child: Align(
          //           child: Text('推荐产品', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          ProductsView(
            parameter: _smartRefresherParameter,
          ),
        ],
      ),
    );
  }
}
