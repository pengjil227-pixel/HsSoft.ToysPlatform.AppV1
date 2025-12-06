class ProductDetail {
  ProductDetail({
    required this.prNa,
    required this.maNu,
    required this.barCode13,
    required this.clNu,
    required this.clNa,
    required this.clNeNa,
    required this.prEnNa,
    required this.unNa,
    required this.enUnNa,
    required this.faNo,
    required this.paNu,
    required this.chPa,
    required this.enPa,
    required this.faPr,
    required this.prLe,
    required this.prWi,
    required this.prHi,
    required this.ouLe,
    required this.prSt,
    required this.ouWi,
    required this.ouHi,
    required this.bulkFeet,
    required this.bulkStere,
    required this.inEn,
    required this.ouLo,
    required this.loUn,
    required this.grWe,
    required this.neWe,
    required this.colorNa,
    required this.colorEnNa,
    required this.attestation,
    required this.colorCount,
    required this.attestationCount,
    required this.hasPic,
    required this.other,
    required this.isStop,
    required this.isOff,
    required this.brNa,
    required this.inLe,
    required this.inWi,
    required this.inHi,
    required this.grWePr,
    required this.neWePr,
    required this.isGcc,
    required this.isInFringement,
    required this.shape,
    required this.wordReplace,
    required this.depositNu,
    required this.isShow,
    required this.enRemark,
    required this.remark,
    required this.battery,
    required this.notice,
    required this.id,
    required this.imgUrl,
    required this.coNu,
    required this.maNa,
    required this.maCl,
    required this.linkMan,
    required this.maPh1,
    required this.handSet,
    required this.qq,
    required this.fax,
    required this.createdTime,
    required this.updatedTime,
    required this.keyGuid,
    required this.maKeyGuid,
    required this.source,
    required this.isCheck,
    required this.exhibitionNumber,
    required this.supplierNumber,
    required this.productNumber,
    required this.isHot,
    required this.isRecommend,
    required this.isDiscount,
    required this.moq,
    required this.exhibitionName,
    required this.boothNu,
    required this.imgList,
    required this.videoList,
  });

  final String prNa;
  final String maNu;
  final String barCode13;
  final String clNu;
  final String clNa;
  final String clNeNa;
  final String prEnNa;
  final String unNa;
  final String enUnNa;
  final String faNo;
  final String paNu;
  final String chPa;
  final String enPa;
  final double faPr;
  final double prLe;
  final double prWi;
  final double prHi;
  final double ouLe;
  final int prSt;
  final double ouWi;
  final double ouHi;
  final double bulkFeet;
  final double bulkStere;
  final double inEn;
  final double ouLo;
  final String loUn;
  final double grWe;
  final double neWe;
  final String colorNa;
  final String colorEnNa;
  final String attestation;
  final int colorCount;
  final int attestationCount;
  final bool hasPic;
  final String other;
  final bool isStop;
  final bool isOff;
  final String brNa;
  final double inLe;
  final double inWi;
  final double inHi;
  final double grWePr;
  final double neWePr;
  final bool isGcc;
  final int isInFringement;
  final String shape;
  final String wordReplace;
  final String depositNu;
  final bool isShow;
  final String enRemark;
  final String remark;
  final String battery;
  final String notice;
  final int id;
  final String imgUrl;
  final String coNu;
  final String maNa;
  final String maCl;
  final String linkMan;
  final String maPh1;
  final String handSet;
  final String qq;
  final String fax;
  final String createdTime;
  final String updatedTime;
  final String keyGuid;
  final String maKeyGuid;
  final String source;
  final bool isCheck;
  final String exhibitionNumber;
  final String supplierNumber;
  final String productNumber;
  final bool isHot;
  final bool isRecommend;
  final bool isDiscount;
  final int moq;
  final String exhibitionName;
  final String boothNu;
  final List<ProductMedia> imgList;
  final List<ProductMedia> videoList;

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      prNa: json['pr_Na'] ?? '',
      maNu: json['ma_Nu'] ?? '',
      barCode13: json['barCode13'] ?? '',
      clNu: json['cl_Nu'] ?? '',
      clNa: json['cl_Na'] ?? '',
      clNeNa: json['cl_Ne_Na'] ?? '',
      prEnNa: json['pr_En_Na'] ?? '',
      unNa: json['un_Na'] ?? '',
      enUnNa: json['en_Un_Na'] ?? '',
      faNo: json['fa_No'] ?? '',
      paNu: json['pa_Nu'] ?? '',
      chPa: json['ch_Pa'] ?? '',
      enPa: json['en_Pa'] ?? '',
      faPr: (json['fa_Pr'] as num?)?.toDouble() ?? 0.0,
      prLe: (json['pr_Le'] as num?)?.toDouble() ?? 0.0,
      prWi: (json['pr_Wi'] as num?)?.toDouble() ?? 0.0,
      prHi: (json['pr_Hi'] as num?)?.toDouble() ?? 0.0,
      ouLe: (json['ou_Le'] as num?)?.toDouble() ?? 0.0,
      prSt: json['pr_St'] ?? 0,
      ouWi: (json['ou_Wi'] as num?)?.toDouble() ?? 0.0,
      ouHi: (json['ou_Hi'] as num?)?.toDouble() ?? 0.0,
      bulkFeet: (json['bulk_Feet'] as num?)?.toDouble() ?? 0.0,
      bulkStere: (json['bulk_Stere'] as num?)?.toDouble() ?? 0.0,
      inEn: (json['in_En'] as num?)?.toDouble() ?? 0.0,
      ouLo: (json['ou_Lo'] as num?)?.toDouble() ?? 0.0,
      loUn: json['lo_Un'] ?? '',
      grWe: (json['gr_We'] as num?)?.toDouble() ?? 0.0,
      neWe: (json['ne_We'] as num?)?.toDouble() ?? 0.0,
      colorNa: json['color_Na'] ?? '',
      colorEnNa: json['color_En_Na'] ?? '',
      attestation: json['attestation'] ?? '',
      colorCount: json['color_Count'] ?? 0,
      attestationCount: json['attestation_Count'] ?? 0,
      hasPic: json['hasPic'] ?? false,
      other: json['other'] ?? '',
      isStop: json['isStop'] ?? false,
      isOff: json['isOff'] ?? false,
      brNa: json['br_Na'] ?? '',
      inLe: (json['in_Le'] as num?)?.toDouble() ?? 0.0,
      inWi: (json['in_Wi'] as num?)?.toDouble() ?? 0.0,
      inHi: (json['in_Hi'] as num?)?.toDouble() ?? 0.0,
      grWePr: (json['gr_We_Pr'] as num?)?.toDouble() ?? 0.0,
      neWePr: (json['ne_We_Pr'] as num?)?.toDouble() ?? 0.0,
      isGcc: json['isGcc'] ?? false,
      isInFringement: json['isInFringement'] ?? 0,
      shape: json['shape'] ?? '',
      wordReplace: json['word_Replace'] ?? '',
      depositNu: json['deposit_Nu'] ?? '',
      isShow: json['isShow'] ?? false,
      enRemark: json['en_Remark'] ?? '',
      remark: json['remark'] ?? '',
      battery: json['battery'] ?? '',
      notice: json['notice'] ?? '',
      id: json['id'] ?? 0,
      imgUrl: json['imgUrl'] ?? '',
      coNu: json['co_Nu'] ?? '',
      maNa: json['ma_Na'] ?? '',
      maCl: json['ma_Cl'] ?? '',
      linkMan: json['linkMan'] ?? '',
      maPh1: json['ma_Ph_1'] ?? '',
      handSet: json['handSet'] ?? '',
      qq: json['qq'] ?? '',
      fax: json['fax'] ?? '',
      createdTime: json['createdTime'] ?? '',
      updatedTime: json['updatedTime'] ?? '',
      keyGuid: json['keyGuid'] ?? '',
      maKeyGuid: json['ma_KeyGuid'] ?? '',
      source: json['source'] ?? '',
      isCheck: json['isCheck'] ?? false,
      exhibitionNumber: json['exhibitionNumber'] ?? '',
      supplierNumber: json['supplierNumber'] ?? '',
      productNumber: json['productNumber'] ?? '',
      isHot: json['isHot'] ?? false,
      isRecommend: json['isRecommend'] ?? false,
      isDiscount: json['isDiscount'] ?? false,
      moq: json['moq'] ?? 0,
      exhibitionName: json['exhibitionName'] ?? '',
      boothNu: json['booth_Nu'] ?? '',
      imgList: (json['imgList'] as List<dynamic>?)
              ?.map((e) => ProductMedia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      videoList: (json['videoList'] as List<dynamic>?)
              ?.map((e) => ProductMedia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pr_Na'] = prNa;
    data['ma_Nu'] = maNu;
    data['barCode13'] = barCode13;
    data['cl_Nu'] = clNu;
    data['cl_Na'] = clNa;
    data['cl_Ne_Na'] = clNeNa;
    data['pr_En_Na'] = prEnNa;
    data['un_Na'] = unNa;
    data['en_Un_Na'] = enUnNa;
    data['fa_No'] = faNo;
    data['pa_Nu'] = paNu;
    data['ch_Pa'] = chPa;
    data['en_Pa'] = enPa;
    data['fa_Pr'] = faPr;
    data['pr_Le'] = prLe;
    data['pr_Wi'] = prWi;
    data['pr_Hi'] = prHi;
    data['ou_Le'] = ouLe;
    data['pr_St'] = prSt;
    data['ou_Wi'] = ouWi;
    data['ou_Hi'] = ouHi;
    data['bulk_Feet'] = bulkFeet;
    data['bulk_Stere'] = bulkStere;
    data['in_En'] = inEn;
    data['ou_Lo'] = ouLo;
    data['lo_Un'] = loUn;
    data['gr_We'] = grWe;
    data['ne_We'] = neWe;
    data['color_Na'] = colorNa;
    data['color_En_Na'] = colorEnNa;
    data['attestation'] = attestation;
    data['color_Count'] = colorCount;
    data['attestation_Count'] = attestationCount;
    data['hasPic'] = hasPic;
    data['other'] = other;
    data['isStop'] = isStop;
    data['isOff'] = isOff;
    data['br_Na'] = brNa;
    data['in_Le'] = inLe;
    data['in_Wi'] = inWi;
    data['in_Hi'] = inHi;
    data['gr_We_Pr'] = grWePr;
    data['ne_We_Pr'] = neWePr;
    data['isGcc'] = isGcc;
    data['isInFringement'] = isInFringement;
    data['shape'] = shape;
    data['word_Replace'] = wordReplace;
    data['deposit_Nu'] = depositNu;
    data['isShow'] = isShow;
    data['en_Remark'] = enRemark;
    data['remark'] = remark;
    data['battery'] = battery;
    data['notice'] = notice;
    data['id'] = id;
    data['imgUrl'] = imgUrl;
    data['co_Nu'] = coNu;
    data['ma_Na'] = maNa;
    data['ma_Cl'] = maCl;
    data['linkMan'] = linkMan;
    data['ma_Ph_1'] = maPh1;
    data['handSet'] = handSet;
    data['qq'] = qq;
    data['fax'] = fax;
    data['createdTime'] = createdTime;
    data['updatedTime'] = updatedTime;
    data['keyGuid'] = keyGuid;
    data['ma_KeyGuid'] = maKeyGuid;
    data['source'] = source;
    data['isCheck'] = isCheck;
    data['exhibitionNumber'] = exhibitionNumber;
    data['supplierNumber'] = supplierNumber;
    data['productNumber'] = productNumber;
    data['isHot'] = isHot;
    data['isRecommend'] = isRecommend;
    data['isDiscount'] = isDiscount;
    data['moq'] = moq;
    data['exhibitionName'] = exhibitionName;
    data['booth_Nu'] = boothNu;
    data['imgList'] = imgList.map((e) => e.toJson()).toList();
    data['videoList'] = videoList.map((e) => e.toJson()).toList();
    return data;
  }

  ProductDetail copyWith({
    String? prNa,
    String? maNu,
    String? barCode13,
    String? clNu,
    String? clNa,
    String? clNeNa,
    String? prEnNa,
    String? unNa,
    String? enUnNa,
    String? faNo,
    String? paNu,
    String? chPa,
    String? enPa,
    double? faPr,
    double? prLe,
    double? prWi,
    double? prHi,
    double? ouLe,
    int? prSt,
    double? ouWi,
    double? ouHi,
    double? bulkFeet,
    double? bulkStere,
    double? inEn,
    double? ouLo,
    String? loUn,
    double? grWe,
    double? neWe,
    String? colorNa,
    String? colorEnNa,
    String? attestation,
    int? colorCount,
    int? attestationCount,
    bool? hasPic,
    String? other,
    bool? isStop,
    bool? isOff,
    String? brNa,
    double? inLe,
    double? inWi,
    double? inHi,
    double? grWePr,
    double? neWePr,
    bool? isGcc,
    int? isInFringement,
    String? shape,
    String? wordReplace,
    String? depositNu,
    bool? isShow,
    String? enRemark,
    String? remark,
    String? battery,
    String? notice,
    int? id,
    String? imgUrl,
    String? coNu,
    String? maNa,
    String? maCl,
    String? linkMan,
    String? maPh1,
    String? handSet,
    String? qq,
    String? fax,
    String? createdTime,
    String? updatedTime,
    String? keyGuid,
    String? maKeyGuid,
    String? source,
    bool? isCheck,
    String? exhibitionNumber,
    String? supplierNumber,
    String? productNumber,
    bool? isHot,
    bool? isRecommend,
    bool? isDiscount,
    int? moq,
    String? exhibitionName,
    String? boothNu,
    List<ProductMedia>? imgList,
    List<ProductMedia>? videoList,
  }) {
    return ProductDetail(
      prNa: prNa ?? this.prNa,
      maNu: maNu ?? this.maNu,
      barCode13: barCode13 ?? this.barCode13,
      clNu: clNu ?? this.clNu,
      clNa: clNa ?? this.clNa,
      clNeNa: clNeNa ?? this.clNeNa,
      prEnNa: prEnNa ?? this.prEnNa,
      unNa: unNa ?? this.unNa,
      enUnNa: enUnNa ?? this.enUnNa,
      faNo: faNo ?? this.faNo,
      paNu: paNu ?? this.paNu,
      chPa: chPa ?? this.chPa,
      enPa: enPa ?? this.enPa,
      faPr: faPr ?? this.faPr,
      prLe: prLe ?? this.prLe,
      prWi: prWi ?? this.prWi,
      prHi: prHi ?? this.prHi,
      ouLe: ouLe ?? this.ouLe,
      prSt: prSt ?? this.prSt,
      ouWi: ouWi ?? this.ouWi,
      ouHi: ouHi ?? this.ouHi,
      bulkFeet: bulkFeet ?? this.bulkFeet,
      bulkStere: bulkStere ?? this.bulkStere,
      inEn: inEn ?? this.inEn,
      ouLo: ouLo ?? this.ouLo,
      loUn: loUn ?? this.loUn,
      grWe: grWe ?? this.grWe,
      neWe: neWe ?? this.neWe,
      colorNa: colorNa ?? this.colorNa,
      colorEnNa: colorEnNa ?? this.colorEnNa,
      attestation: attestation ?? this.attestation,
      colorCount: colorCount ?? this.colorCount,
      attestationCount: attestationCount ?? this.attestationCount,
      hasPic: hasPic ?? this.hasPic,
      other: other ?? this.other,
      isStop: isStop ?? this.isStop,
      isOff: isOff ?? this.isOff,
      brNa: brNa ?? this.brNa,
      inLe: inLe ?? this.inLe,
      inWi: inWi ?? this.inWi,
      inHi: inHi ?? this.inHi,
      grWePr: grWePr ?? this.grWePr,
      neWePr: neWePr ?? this.neWePr,
      isGcc: isGcc ?? this.isGcc,
      isInFringement: isInFringement ?? this.isInFringement,
      shape: shape ?? this.shape,
      wordReplace: wordReplace ?? this.wordReplace,
      depositNu: depositNu ?? this.depositNu,
      isShow: isShow ?? this.isShow,
      enRemark: enRemark ?? this.enRemark,
      remark: remark ?? this.remark,
      battery: battery ?? this.battery,
      notice: notice ?? this.notice,
      id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl,
      coNu: coNu ?? this.coNu,
      maNa: maNa ?? this.maNa,
      maCl: maCl ?? this.maCl,
      linkMan: linkMan ?? this.linkMan,
      maPh1: maPh1 ?? this.maPh1,
      handSet: handSet ?? this.handSet,
      qq: qq ?? this.qq,
      fax: fax ?? this.fax,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
      keyGuid: keyGuid ?? this.keyGuid,
      maKeyGuid: maKeyGuid ?? this.maKeyGuid,
      source: source ?? this.source,
      isCheck: isCheck ?? this.isCheck,
      exhibitionNumber: exhibitionNumber ?? this.exhibitionNumber,
      supplierNumber: supplierNumber ?? this.supplierNumber,
      productNumber: productNumber ?? this.productNumber,
      isHot: isHot ?? this.isHot,
      isRecommend: isRecommend ?? this.isRecommend,
      isDiscount: isDiscount ?? this.isDiscount,
      moq: moq ?? this.moq,
      exhibitionName: exhibitionName ?? this.exhibitionName,
      boothNu: boothNu ?? this.boothNu,
      imgList: imgList ?? this.imgList,
      videoList: videoList ?? this.videoList,
    );
  }
}

class ProductMedia {
  ProductMedia({
    required this.coNu,
    required this.filePath,
    required this.productNumber,
    required this.type,
  });

  final String coNu;
  final String filePath;
  final String productNumber;
  final int type;

  factory ProductMedia.fromJson(Map<String, dynamic> json) {
    return ProductMedia(
      coNu: json['co_Nu'] ?? '',
      filePath: json['filePath'] ?? '',
      productNumber: json['productNumber'] ?? '',
      type: json['type'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['co_Nu'] = coNu;
    data['filePath'] = filePath;
    data['productNumber'] = productNumber;
    data['type'] = type;
    return data;
  }

  ProductMedia copyWith({
    String? coNu,
    String? filePath,
    String? productNumber,
    int? type,
  }) {
    return ProductMedia(
      coNu: coNu ?? this.coNu,
      filePath: filePath ?? this.filePath,
      productNumber: productNumber ?? this.productNumber,
      type: type ?? this.type,
    );
  }
}