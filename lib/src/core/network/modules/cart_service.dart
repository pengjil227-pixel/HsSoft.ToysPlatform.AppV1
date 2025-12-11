import '../../models/cart_models.dart';
import '../api_response.dart';
import '../http_manager.dart';

class CartService {
  const CartService._();

  static Future<ApiResponse<bool>> addProduct({
    String? productNumber,
    List<String>? productNumbers,
  }) {
    final Map<String, dynamic> body = <String, dynamic>{
      if (productNumber != null) 'productNumber': productNumber,
      if (productNumbers != null) 'productNumbers': productNumbers,
    };
    return HttpManager().post(
      '/front/ProductCart/Add',
      data: body,
      fromJsonT: (_) => true,
    );
  }

  static Future<ApiResponse<bool>> updateQuantity({
    required int id,
    required int boxNumber,
  }) {
    return HttpManager().post(
      '/front/ProductCart/Update',
      data: <String, dynamic>{
        'id': id,
        'boxNumber': boxNumber,
      },
      fromJsonT: (_) => true,
    );
  }

  static Future<ApiResponse<bool>> deleteItem({required int id}) {
    return HttpManager().post(
      '/front/ProductCart/Delete',
      data: <String, dynamic>{'id': id},
      fromJsonT: (_) => true,
    );
  }

  static Future<ApiResponse<bool>> batchDelete({required List<int> ids}) {
    return HttpManager().post(
      '/front/ProductCart/BatchDelete',
      data: <String, dynamic>{'ids': ids},
      fromJsonT: (_) => true,
    );
  }

  static Future<ApiResponse<List<CartProductEntity>>> queryPage({
    int pageNo = 1,
    int pageSize = 500,
  }) {
    return HttpManager().post(
      '/front/ProductCart/QueryPage',
      data: <String, dynamic>{
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
      fromJsonT: (dynamic data) {
        final List<dynamic> rows = (data?['rows'] as List?) ?? <dynamic>[];
        return rows.map((dynamic e) => CartProductEntity.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }

  static Future<ApiResponse<List<CartProductEntity>>> queryRepeatPage({
    int pageNo = 1,
    int pageSize = 500,
  }) {
    return HttpManager().post(
      '/front/ProductCart/QueryRepeatProductPage',
      data: <String, dynamic>{
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
      fromJsonT: (dynamic data) {
        final List<dynamic> rows = (data?['rows'] as List?) ?? <dynamic>[];
        return rows.map((dynamic e) => CartProductEntity.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }
}
