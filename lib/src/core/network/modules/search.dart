import '../../../shared/models/paginated_response.dart';
import '../../../shared/models/product.dart';
import '../api_response.dart';
import '../http_manager.dart';

const _baseUrl = 'http://192.168.110.150:8221';

class SearchService {
  static Future<ApiResponse<PaginatedResponse<ProductItem>>> queryPage(
    dynamic data, {
    required int page,
  }) async {
    return HttpManager().post(
      '/front/ProductBasic/QueryPage',
      baseUrl: _baseUrl,
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
