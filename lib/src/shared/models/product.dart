class ProductItem {
  ProductItem({
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

  final int id;
  final String createdTime;
  final String createdUserName;
  final String updatedTime;
  final String updatedUserName;
  final bool isCheck;
  final String maNa;
  final String maNu;
  final String faNo;
  final String prNa;
  final String coNu;
  final String imgUrl;
  final String exhibitionNumber;
  final String supplierNumber;
  final String productNumber;
  final double faPr;
  final String exhibitionName;
  final int refreshTime;
  final bool isPlatNew;

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'],
      createdTime: json['createdTime'],
      createdUserName: json['createdUserName'],
      updatedTime: json['updatedTime'],
      updatedUserName: json['updatedUserName'],
      isCheck: json['isCheck'],
      maNa: json['ma_Na'],
      maNu: json['ma_Nu'],
      faNo: json['fa_No'],
      prNa: json['pr_Na'],
      coNu: json['co_Nu'],
      imgUrl: json['imgUrl'],
      exhibitionNumber: json['exhibitionNumber'],
      supplierNumber: json['supplierNumber'],
      productNumber: json['productNumber'],
      faPr: (json['fa_Pr'] as num).toDouble(),
      exhibitionName: json['exhibitionName'],
      refreshTime: json['refreshTime'],
      isPlatNew: json['isPlatNew'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdTime'] = createdTime;
    data['createdUserName'] = createdUserName;
    data['updatedTime'] = updatedTime;
    data['updatedUserName'] = updatedUserName;
    data['isCheck'] = isCheck;
    data['ma_Na'] = maNa;
    data['ma_Nu'] = maNu;
    data['fa_No'] = faNo;
    data['pr_Na'] = prNa;
    data['co_Nu'] = coNu;
    data['imgUrl'] = imgUrl;
    data['exhibitionNumber'] = exhibitionNumber;
    data['supplierNumber'] = supplierNumber;
    data['productNumber'] = productNumber;
    data['fa_Pr'] = faPr;
    data['exhibitionName'] = exhibitionName;
    data['refreshTime'] = refreshTime;
    data['isPlatNew'] = isPlatNew;
    return data;
  }
}
