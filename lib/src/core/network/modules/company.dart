import '../../../shared/models/company_origin.dart';
import '../../../shared/models/exhibition.dart';
import '../../../shared/models/paginated_response.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/product_detail.dart';
import '../../../shared/models/sales_ads_list.dart';
import '../api_response.dart';
import '../http_manager.dart';

// 公司业务接口的基础地址，供其他服务模块复用
const _baseUrl = 'http://192.168.110.150:8221';

class CompanyService {
  static Future<ApiResponse<List<SalesAdsList>>> getSalesAdsList(dynamic data) async {
    return HttpManager().post(
      '/front/ImageAds/GetFrontAdsList',
      data: data,
      baseUrl: _baseUrl,
      fromJsonT: (data) {
        final List<dynamic> infos = data;
        return infos.map((info) => SalesAdsList.fromJson(info)).toList();
        // return LoginUserInfo.fromJson(data);
      },
    );
  }

  static Future<ApiResponse<List<Exhibition>>> getOnlineExhibitionList() async {
    return HttpManager().post(
      '/front/OnlineExhibition/GetOnlineExhibitionList',
      baseUrl: _baseUrl,
      data: {},
      fromJsonT: (data) {
        final List<dynamic> infos = data;
        return infos.map((info) => Exhibition.fromJson(info)).toList();
      },
    );
  }

  static Future<ApiResponse<PaginatedResponse<ProductItem>>> getNewProduct() async {
    return HttpManager().post(
      '/front/ProductBasic/QueryNewProductPage',
      baseUrl: _baseUrl,
      data: {},
      fromJsonT: (data) {
        return PaginatedResponse.fromJson(data, ProductItem.fromJson);
      },
    );
  }

  static Future<ApiResponse<PaginatedResponse<CompanyOrigin>>> getCompanyOriginPage() async {
    return HttpManager().post(
      '/front/ToysOrigin/QueryCompanyOriginPage',
      baseUrl: _baseUrl,
      data: {},
      fromJsonT: (data) {
        return PaginatedResponse.fromJson(data, CompanyOrigin.fromJson);
      },
    );
  }

  static Future<ApiResponse<PaginatedResponse<ProductItem>>> getRecomendProduct(int pageNo) async {
    return HttpManager().post(
      '/front/ProductBasic/QueryFrontRecomendProductPage',
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

  static Future<ApiResponse<ProductDetail>> getProductDetail(dynamic data) async {
    return HttpManager().post(
      '/front/ProductBasic/GetProductDetail',
      baseUrl: _baseUrl,
      data: data,
      fromJsonT: (data) {
        return ProductDetail.fromJson(data);
      },
    );
  }
}
