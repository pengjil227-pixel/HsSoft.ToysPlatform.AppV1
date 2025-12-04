import 'package:flutter_wanhaoniu/src/core/network/api_response.dart';
import 'package:flutter_wanhaoniu/src/core/network/http_manager.dart';
import '../../../shared/models/product_class_model.dart';
import '../http_config.dart';

class ProductService {
  // 获取产品分类列表
  static Future<ApiResponse<List<ProductClassModel>>> getProductClassList() async {
    return HttpManager().post(
      '${HttpConfig.businessBaseUrl}/front/FrontProductClass/GetProductClassList',
      data: {
        "level": 0, // 0-所有 (根据你的接口文档)
        "keywords": ""
      },
      fromJsonT: (data) {
        // 解析列表数据
        print("测一下有没有数据: $data");

        return (data as List<dynamic>)
            .map((e) => ProductClassModel.fromJson(e))
            .toList();
      },
    );
  }
}