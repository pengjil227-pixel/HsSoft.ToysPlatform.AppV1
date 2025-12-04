class ProductClassModel {
  final int id;
  final String name; // 对应接口的 cl_Na
  final String? img; // 对应接口的 imgUrl
  final List<ProductClassModel> children; // 子分类

  ProductClassModel({
    required this.id,
    required this.name,
    this.img,
    required this.children,
  });

  factory ProductClassModel.fromJson(Map<String, dynamic> json) {
    return ProductClassModel(
      id: json['id'] ?? 0,
      name: json['cl_Na'] ?? '',
      img: json['imgUrl'],
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => ProductClassModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
