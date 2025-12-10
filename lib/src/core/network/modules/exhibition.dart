import '../../../shared/models/exhibition_detail.dart';
import '../../../shared/models/exhibition_info.dart';
import '../api_response.dart';
import '../http_manager.dart';

const _baseUrl = 'http://192.168.110.150:8221';

class ExhibitionService {
  static Future<ApiResponse<List<ExhibitionInfo>>> getOnlineExhibitionList() async {
    return HttpManager().post(
      '/front/OnlineExhibition/GetOnlineExhibitionList',
      baseUrl: _baseUrl,
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
      baseUrl: _baseUrl,
      data: {"id": id},
      fromJsonT: (data) {
        return ExhibitionDetailInfo.fromJson(data);
      },
    );
  }
}
