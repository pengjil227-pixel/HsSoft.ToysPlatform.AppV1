import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/core/constants/layout_constants.dart';
import 'package:flutter_wanhaoniu/src/widgets/user_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';

import '../../core/network/modules/exhibition.dart';
import '../../shared/models/exhibition_detail.dart';
import '../../shared/models/paginated_response.dart';
import '../../widgets/custom_swiper.dart';
import '../../widgets/custom_title.dart';
import '../../widgets/search_wrap.dart';

class ExhibitionDetail extends StatefulWidget {
  const ExhibitionDetail({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<ExhibitionDetail> createState() => _ExhibitionDetailState();
}

class _ExhibitionDetailState extends State<ExhibitionDetail> {
  ExhibitionDetailInfo? _detailInfo;
  List<ExhibitionSupplier>? _suppliers;

  @override
  void initState() {
    super.initState();
    _initData();
    _getExhibition();
  }

  void _initData() async {
    final response = await ExhibitionService.getOnlineExhibitionDetail(widget.id);
    final supplieResponse = await ExhibitionService.queryExhibitionSupplierPage({
      "pageNo": 1,
      "pageSize": 3,
      "sortField": "",
      "sortOrder": "",
      "keywords": "",
      "exhibitionNumber": response.data!.companyNumber,
    });
    setState(() {
      _detailInfo = response.data;
      _suppliers = supplieResponse.data?.rows;
    });
  }

  void _getExhibition() async {}

  final double _titleHeight = 20.0;

  Widget _titleBuilder(String title) {
    return SizedBox(
      height: _titleHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          title,
          style: TextStyle(fontSize: 14, height: 1),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('展厅详情'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: LayoutConstants.pagePadding),
            child: GestureDetector(
              onTap: () {
                context.pushNamed('search');
              },
              child: SearchWrap(
                onSearch: () {},
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: LayoutConstants.pagePadding),
            child: SizedBox(
              height: 250,
              child: _detailInfo != null
                  ? CustomSwiper(
                      itemCount: _detailInfo!.environUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CachedNetworkImage(
                          imageUrl: _detailInfo!.bgImg,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                        );
                      },
                    )
                  : SizedBox.shrink(),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
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
              trailing: Icon(
                Iconfont.a_jiantouyou,
                size: 14,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: LayoutConstants.pagePadding),
            margin: EdgeInsets.only(top: LayoutConstants.pagePadding),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                ListTile(
                  title: CustomTitle(
                    title: '最新产品',
                  ),
                  trailing: Icon(
                    Iconfont.a_jiantouyou,
                    size: 14,
                  ),
                ),
                GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: LayoutConstants.pagePadding),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: math.min(_suppliers?.length ?? 0, 3),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: LayoutConstants.pagePadding,
                    mainAxisSpacing: LayoutConstants.pagePadding,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: _suppliers![index].companyLogo,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                            ),
                          ),
                        ),
                        _titleBuilder(_suppliers![index].companyName),
                      ],
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
