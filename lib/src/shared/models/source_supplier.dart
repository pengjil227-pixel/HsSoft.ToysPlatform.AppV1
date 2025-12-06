class SourceSupplierPage {
  SourceSupplierPage({
    required this.pageNo,
    required this.pageSize,
    required this.totalPage,
    required this.totalRows,
    required this.rows,
  });

  final int pageNo;
  final int pageSize;
  final int totalPage;
  final int totalRows;
  final List<SourceSupplier> rows;

  factory SourceSupplierPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawRows = json['rows'] as List<dynamic>? ?? [];
    return SourceSupplierPage(
      pageNo: json['pageNo'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
      totalRows: json['totalRows'] ?? 0,
      rows: rawRows.map((e) => SourceSupplier.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class SourceSupplier {
  SourceSupplier({
    required this.id,
    required this.supplierName,
    required this.supplierLogo,
    required this.supplierNumber,
    required this.createdTime,
    required this.productCount,
    required this.followCount,
    required this.isFollow,
    required this.industry,
    required this.industryNames,
    required this.boothNus,
    required this.frontProductBasicOutputs,
  });

  final int? id;
  final String? supplierName;
  final String? supplierLogo;
  final String? supplierNumber;
  final String? createdTime;
  final int? productCount;
  final int? followCount;
  final bool? isFollow;
  final String? industry;
  final String? industryNames;
  final String? boothNus;
  final List<FrontProductBasicOutput> frontProductBasicOutputs;

  factory SourceSupplier.fromJson(Map<String, dynamic> json) {
    final List<dynamic> products = json['frontProductBasicOutputs'] as List<dynamic>? ?? [];
    return SourceSupplier(
      id: json['id'],
      supplierName: json['supplierName'] as String?,
      supplierLogo: json['supplierLogo'] as String?,
      supplierNumber: json['supplierNumber'] as String?,
      createdTime: json['createdTime'] as String?,
      productCount: json['productCount'],
      followCount: json['followCount'],
      isFollow: json['isFollow'],
      industry: json['industry'] as String?,
      industryNames: json['industryNames'] as String?,
      boothNus: json['booth_Nus'] as String?,
      frontProductBasicOutputs:
          products.map((e) => FrontProductBasicOutput.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  factory SourceSupplier.fromRecommend(RecommendSupplier r) {
    return SourceSupplier(
      id: r.id,
      supplierName: r.supplierName,
      supplierLogo: r.companyLogo,
      supplierNumber: r.supplierNumber,
      createdTime: r.createdTime,
      productCount: null,
      followCount: null,
      isFollow: null,
      industry: null,
      industryNames: null,
      boothNus: null,
      frontProductBasicOutputs: const [],
    );
  }

  String? get displayName => supplierName ?? '';
}

class FrontProductBasicOutput {
  FrontProductBasicOutput({
    required this.id,
    required this.createdTime,
    required this.createdUserName,
    required this.updatedTime,
    required this.updatedUserName,
    required this.isCheck,
    required this.maNa,
    required this.maNu,
    required this.faNo,
    required this.prNa,
    required this.coNu,
    required this.imgUrl,
    required this.exhibitionNumber,
    required this.supplierNumber,
    required this.productNumber,
    required this.faPr,
    required this.exhibitionName,
    required this.refreshTime,
    required this.isPlatNew,
  });

  final int? id;
  final String? createdTime;
  final String? createdUserName;
  final String? updatedTime;
  final String? updatedUserName;
  final bool? isCheck;
  final String? maNa;
  final String? maNu;
  final String? faNo;
  final String? prNa;
  final String? coNu;
  final String? imgUrl;
  final String? exhibitionNumber;
  final String? supplierNumber;
  final String? productNumber;
  final num? faPr;
  final String? exhibitionName;
  final int? refreshTime;
  final bool? isPlatNew;

  factory FrontProductBasicOutput.fromJson(Map<String, dynamic> json) {
    return FrontProductBasicOutput(
      id: json['id'],
      createdTime: json['createdTime'] as String?,
      createdUserName: json['createdUserName'] as String?,
      updatedTime: json['updatedTime'] as String?,
      updatedUserName: json['updatedUserName'] as String?,
      isCheck: json['isCheck'],
      maNa: json['ma_Na'] as String?,
      maNu: json['ma_Nu'] as String?,
      faNo: json['fa_No'] as String?,
      prNa: json['pr_Na'] as String?,
      coNu: json['co_Nu'] as String?,
      imgUrl: json['imgUrl'] as String?,
      exhibitionNumber: json['exhibitionNumber'] as String?,
      supplierNumber: json['supplierNumber'] as String?,
      productNumber: json['productNumber'] as String?,
      faPr: json['fa_Pr'],
      exhibitionName: json['exhibitionName'] as String?,
      refreshTime: json['refreshTime'],
      isPlatNew: json['isPlatNew'],
    );
  }
}

class SupplierConditional {
  SupplierConditional({
    required this.fieldName,
    required this.conditionalType,
    required this.fieldValue,
    this.key,
  });

  final String fieldName;
  final int conditionalType;
  final String fieldValue;
  final int? key;

  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'conditionalType': conditionalType,
      'fieldValue': fieldValue,
      if (key != null) 'key': key,
    };
  }
}

class RecommendSupplierPage {
  RecommendSupplierPage({
    required this.pageNo,
    required this.pageSize,
    required this.totalPage,
    required this.totalRows,
    required this.rows,
  });

  final int pageNo;
  final int pageSize;
  final int totalPage;
  final int totalRows;
  final List<RecommendSupplier> rows;

  factory RecommendSupplierPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawRows = json['rows'] as List<dynamic>? ?? [];
    return RecommendSupplierPage(
      pageNo: json['pageNo'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
      totalRows: json['totalRows'] ?? 0,
      rows: rawRows.map((e) => RecommendSupplier.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class RecommendSupplier {
  RecommendSupplier({
    required this.supplierNumber,
    required this.supplierName,
    required this.id,
    required this.createdTime,
    required this.createdUserName,
    required this.updatedTime,
    required this.updatedUserName,
    required this.isCheck,
    required this.maNa,
    required this.address,
    required this.linkMan,
    required this.phoneNumber,
    required this.companyLogo,
  });

  final String? supplierNumber;
  final String? supplierName;
  final int? id;
  final String? createdTime;
  final String? createdUserName;
  final String? updatedTime;
  final String? updatedUserName;
  final bool? isCheck;
  final String? maNa;
  final String? address;
  final String? linkMan;
  final String? phoneNumber;
  final String? companyLogo;

  factory RecommendSupplier.fromJson(Map<String, dynamic> json) {
    return RecommendSupplier(
      supplierNumber: json['supplierNumber'] as String?,
      supplierName: json['supplierName'] as String?,
      id: json['id'],
      createdTime: json['createdTime'] as String?,
      createdUserName: json['createdUserName'] as String?,
      updatedTime: json['updatedTime'] as String?,
      updatedUserName: json['updatedUserName'] as String?,
      isCheck: json['isCheck'],
      maNa: json['ma_Na'] as String?,
      address: json['address'] as String?,
      linkMan: json['linkMan'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      companyLogo: json['companyLogo'] as String?,
    );
  }
}

class SupplierDetail {
  SupplierDetail({
    this.linkMan,
    this.phoneNumber,
    this.companyName,
    this.province,
    this.city,
    this.area,
    this.address,
    this.wechatId,
    this.landlineNumber,
    this.companyLogo,
    this.businessLicense,
    this.mainBusiness,
    this.companyCode,
    this.telePhoneNumber,
    this.fax,
    this.email,
    this.nickName,
    this.remark,
    this.status,
    this.bgImg,
    this.id,
    this.companyNumber,
    this.sysRoleId,
    this.createdTime,
    this.createdUserName,
    this.updatedTime,
    this.updatedUserName,
    this.isCheck,
    this.industry,
    this.industryNames,
    this.followCount,
    this.newProductCount,
    this.onCount,
    this.settleYear,
    this.introduction,
    this.isFollow,
    this.supplierNumber,
  });

  final String? linkMan;
  final String? phoneNumber;
  final String? companyName;
  final String? province;
  final String? city;
  final String? area;
  final String? address;
  final String? wechatId;
  final String? landlineNumber;
  final String? companyLogo;
  final String? businessLicense;
  final String? mainBusiness;
  final String? companyCode;
  final String? telePhoneNumber;
  final String? fax;
  final String? email;
  final String? nickName;
  final String? remark;
  final int? status;
  final String? bgImg;
  final int? id;
  final String? companyNumber;
  final int? sysRoleId;
  final String? createdTime;
  final String? createdUserName;
  final String? updatedTime;
  final String? updatedUserName;
  final bool? isCheck;
  final String? industry;
  final String? industryNames;
  final int? followCount;
  final int? newProductCount;
  final int? onCount;
  final int? settleYear;
  final String? introduction;
  final bool? isFollow;
  final String? supplierNumber;

  factory SupplierDetail.fromJson(Map<String, dynamic> json) {
    return SupplierDetail(
      linkMan: json['linkMan'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      companyName: json['companyName'] as String?,
      province: json['province'] as String?,
      city: json['city'] as String?,
      area: json['area'] as String?,
      address: json['address'] as String?,
      wechatId: json['wechatId'] as String?,
      landlineNumber: json['landlineNumber'] as String?,
      companyLogo: json['companyLogo'] as String?,
      businessLicense: json['businessLicense'] as String?,
      mainBusiness: json['mainBusiness'] as String?,
      companyCode: json['companyCode'] as String?,
      telePhoneNumber: json['telePhoneNumber'] as String?,
      fax: json['fax'] as String?,
      email: json['email'] as String?,
      nickName: json['nickName'] as String?,
      remark: json['remark'] as String?,
      status: json['status'],
      bgImg: json['bgImg'] as String?,
      id: json['id'],
      companyNumber: json['companyNumber'] as String?,
      sysRoleId: json['sysRoleId'],
      createdTime: json['createdTime'] as String?,
      createdUserName: json['createdUserName'] as String?,
      updatedTime: json['updatedTime'] as String?,
      updatedUserName: json['updatedUserName'] as String?,
      isCheck: json['isCheck'],
      industry: json['industry'] as String?,
      industryNames: json['industryNames'] as String?,
      followCount: json['followCount'],
      newProductCount: json['newProductCount'],
      onCount: json['onCount'],
      settleYear: json['settleYear'],
      introduction: json['introduction'] as String?,
      isFollow: json['isFollow'],
      supplierNumber: json['supplierNumber'] as String?,
    );
  }
}

class SupplierContact {
  SupplierContact({
    this.supplierNumber,
    this.supplierName,
    this.phoneNumber,
    this.linkMan,
    this.telePhoneNumber,
  });

  final String? supplierNumber;
  final String? supplierName;
  final String? phoneNumber;
  final String? linkMan;
  final String? telePhoneNumber;

  factory SupplierContact.fromJson(Map<String, dynamic> json) {
    return SupplierContact(
      supplierNumber: json['supplierNumber'] as String?,
      supplierName: json['supplierName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      linkMan: json['linkMan'] as String?,
      telePhoneNumber: json['telePhoneNumber'] as String?,
    );
  }
}
