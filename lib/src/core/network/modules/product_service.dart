import 'package:flutter_wanhaoniu/src/core/network/api_response.dart';
import 'package:flutter_wanhaoniu/src/core/network/http_manager.dart';
import '../../../shared/models/product_class_model.dart';

const _baseUrl = 'http://192.168.110.150:8221';

class ProductService {
  // 获取产品分类列表
  static Future<ApiResponse<List<ProductClassModel>>> getProductClassList() async {
    return HttpManager().post(
      '/front/FrontProductClass/GetProductClassList',
      baseUrl: _baseUrl,
      data: {"level": 0, "keywords": ""},
      fromJsonT: (data) {
     

        return (data as List<dynamic>)
            .map((e) => ProductClassModel.fromJson(e))
            .toList();
      },
    );
  }
}
