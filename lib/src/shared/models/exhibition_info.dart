class ExhibitionInfo {
  ExhibitionInfo({
    required this.id,
    required this.companyName,
    required this.companyNumber,
    required this.companyLogo,
    required this.introduction,
    required this.bgImg,
  });
  
  final int id;
  final String companyName;
  final String companyNumber;
  final String companyLogo;
  final String introduction;
  final String bgImg;

  factory ExhibitionInfo.fromJson(Map<String, dynamic> json) {
    return ExhibitionInfo(
      id: json['id'],
      companyName: json['companyName'],
      companyNumber: json['companyNumber'],
      companyLogo: json['companyLogo'],
      introduction: json['introduction'],
      bgImg: json['bgImg'],
    );
  }

  Map<String, Object?> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyName'] = companyName;
    data['companyNumber'] = companyNumber;
    data['companyLogo'] = companyLogo;
    data['introduction'] = introduction;
    data['bgImg'] = bgImg;
    return data;
  }
}