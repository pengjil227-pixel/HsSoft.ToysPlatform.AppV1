class LoginUserInfo {
  LoginUserInfo({
    required this.mobile,
    required this.personnel,
    required this.name,
    required this.companyInfos,
    required this.accessToken,
    required this.routerConfig,
  });
  final String mobile;

  final String? personnel;

  final String? name;

  final List<CompanyInfos> companyInfos;

  final String accessToken;

  final String? routerConfig;

  factory LoginUserInfo.fromJson(Map<String, dynamic> json) {
    final List<dynamic> infos = json['companyInfos'];
    return LoginUserInfo(
      mobile: json['mobile'],
      personnel: json['personnel'],
      name: json['name'],
      companyInfos: infos.map((info) => CompanyInfos.fromJson(info)).toList(),
      accessToken: json['accessToken'],
      routerConfig: json['routerConfig'],
    );
  }

  Map<String, Object?> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile'] = mobile;
    data['personnel'] = personnel;
    data['name'] = name;
    data['companyInfos'] = companyInfos.map((info) => info.toJson()).toList();
    data['accessToken'] = accessToken;
    data['routerConfig'] = routerConfig;
    return data;
  }
}

class CompanyInfos {
  CompanyInfos({
    required this.id,
    required this.companyName,
    required this.companyLogo,
    required this.companyNumber,
    required this.isMain,
    required this.sysRoleId,
    required this.sysUserRoleId,
    required this.companyCode,
    required this.roleType,
  });
  final int id;
  final String companyName;
  final String companyLogo;
  final String companyNumber;
  final bool isMain;
  final int sysRoleId;
  final int sysUserRoleId;
  final String companyCode;
  final int roleType;

  factory CompanyInfos.fromJson(Map<String, dynamic> json) {
    return CompanyInfos(
      id: json['id'],
      companyName: json['companyName'],
      companyLogo: json['companyLogo'],
      companyNumber: json['companyNumber'],
      isMain: json['isMain'],
      sysRoleId: json['sysRoleId'],
      sysUserRoleId: json['sysUserRoleId'],
      companyCode: json['companyCode'],
      roleType: json['roleType'],
    );
  }

  Map<String, Object?> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyName'] = companyName;
    data['companyLogo'] = companyLogo;
    data['companyNumber'] = companyNumber;
    data['isMain'] = isMain;
    data['sysRoleId'] = sysRoleId;
    data['sysUserRoleId'] = sysUserRoleId;
    data['companyCode'] = companyCode;
    data['roleType'] = roleType;
    return data;
  }
}
