import 'package:flutter_wanhaoniu/src/core/network/api_response.dart';

import '../../../shared/models/exhibition.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/sales_ads_list.dart';
import '../http_manager.dart';

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

  static Future<ApiResponse<List<Product>>> getNewProduct() async {
    return HttpManager().post(
      '/front/ProductBasic/QueryNewProductPage',
      baseUrl: _baseUrl,
      data: {},
      fromJsonT: (data) {
        print(data);
        final List<dynamic> infos = data;
        return infos.map((info) => Product.fromJson(info)).toList();
      },
    );
  }
}
