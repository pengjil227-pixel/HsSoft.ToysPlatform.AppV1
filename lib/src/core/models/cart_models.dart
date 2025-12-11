class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.isSelected = false,
  });

  final String id;
  final String name;
  final String sku;
  final double price;
  final String imageUrl;
  final int quantity;
  final bool isSelected;

  double get totalPrice => price * quantity;

  ProductModel copyWith({
    int? quantity,
    bool? isSelected,
  }) {
    return ProductModel(
      id: id,
      name: name,
      sku: sku,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class FactoryModel {
  const FactoryModel({
    required this.id,
    required this.name,
    required this.products,
  });

  final String id;
  final String name;
  final List<ProductModel> products;

  bool get isSelected => products.isNotEmpty && products.every((ProductModel p) => p.isSelected);

  FactoryModel copyWith({List<ProductModel>? products}) {
    return FactoryModel(
      id: id,
      name: name,
      products: products ?? this.products,
    );
  }
}

class CartInfo {
  const CartInfo({
    required this.id,
    required this.name,
    required this.items,
  });

  final String id;
  final String name;
  final List<FactoryModel> items;

  CartInfo copyWith({
    String? name,
    List<FactoryModel>? items,
  }) {
    return CartInfo(
      id: id,
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }
}

class CartProductEntity {
  const CartProductEntity({
    required this.id,
    required this.productNumber,
    required this.supplierNumber,
    required this.supplierName,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.sku,
    required this.quantity,
    required this.packageType,
    this.remark,
    this.isHot,
    this.isRecommend,
    this.isOff,
    this.prLe,
    this.prWi,
    this.prHi,
    this.ouLe,
    this.ouWi,
    this.ouHi,
    this.inEn,
    this.ouLo,
  });

  final int id;
  final String productNumber;
  final String supplierNumber;
  final String supplierName;
  final String name;
  final String imageUrl;
  final double price;
  final String sku;
  final int quantity;
  final String packageType;
  final String? remark;
  final bool? isHot;
  final bool? isRecommend;
  final bool? isOff;
  final String? prLe;
  final String? prWi;
  final String? prHi;
  final String? ouLe;
  final String? ouWi;
  final String? ouHi;
  final String? inEn;
  final String? ouLo;

  factory CartProductEntity.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      final String s = value.toString();
      return double.tryParse(s) ?? 0.0;
    }

    int _toInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return CartProductEntity(
      id: _toInt(json['id']),
      productNumber: (json['productNumber'] ?? '').toString(),
      supplierNumber: (json['supplierNumber'] ?? '').toString(),
      supplierName: (json['supplierName'] ?? '').toString(),
      name: (json['pr_Na'] ?? '').toString(),
      imageUrl: (json['imgUrl'] ?? '').toString(),
      price: _toDouble(json['fa_Pr']),
      sku: (json['fa_No'] ?? '').toString(),
      quantity: _toInt(json['boxNumber']),
      packageType: (json['ch_Pa'] ?? '').toString(),
      remark: json['remark']?.toString(),
      isHot: json['isHot'] as bool?,
      isRecommend: json['isRecommend'] as bool?,
      isOff: json['isOff'] as bool?,
      prLe: json['pr_Le']?.toString(),
      prWi: json['pr_Wi']?.toString(),
      prHi: json['pr_Hi']?.toString(),
      ouLe: json['ou_Le']?.toString(),
      ouWi: json['ou_Wi']?.toString(),
      ouHi: json['ou_Hi']?.toString(),
      inEn: json['in_En']?.toString(),
      ouLo: json['ou_Lo']?.toString(),
    );
  }
}
