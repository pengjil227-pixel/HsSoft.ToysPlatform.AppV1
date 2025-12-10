import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/core/constants/layout_constants.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/modules/exhibition.dart';
import '../../shared/models/exhibition_info.dart';

class ExhibitionHall extends StatefulWidget {
  const ExhibitionHall({super.key});

  @override
  State<ExhibitionHall> createState() => _ExhibitionHallState();
}

class _ExhibitionHallState extends State<ExhibitionHall> {
  List<ExhibitionInfo> _exhibitionInfos = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    final response = await ExhibitionService.getOnlineExhibitionList();
    setState(() {
      _exhibitionInfos = response.data!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('线上展厅'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: LayoutConstants.pagePadding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: 'https://testerp-1303814652.cos.ap-guangzhou.myqcloud.com/Uploads/ProImg/Custom/2063/17642057706011.jpg',
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(LayoutConstants.pagePadding),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: LayoutConstants.pagePadding,
                mainAxisSpacing: LayoutConstants.pagePadding,
                childAspectRatio: 1,
              ),
              itemCount: _exhibitionInfos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.pushNamed('exhibitionDetail', pathParameters: {'id': _exhibitionInfos[index].id.toString()});
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: _exhibitionInfos[index].companyLogo,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                          ),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(_exhibitionInfos[index].bgImg),
                          ),
                          title: Text(_exhibitionInfos[index].companyName),
                          subtitle: Text(_exhibitionInfos[index].companyNumber),
                          contentPadding: EdgeInsets.symmetric(horizontal: 4),
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
