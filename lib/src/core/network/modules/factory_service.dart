import 'package:flutter_wanhaoniu/src/core/network/api_response.dart';
import 'package:flutter_wanhaoniu/src/core/network/http_manager.dart';

import '../../../shared/models/source_supplier.dart';

const _baseUrl = 'http://192.168.110.150:8221';

class FactoryService {
  /// 全部源头工厂分页
  static Future<ApiResponse<SourceSupplierPage>> querySourceSupplierPage({
    required int pageNo,
    required int pageSize,
    String? sortField,
    String? sortOrder,
    String? keywords,
    String? clNu,
    List<SupplierConditional>? conditionals,
  }) {
    final Map<String, dynamic> body = {
      'pageNo': pageNo,
      'pageSize': pageSize,
      if (sortField != null) 'sortField': sortField,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (keywords != null) 'keywords': keywords,
      if (clNu != null) 'cl_Nu': clNu,
      'conditionals': conditionals?.map((e) => e.toJson()).toList() ?? [],
    };

    return HttpManager().post(
      '/front/SourceSupplier/QuerySourceSupplierPage',
      baseUrl: _baseUrl,
      data: body,
      fromJsonT: (data) => SourceSupplierPage.fromJson(data),
    );
  }

  /// 最新入驻厂商
  static Future<ApiResponse<SourceSupplierPage>> queryLatestSupplierPage({
    required int pageNo,
    required int pageSize,
    String? sortField,
    String? sortOrder,
    String? keywords,
    List<SupplierConditional>? conditionals,
  }) {
    final Map<String, dynamic> body = {
      'pageNo': pageNo,
      'pageSize': pageSize,
      if (sortField != null) 'sortField': sortField,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (keywords != null) 'keywords': keywords,
      'conditionals': conditionals?.map((e) => e.toJson()).toList() ?? [],
    };

    return HttpManager().post(
      '/front/SourceSupplier/QueryLatestSupplierPage',
      baseUrl: _baseUrl,
      data: body,
      fromJsonT: (data) => SourceSupplierPage.fromJson(data),
    );
  }

  /// 推荐厂商
  static Future<ApiResponse<RecommendSupplierPage>> queryRecommendSupplierPage({
    required int pageNo,
    required int pageSize,
    String? sortField,
    String? sortOrder,
    String? keywords,
    List<SupplierConditional>? conditionals,
  }) {
    final Map<String, dynamic> body = {
      'pageNo': pageNo,
      'pageSize': pageSize,
      if (sortField != null) 'sortField': sortField,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (keywords != null) 'keywords': keywords,
      'conditionals': conditionals?.map((e) => e.toJson()).toList() ?? [],
    };

    return HttpManager().post(
      '/front/SourceSupplier/QueryRecommendSupplierPage',
      baseUrl: _baseUrl,
      data: body,
      fromJsonT: (data) => RecommendSupplierPage.fromJson(data),
    );
  }

  /// 工厂详情
  static Future<ApiResponse<SupplierDetail>> getSupplierDetail({
    int? id,
    String? supplierNumber,
  }) {
    return HttpManager().post(
      '/front/SourceSupplier/GetSupplierDetail',
      baseUrl: _baseUrl,
      data: {
        if (id != null) 'id': id,
        if (supplierNumber != null) 'supplierNumber': supplierNumber,
      },
      fromJsonT: (data) => SupplierDetail.fromJson(data),
    );
  }

  /// 工厂联系方式
  static Future<ApiResponse<SupplierContact>> getSupplierContact({
    required int id,
  }) {
    return HttpManager().post(
      '/front/SourceSupplier/GetSupplierContact',
      baseUrl: _baseUrl,
      data: {'id': id},
      fromJsonT: (data) => SupplierContact.fromJson(data),
    );
  }
}
