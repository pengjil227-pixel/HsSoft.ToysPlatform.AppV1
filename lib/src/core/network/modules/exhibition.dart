import '../../../shared/models/exhibition_detail.dart';
import '../../../shared/models/exhibition_info.dart';
import '../../../shared/models/paginated_response.dart';
import '../api_response.dart';
import '../http_manager.dart';


class ExhibitionService {
  static Future<ApiResponse<List<ExhibitionInfo>>> getOnlineExhibitionList() async {
    return HttpManager().post(
      '/front/OnlineExhibition/GetOnlineExhibitionList',
      data: {},
      fromJsonT: (data) {
        final List<dynamic> infos = data;
        return infos.map((info) => ExhibitionInfo.fromJson(info)).toList();
      },
    );
  }

  static Future<ApiResponse<ExhibitionDetailInfo>> getOnlineExhibitionDetail(int id) async {
    return HttpManager().post(
      '/front/OnlineExhibition/GetOnlineExhibitionDetail',
      data: {"id": id},
      fromJsonT: (data) {
        return ExhibitionDetailInfo.fromJson(data);
      },
    );
  }

  static Future<ApiResponse<PaginatedResponse<ExhibitionSupplier>>> queryExhibitionSupplierPage(dynamic data) async {
    return HttpManager().post(
      '/front/OnlineExhibition/QueryExhibitionSupplierPage',
      data: data,
      fromJsonT: (data) {
        return PaginatedResponse.fromJson(data, ExhibitionSupplier.fromJson);
      },
    );
  }
}
