import 'package:flutter/material.dart';

import '../../shared/models/company_origin.dart';
import '../../shared/models/exhibition.dart';
import '../../shared/models/paginated_response.dart';
import '../../shared/models/product.dart';
import '../../shared/models/sales_ads_list.dart';
import '../network/modules/company.dart';

class HomeInfos extends ChangeNotifier {
  List<SalesAdsList>? _salesAdsList;
  List<SalesAdsList>? get salesAdsList => _salesAdsList;
  void _setSalesAdsList(List<SalesAdsList>? value) {
    _salesAdsList = [...?value];
    notifyListeners();
  }

  Future<void> _updateSalesAdsList() async {
    final response = await CompanyService.getSalesAdsList({
      "adsType": 0,
      "areaType": 0,
    });
    _setSalesAdsList(response.data!);
  }

  List<Exhibition>? _onlineExhibitionList;
  List<Exhibition>? get onlineExhibitionList => _onlineExhibitionList;
  void _setOnlineExhibitionList(List<Exhibition>? value) {
    _onlineExhibitionList = [...?value];
    notifyListeners();
  }

  Future<void> _updateOnlineExhibitionList() async {
    final response = await CompanyService.getOnlineExhibitionList();
    _setOnlineExhibitionList(response.data!);
  }

  PaginatedResponse<ProductItem>? _newProduct;
  PaginatedResponse<ProductItem>? get newProduct => _newProduct;
  void _updateNewProduct(PaginatedResponse<ProductItem>? value) {
    _newProduct = value;
    notifyListeners();
  }

  Future<void> _getNewProduct() async {
    final response = await CompanyService.getNewProduct();
    _updateNewProduct(response.data!);
  }

  PaginatedResponse<CompanyOrigin>? _companyOrigin;
  PaginatedResponse<CompanyOrigin>? get companyOrigin => _companyOrigin;
  void _updateCompanyOrigin(PaginatedResponse<CompanyOrigin>? value) {
    _companyOrigin = value;
    notifyListeners();
  }

  Future<void> _getCompanyOrigin() async {
    final response = await CompanyService.getCompanyOriginPage();
    _updateCompanyOrigin(response.data!);
  }

  PaginatedResponse<ProductItem>? _recomendProduct;
  PaginatedResponse<ProductItem>? get recomendProduct => _recomendProduct;
  void _updateRecomendProduct(PaginatedResponse<ProductItem>? value) {
    _recomendProduct = value;
    notifyListeners();
  }

  Future<void> _getRecomendProduct() async {
    final response = await CompanyService.getRecomendProduct({
      "pageNo": 1,
    });
    _updateRecomendProduct(response.data!);
  }

  Future<bool> loadMoreRecomendProduct() async {
    if (_recomendProduct != null && _recomendProduct!.totalPage == _recomendProduct!.pageNo) {
      return false;
    }
    final response = await CompanyService.getRecomendProduct({
      "pageNo": _recomendProduct!.pageNo + 1,
    });
    _recomendProduct!.rows.addAll(response.data!.rows);
    notifyListeners();
    // response.data!.rows.insertAll(0, recomendProduct!.rows);
    // _updateRecomendProduct(response.data);
    return response.data?.totalPage != response.data?.pageNo;
  }

  Future<void> updateHomeInfos() async {
    try {
      await Future.wait([
        _updateSalesAdsList(),
        _updateOnlineExhibitionList(),
        _getNewProduct(),
        _getCompanyOrigin(),
        _getRecomendProduct(),
      ]);
    } catch (err) {
      print(err);
    }
  }
}
