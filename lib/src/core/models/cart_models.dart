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
