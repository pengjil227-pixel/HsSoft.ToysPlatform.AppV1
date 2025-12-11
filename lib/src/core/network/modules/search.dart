import '../../../shared/models/paginated_response.dart';
import '../../../shared/models/product.dart';
import '../api_response.dart';
import '../http_manager.dart';

class SearchService {
  static Future<ApiResponse<PaginatedResponse<ProductItem>>> queryPage(
    dynamic data, {
    required int page,
  }) async {
    return HttpManager().post(
      '/front/ProductBasic/QueryPage',
      data: {
        "page": page,
        "pageSize": 10,
        ...data,
      },
      fromJsonT: (data) {
        return PaginatedResponse.fromJson(data, ProductItem.fromJson);
      },
    );
  }
}
