import 'dart:async';

import '../../models/cart_models.dart';

class CartService {
  const CartService._();

  /// TODO: 替换为真实接口调用。
  static Future<bool> addToCartApi(String productId, int quantity) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return true;
  }

  /// TODO: 替换为真实接口调用。
  static Future<List<FactoryModel>> fetchCartListApi() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return <FactoryModel>[
      FactoryModel(
        id: 'factory-demo',
        name: '示例玩具厂',
        products: <ProductModel>[
          ProductModel(
            id: 'P-001',
            name: '充气涂鸦长颈鹿玩偶',
            sku: '888-1',
            price: 12.5,
            imageUrl: '',
            quantity: 1,
          ),
        ],
      ),
    ];
  }
}
