import '../../../shared/models/paginated_response.dart';
import '../../../shared/models/product.dart';
import '../api_response.dart';
import '../http_manager.dart';

const _baseUrl = 'http://192.168.110.150:8221';

class ProductDetailService {
  static Future<ApiResponse<PaginatedResponse<ProductItem>>> queryDetailRecommendProductPage(int pageNo) async {
    return HttpManager().post(
      '/front/ProductBasic/QueryDetailRecommendProductPage',
      baseUrl: _baseUrl,
      data: {
        "pageNo": pageNo,
        "pageSize": 10,
      },
      fromJsonT: (data) {
        return PaginatedResponse.fromJson(data, ProductItem.fromJson);
      },
    );
  }
}
