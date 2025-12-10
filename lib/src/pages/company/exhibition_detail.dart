import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/core/constants/layout_constants.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/modules/exhibition.dart';
import '../../shared/models/exhibition_detail.dart';
import '../../widgets/custom_swiper.dart';
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

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    final response = await ExhibitionService.getOnlineExhibitionDetail(widget.id);
    setState(() {
      _detailInfo = response.data;
    });
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: LayoutConstants.pagePadding),
              child: SizedBox(
                height: 250,
                child: CustomSwiper(
                  itemCount: _detailInfo?.environUrls.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return CachedNetworkImage(
                      imageUrl: _detailInfo!.bgImg,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
