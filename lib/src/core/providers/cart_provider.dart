import 'package:flutter/material.dart';
import '../models/cart_models.dart';
import '../network/modules/cart_service.dart';
import '../../shared/models/product.dart';

class CartProvider extends ChangeNotifier {
  CartProvider();

  bool _loading = false;
  String? _error;
  final List<FactoryModel> _factories = <FactoryModel>[];

  bool get isLoading => _loading;
  String? get error => _error;
  List<FactoryModel> get factories => List<FactoryModel>.unmodifiable(_factories);

  double get totalAmount {
    double total = 0;
    for (final FactoryModel factory in _factories) {
      for (final ProductModel product in factory.products) {
        if (product.isSelected) {
          total += product.totalPrice;
        }
      }
    }
    return total;
  }

  int get selectedCount {
    int count = 0;
    for (final FactoryModel factory in _factories) {
      for (final ProductModel product in factory.products) {
        if (product.isSelected) count++;
      }
    }
    return count;
  }

  int get totalBoxes => selectedCount;
  int get totalPieces => selectedCount;

  Future<void> refreshCartList() async {
    _setLoading(true);
    try {
      final List<FactoryModel> remoteData = await CartService.fetchCartListApi();
      _factories
        ..clear()
        ..addAll(remoteData);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addToCart(ProductItem product) async {
    _setLoading(true);
    try {
      final bool ok = await CartService.addToCartApi(product.productNumber, 1);
      if (!ok) {
        _error = '加入失败';
        return;
      }
      _error = null;
      final ProductModel mapped = _mapProduct(product).copyWith(isSelected: true);
      final String factoryId =
          product.supplierNumber.isNotEmpty ? product.supplierNumber : (mapped.id.isNotEmpty ? mapped.id : 'factory');
      final String factoryName = product.maNa.isNotEmpty ? product.maNa : '厂商';
      final int factoryIndex = _factories.indexWhere((FactoryModel f) => f.id == factoryId);
      if (factoryIndex == -1) {
        _factories.add(
          FactoryModel(
            id: factoryId,
            name: factoryName,
            products: <ProductModel>[mapped],
          ),
        );
      } else {
        final FactoryModel factory = _factories[factoryIndex];
        final int productIndex = factory.products.indexWhere((ProductModel p) => p.id == mapped.id);
        if (productIndex == -1) {
          final List<ProductModel> updatedProducts = List<ProductModel>.from(factory.products)..add(mapped);
          _factories[factoryIndex] = factory.copyWith(products: updatedProducts);
        } else {
          final ProductModel existing = factory.products[productIndex];
          final ProductModel merged =
              existing.copyWith(quantity: existing.quantity + mapped.quantity, isSelected: true);
          final List<ProductModel> updatedProducts = List<ProductModel>.from(factory.products);
          updatedProducts[productIndex] = merged;
          _factories[factoryIndex] = factory.copyWith(products: updatedProducts);
        }
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void toggleSelectAll() {
    final bool isAllSelected = _factories.isNotEmpty && _factories.every((FactoryModel f) => f.isSelected);
    for (int i = 0; i < _factories.length; i++) {
      final FactoryModel factory = _factories[i];
      _factories[i] = factory.copyWith(
        products: factory.products
            .map((ProductModel p) => p.copyWith(isSelected: !isAllSelected))
            .toList(growable: false),
      );
    }
    notifyListeners();
  }

  void toggleFactory(String factoryId) {
    final int idx = _factories.indexWhere((FactoryModel f) => f.id == factoryId);
    if (idx == -1) return;
    final FactoryModel factory = _factories[idx];
    final bool newState = !factory.isSelected;
    _factories[idx] = factory.copyWith(
      products: factory.products.map((ProductModel p) => p.copyWith(isSelected: newState)).toList(growable: false),
    );
    notifyListeners();
  }

  void toggleProduct(String productId) {
    for (int fIndex = 0; fIndex < _factories.length; fIndex++) {
      final FactoryModel factory = _factories[fIndex];
      final int pIndex = factory.products.indexWhere((ProductModel p) => p.id == productId);
      if (pIndex != -1) {
        final ProductModel product = factory.products[pIndex];
        final ProductModel updated = product.copyWith(isSelected: !product.isSelected);
        final List<ProductModel> updatedProducts = List<ProductModel>.from(factory.products);
        updatedProducts[pIndex] = updated;
        _factories[fIndex] = factory.copyWith(products: updatedProducts);
        notifyListeners();
        return;
      }
    }
  }

  void updateQuantity(String productId, int quantity) {
    for (int fIndex = 0; fIndex < _factories.length; fIndex++) {
      final FactoryModel factory = _factories[fIndex];
      final int pIndex = factory.products.indexWhere((ProductModel p) => p.id == productId);
      if (pIndex != -1) {
        final ProductModel product = factory.products[pIndex];
        final ProductModel updated = product.copyWith(quantity: quantity);
        final List<ProductModel> updatedProducts = List<ProductModel>.from(factory.products);
        updatedProducts[pIndex] = updated;
        _factories[fIndex] = factory.copyWith(products: updatedProducts);
        notifyListeners();
        return;
      }
    }
  }

  ProductModel _mapProduct(ProductItem product) {
    return ProductModel(
      id: product.productNumber,
      name: product.prNa,
      sku: product.faNo,
      price: product.faPr,
      imageUrl: product.imgUrl,
      quantity: 1,
      isSelected: true,
    );
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
