class SalesAdsList {
  SalesAdsList({
    required this.id,
    required this.title,
    required this.areaType,
    required this.adsType,
    required this.sort,
    required this.companyNumber,
    required this.imgUrl,
    required this.isShow,
    required this.startTime,
    required this.endTime,
  });

  final int id;
  final String title;
  final int areaType;
  final int adsType;
  final int sort;
  final String companyNumber;
  final String imgUrl;
  final bool isShow;
  final String startTime;
  final String endTime;

  factory SalesAdsList.fromJson(Map<String, dynamic> json) {
    return SalesAdsList(
      id: json['id'],
      title: json['title'],
      areaType: json['areaType'],
      adsType: json['adsType'],
      sort: json['sort'],
      companyNumber: json['companyNumber'],
      imgUrl: json['imgUrl'],
      isShow: json['isShow'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, Object?> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['areaType'] = areaType;
    data['adsType'] = adsType;
    data['sort'] = sort;
    data['companyNumber'] = companyNumber;
    data['imgUrl'] = imgUrl;
    data['isShow'] = isShow;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}
