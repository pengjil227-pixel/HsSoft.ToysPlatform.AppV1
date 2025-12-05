import 'package:flutter/material.dart';
import 'package:iconfont/iconfont.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

import '../../core/constants/layout_constants.dart';
import '../../core/providers/home_infos.dart';
import '../../shared/models/exhibition.dart';
import '../../shared/models/sales_ads_list.dart';
import '../../widgets/custom_swiper.dart';
import '../../widgets/goods_item.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({super.key});

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
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

    return CustomScrollView(
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
                        return OctoImage(
                          image: NetworkImage(value[index].imgUrl),
                          errorBuilder: OctoError.icon(color: Colors.red),
                          fit: BoxFit.cover,
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
          child: _mainItemBuilder(
            icon: Iconfont.zhanting,
            title: '线上展厅',
            color: theme.primaryColor,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gap = LayoutConstants.pagePadding;
                final itemWidth = (constraints.maxWidth - gap * 3) / 3;

                return SizedBox(
                  height: itemWidth * 2 / 3,
                  child: Selector<HomeInfos, List<Exhibition>?>(
                    selector: (_, model) => model.onlineExhibitionList,
                    builder: (context, List<Exhibition>? value, __) {
                      // 计算每页显示3个，总页数
                      final itemCount = (value?.length ?? 0 / 3).ceil();

                      return CustomSwiper(
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
                                final exhibition = value![dataIndex];

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: OctoImage(
                                    width: itemWidth,
                                    height: double.infinity,
                                    image: NetworkImage(exhibition.bgImg),
                                    errorBuilder: OctoError.icon(color: Colors.red),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _mainItemBuilder(
            icon: Iconfont.xinpin,
            title: '新品推荐',
            color: theme.primaryColor,
            child: GridView.builder(
              padding: EdgeInsets.only(right: LayoutConstants.pagePadding),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: LayoutConstants.pagePadding,
                mainAxisSpacing: LayoutConstants.pagePadding,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://picsum.photos/300/160?i=$index',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _mainItemBuilder(
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
                    itemCount: 3,
                    defaultPagination: false,
                    autoplayDelay: 8000,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(right: LayoutConstants.pagePadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [1, 2, 3].map((item) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                'https://picsum.photos/300/160?i=$index',
                                width: itemWidth,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
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
            child: Image.network(
              'https://picsum.photos/300/160?i=100',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 34,
            child: Align(
              child: Text('推荐产品', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, 0, LayoutConstants.pagePadding, LayoutConstants.pagePadding),
          sliver: SliverGrid.builder(
            // itemCount: ,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: LayoutConstants.pagePadding,
              mainAxisSpacing: LayoutConstants.pagePadding,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              return GoodsItem();
            },
          ),
        ),
      ],
    );
    // return Container(
    //   color: Colors.amber,
    //   child: ListView.builder(
    //     itemCount: 50,
    //     itemBuilder: (context, index) {
    //       return Container(
    //         height: 50,
    //         margin: EdgeInsets.all(10),
    //         color: Colors.greenAccent,
    //       );
    //     },
    //   ),
    // );
  }
}
