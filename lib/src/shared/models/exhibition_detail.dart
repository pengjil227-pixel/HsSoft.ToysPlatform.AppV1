class ExhibitionDetailInfo {
  ExhibitionDetailInfo({
    required this.id,
    required this.companyName,
    required this.companyNumber,
    required this.companyLogo,
    required this.introduction,
    required this.bgImg,
    required this.linkMan,
    required this.phoneNumber,
    required this.telePhoneNumber,
    required this.address,
    required this.productCount,
    required this.videoUrl,
    required this.openDate,
    required this.landArea,
    required this.supplierCount,
    required this.environUrls,
  });

  final int id;
  final String companyName;
  final String companyNumber;
  final String companyLogo;
  final String introduction;
  final String bgImg;
  final String linkMan;
  final String phoneNumber;
  final String telePhoneNumber;
  final String address;
  final int productCount;
  final String videoUrl;
  final DateTime openDate;
  final double landArea;
  final int supplierCount;
  final List<String> environUrls;

  factory ExhibitionDetailInfo.fromJson(Map<String, dynamic> json) {
    return ExhibitionDetailInfo(
      id: json['id'] as int? ?? 0,
      companyName: json['companyName'] as String? ?? '',
      companyNumber: json['companyNumber'] as String? ?? '',
      companyLogo: json['companyLogo'] as String? ?? '',
      introduction: json['introduction'] as String? ?? '',
      bgImg: json['bgImg'] as String? ?? '',
      linkMan: json['linkMan'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      telePhoneNumber: json['telePhoneNumber'] as String? ?? '',
      address: json['address'] as String? ?? '',
      productCount: json['productCount'] as int? ?? 0,
      videoUrl: json['videoUrl'] as String? ?? '',
      openDate: json['openDate'] != null ? DateTime.parse(json['openDate'] as String) : DateTime.now(),
      landArea: (json['landArea'] as num?)?.toDouble() ?? 0.0,
      supplierCount: json['supplierCount'] as int? ?? 0,
      environUrls: json['environUrls'] != null ? List<String>.from(json['environUrls'] as List) : <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyName'] = companyName;
    data['companyNumber'] = companyNumber;
    data['companyLogo'] = companyLogo;
    data['introduction'] = introduction;
    data['bgImg'] = bgImg;
    data['linkMan'] = linkMan;
    data['phoneNumber'] = phoneNumber;
    data['telePhoneNumber'] = telePhoneNumber;
    data['address'] = address;
    data['productCount'] = productCount;
    data['videoUrl'] = videoUrl;
    data['openDate'] = openDate.toIso8601String();
    data['landArea'] = landArea;
    data['supplierCount'] = supplierCount;
    data['environUrls'] = environUrls;
    return data;
  }
}

class ExhibitionSupplier {
  ExhibitionSupplier({
    required this.id,
    required this.companyNumber,
    required this.companyName,
    required this.companyLogo,
  });

  final int id;
  final String companyNumber;
  final String companyName;
  final String companyLogo;

  factory ExhibitionSupplier.fromJson(Map<String, dynamic> json) {
    return ExhibitionSupplier(
      id: json['id'],
      companyNumber: json['companyNumber'],
      companyName: json['companyName'],
      companyLogo: json['companyLogo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyNumber'] = companyNumber;
    data['companyName'] = companyName;
    data['companyLogo'] = companyLogo;
    return data;
  }
}
