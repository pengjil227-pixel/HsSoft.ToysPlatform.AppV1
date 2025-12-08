import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconfont/iconfont.dart';

class ProductComparePage extends StatelessWidget {
  const ProductComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_CompareItem> items = List.generate(
      5,
      (index) => _CompareItem(
        name: '充气涂鸦充气长颈鹿公仔 $index',
        code: '出厂货号：88-1$index',
        price: '出厂价：¥10.00',
        pack: '装箱量：1/10 (PCS)',
        imageUrl:
            'https://dummyimage.com/180x180/F8F8F8/AAAAAA&text=Toy+$index',
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text(
          '产品对比',
          style: TextStyle(color: Color(0xFF333333)),
        ),
        centerTitle: false, 
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        
        titleSpacing: 11,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconfont.sousuo1,
              color: Colors.black,
              size: 16, 
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              '管理',
              style: TextStyle(color: Color(0xFF666666)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.radio_button_unchecked,
                          color: Color(0xFFCCCCCC),
                        ),
                      ),

                    
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 80,
                            height: 80,
                            color: const Color(0xFFF5F5F5),
                            alignment: Alignment.center,
                            child:
                                const CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: const Color(0xFFF5F5F5),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image,
                              color: Color(0xFFBBBBBB),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                     
                      Expanded(
                        child: SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF111111),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.code,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF777777),
                                ),
                              ),
                              Text(
                                item.price,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFE53935),
                                ),
                              ),
                              Text(
                                item.pack,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

    
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
            ),
            child: Row(
              children: [
                const Icon(Icons.radio_button_unchecked,
                    color: Color(0xFFCCCCCC)),
                const SizedBox(width: 6),
                const Text(
                  '全选',
                  style: TextStyle(color: Color(0xFF666666)),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                
                    fixedSize: const Size(78, 38),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {},
                  child: const Text('开始对比'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareItem {
  _CompareItem({
    required this.name,
    required this.code,
    required this.price,
    required this.pack,
    required this.imageUrl,
  });

  final String name;
  final String code;
  final String price;
  final String pack;
  final String imageUrl;
}
