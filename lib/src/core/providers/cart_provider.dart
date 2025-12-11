import 'package:flutter/material.dart';
import '../models/cart_models.dart';
import '../network/modules/cart_service.dart';
import '../../shared/models/product.dart';

class CartProvider extends ChangeNotifier {
  CartProvider() {
    _ensureDefaultCart();
  }

  bool _loading = false;
  String? _error;
  final List<CartInfo> _carts = <CartInfo>[];
  String? _activeCartId;

  bool get isLoading => _loading;
  String? get error => _error;
  List<CartInfo> get cartList => List<CartInfo>.unmodifiable(_carts);
  String? get activeCartId => _activeCartId;
  CartInfo get activeCart {
    _ensureDefaultCart();
    return _carts.firstWhere((CartInfo c) => c.id == _activeCartId, orElse: () => _carts.first);
  }

  /// 保持向后兼容，仍然提供当前车商品列表的只读访问
  List<FactoryModel> get factories => List<FactoryModel>.unmodifiable(activeCart.items);

  double get totalAmount {
    double total = 0;
    for (final FactoryModel factory in activeCart.items) {
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
    for (final FactoryModel factory in activeCart.items) {
      for (final ProductModel product in factory.products) {
        if (product.isSelected) count++;
      }
    }
    return count;
  }

  int get totalBoxes => selectedCount;
  int get totalPieces => selectedCount;

  CartInfo createNewCart(String name) {
    final CartInfo newCart = CartInfo(
      id: _generateCartId(),
      name: name,
      items: <FactoryModel>[],
    );
    _carts.add(newCart);
    if (_activeCartId == null) {
      _activeCartId = newCart.id;
    }
    notifyListeners();
    return newCart;
  }

  void switchActiveCart(String id) {
    if (_activeCartId == id) return;
    final bool exists = _carts.any((CartInfo c) => c.id == id);
    if (!exists) return;
    _activeCartId = id;
    notifyListeners();
  }

  void updateCartName(String id, String name) {
    final int index = _carts.indexWhere((CartInfo c) => c.id == id);
    if (index == -1) return;
    _carts[index] = _carts[index].copyWith(name: name);
    notifyListeners();
  }

  void removeCarts(List<String> ids) {
    if (ids.isEmpty) return;
    final bool removedActive = ids.contains(_activeCartId);
    _carts.removeWhere((CartInfo c) => ids.contains(c.id));
    if (_carts.isEmpty) {
      _activeCartId = null;
      _ensureDefaultCart();
    } else if (removedActive || _activeCartId == null || !_carts.any((CartInfo c) => c.id == _activeCartId)) {
      _activeCartId = _carts.first.id;
    }
    notifyListeners();
  }

  Future<void> refreshCartList() async {
    _setLoading(true);
    try {
      final List<FactoryModel> remoteData = await CartService.fetchCartListApi();
      _error = null;
      _ensureDefaultCart();
      final int activeIndex = _activeCartIndex;
      if (activeIndex != -1) {
        _carts[activeIndex] = _carts[activeIndex].copyWith(items: remoteData);
      } else if (_carts.isNotEmpty) {
        _activeCartId = _carts.first.id;
        _carts[0] = _carts[0].copyWith(items: remoteData);
      }
      notifyListeners();
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
      _ensureDefaultCart();
      final List<FactoryModel> factories = List<FactoryModel>.from(activeCart.items);
      final ProductModel mapped = _mapProduct(product).copyWith(isSelected: true);
      final String factoryId =
          product.supplierNumber.isNotEmpty ? product.supplierNumber : (mapped.id.isNotEmpty ? mapped.id : 'factory');
      final String factoryName = product.maNa.isNotEmpty ? product.maNa : '厂商';
      final int factoryIndex = factories.indexWhere((FactoryModel f) => f.id == factoryId);
      if (factoryIndex == -1) {
        factories.add(
          FactoryModel(
            id: factoryId,
            name: factoryName,
            products: <ProductModel>[mapped],
          ),
        );
      } else {
        final FactoryModel factory = factories[factoryIndex];
        final int productIndex = factory.products.indexWhere((ProductModel p) => p.id == mapped.id);
        if (productIndex == -1) {
          final List<ProductModel> updatedProducts = List<ProductModel>.from(factory.products)..add(mapped);
          factories[factoryIndex] = factory.copyWith(products: updatedProducts);
        } else {
          final ProductModel existing = factory.products[productIndex];
          final ProductModel merged =
              existing.copyWith(quantity: existing.quantity + mapped.quantity, isSelected: true);
          final List<ProductModel> updatedProducts = List<ProductModel>.from(factory.products);
          updatedProducts[productIndex] = merged;
          factories[factoryIndex] = factory.copyWith(products: updatedProducts);
        }
      }
      _replaceActiveCartItems(factories);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void toggleSelectAll() {
    _ensureDefaultCart();
    final List<FactoryModel> factories = List<FactoryModel>.from(activeCart.items);
    final bool isAllSelected = factories.isNotEmpty && factories.every((FactoryModel f) => f.isSelected);
    for (int i = 0; i < factories.length; i++) {
      final FactoryModel factory = factories[i];
      factories[i] = factory.copyWith(
        products: factory.products
            .map((ProductModel p) => p.copyWith(isSelected: !isAllSelected))
            .toList(growable: false),
      );
    }
    _replaceActiveCartItems(factories);
  }

  void toggleFactory(String factoryId) {
    _ensureDefaultCart();
    final List<FactoryModel> factories = List<FactoryModel>.from(activeCart.items);
    final int idx = factories.indexWhere((FactoryModel f) => f.id == factoryId);
    if (idx == -1) return;
    final FactoryModel factory = factories[idx];
    final bool newState = !factory.isSelected;
    factories[idx] = factory.copyWith(
      products: factory.products.map((ProductModel p) => p.copyWith(isSelected: newState)).toList(growable: false),
    );
    _replaceActiveCartItems(factories);
  }

  void toggleProduct(String productId) {
    _ensureDefaultCart();
    final List<FactoryModel> factories = List<FactoryModel>.from(activeCart.items);
    for (int fIndex = 0; fIndex < factories.length; fIndex++) {
      final FactoryModel factory = factories[fIndex];
      final int pIndex = factory.products.indexWhere((ProductModel p) => p.id == productId);
      if (pIndex != -1) {
        final ProductModel product = factory.products[pIndex];
        final ProductModel updated = product.copyWith(isSelected: !product.isSelected);
        final List<ProductModel> updatedProducts = List<ProductModel>.from(factory.products);
        updatedProducts[pIndex] = updated;
        factories[fIndex] = factory.copyWith(products: updatedProducts);
        _replaceActiveCartItems(factories);
        return;
      }
    }
  }

  void updateQuantity(String productId, int quantity) {
    _ensureDefaultCart();
    final List<FactoryModel> factories = List<FactoryModel>.from(activeCart.items);
    for (int fIndex = 0; fIndex < factories.length; fIndex++) {
      final FactoryModel factory = factories[fIndex];
      final int pIndex = factory.products.indexWhere((ProductModel p) => p.id == productId);
      if (pIndex != -1) {
        final ProductModel product = factory.products[pIndex];
        final ProductModel updated = product.copyWith(quantity: quantity);
        final List<ProductModel> updatedProducts = List<ProductModel>.from(factory.products);
        updatedProducts[pIndex] = updated;
        factories[fIndex] = factory.copyWith(products: updatedProducts);
        _replaceActiveCartItems(factories);
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

  void _replaceActiveCartItems(List<FactoryModel> items) {
    final int activeIndex = _activeCartIndex;
    if (activeIndex == -1) return;
    _carts[activeIndex] = _carts[activeIndex].copyWith(items: items);
    notifyListeners();
  }

  int get _activeCartIndex => _carts.indexWhere((CartInfo c) => c.id == _activeCartId);

  void _ensureDefaultCart() {
    if (_carts.isEmpty) {
      final CartInfo defaultCart = CartInfo(
        id: _generateCartId(),
        name: '默认择样车',
        items: <FactoryModel>[],
      );
      _carts.add(defaultCart);
      _activeCartId = defaultCart.id;
    } else if (_activeCartId == null || !_carts.any((CartInfo c) => c.id == _activeCartId)) {
      _activeCartId = _carts.first.id;
    }
  }

  String _generateCartId() => 'cart-${DateTime.now().microsecondsSinceEpoch}-${_carts.length + 1}';
}
