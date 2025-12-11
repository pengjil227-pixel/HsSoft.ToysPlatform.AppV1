import '../../../shared/models/paginated_response.dart';
import '../../../shared/models/product.dart';
import '../api_response.dart';
import '../http_manager.dart';

class ProductDetailService {
  static Future<ApiResponse<PaginatedResponse<ProductItem>>> queryDetailRecommendProductPage(int pageNo) async {
    return HttpManager().post(
      '/front/ProductBasic/QueryDetailRecommendProductPage',
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
