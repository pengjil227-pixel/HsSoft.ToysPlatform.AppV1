
class CompanyOrigin {
  CompanyOrigin({
    required this.coverImgUrl,
    required this.promotUrl,
    required this.title,
    required this.bindArea,
    required this.province,
    required this.city,
    required this.area,
    required this.introduce,
    required this.sort,
    required this.id,
    required this.createdTime,
    required this.createdUserName,
    required this.updatedUserName,
    required this.updatedTime,
    required this.urls,
    required this.supplierCount,
    required this.productCount,
  });

  final String coverImgUrl;
  final String promotUrl;
  final String title;
  final String bindArea;
  final String province;
  final String city;
  final String area;
  final String introduce;
  final int sort;
  final int id;
  final String createdTime;
  final String createdUserName;
  final String updatedUserName;
  final String updatedTime;
  final List<String> urls;
  final int supplierCount;
  final int productCount;

  factory CompanyOrigin.fromJson(Map<String, dynamic> json) {
    return CompanyOrigin(
      coverImgUrl: json['coverImgUrl'],
      promotUrl: json['promotUrl'],
      title: json['title'],
      bindArea: json['bindArea'],
      province: json['province'],
      city: json['city'],
      area: json['area'],
      introduce: json['introduce'],
      sort: json['sort'],
      id: json['id'],
      createdTime: json['createdTime'],
      createdUserName: json['createdUserName'],
      updatedUserName: json['updatedUserName'],
      updatedTime: json['updatedTime'],
      urls: List<String>.from(json['urls'] ?? []),
      supplierCount: json['supplierCount'],
      productCount: json['productCount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coverImgUrl'] = coverImgUrl;
    data['promotUrl'] = promotUrl;
    data['title'] = title;
    data['bindArea'] = bindArea;
    data['province'] = province;
    data['city'] = city;
    data['area'] = area;
    data['introduce'] = introduce;
    data['sort'] = sort;
    data['id'] = id;
    data['createdTime'] = createdTime;
    data['createdUserName'] = createdUserName;
    data['updatedUserName'] = updatedUserName;
    data['updatedTime'] = updatedTime;
    data['urls'] = urls;
    data['supplierCount'] = supplierCount;
    data['productCount'] = productCount;
    return data;
  }
}