class Exhibition {
  final int id;
  final String companyName;
  final String companyNumber;
  final String companyLogo;
  final String introduction;
  final String bgImg;

  Exhibition({
    required this.id,
    required this.companyName,
    required this.companyNumber,
    required this.companyLogo,
    required this.introduction,
    required this.bgImg,
  });

  // 从 JSON 创建 Exhibition 对象
  factory Exhibition.fromJson(Map<String, dynamic> json) {
    return Exhibition(
      id: json['id'],
      companyName: json['companyName'],
      companyNumber: json['companyNumber'],
      companyLogo: json['companyLogo'],
      introduction: json['introduction'],
      bgImg: json['bgImg'],
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'companyNumber': companyNumber,
      'companyLogo': companyLogo,
      'introduction': introduction,
      'bgImg': bgImg,
    };
  }

  // 复制对象（用于更新部分字段）
  Exhibition copyWith({
    int? id,
    String? companyName,
    String? companyNumber,
    String? companyLogo,
    String? introduction,
    String? bgImg,
  }) {
    return Exhibition(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      companyNumber: companyNumber ?? this.companyNumber,
      companyLogo: companyLogo ?? this.companyLogo,
      introduction: introduction ?? this.introduction,
      bgImg: bgImg ?? this.bgImg,
    );
  }
}