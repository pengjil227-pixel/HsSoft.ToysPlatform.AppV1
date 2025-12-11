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

  Future<void> refreshCartList() => fetchCartList();

  Future<void> fetchCartList() async {
    _setLoading(true);
    try {
      final response = await CartService.queryPage();
      final List<CartProductEntity> entities = response.data ?? <CartProductEntity>[];
      final List<FactoryModel> grouped = _groupBySupplier(entities);
      _error = null;
      _ensureDefaultCart();
      final int activeIndex = _activeCartIndex;
      if (activeIndex != -1) {
        _carts[activeIndex] = _carts[activeIndex].copyWith(items: grouped);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

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

  Future<void> addToCart(ProductItem product) async {
    try {
      await CartService.addProduct(productNumber: product.productNumber);
      await fetchCartList();
    } catch (e) {
      _error = e.toString();
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

  Future<void> updateQuantity(String productId, int quantity) async {
    final int? recordId = int.tryParse(productId);
    if (recordId == null) return;
    _setLoading(true);
    try {
      await CartService.updateQuantity(id: recordId, boxNumber: quantity);
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
          break;
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteProducts(List<String> productIds) async {
    if (productIds.isEmpty) return;
    final List<int> ids = productIds.map(int.tryParse).whereType<int>().toList();
    if (ids.isEmpty) return;
    _setLoading(true);
    try {
      await CartService.batchDelete(ids: ids);
      _ensureDefaultCart();
      final List<FactoryModel> factories = List<FactoryModel>.from(activeCart.items);
      for (int i = factories.length - 1; i >= 0; i--) {
        final FactoryModel factory = factories[i];
        final List<ProductModel> remaining =
            factory.products.where((ProductModel p) => !productIds.contains(p.id)).toList();
        if (remaining.isEmpty) {
          factories.removeAt(i);
        } else {
          factories[i] = factory.copyWith(products: remaining);
        }
      }
      _replaceActiveCartItems(factories);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteProduct(String productId) async {
    final int? id = int.tryParse(productId);
    if (id == null) return;
    _setLoading(true);
    try {
      await CartService.deleteItem(id: id);
      _ensureDefaultCart();
      final List<FactoryModel> factories = List<FactoryModel>.from(activeCart.items);
      for (int i = factories.length - 1; i >= 0; i--) {
        final FactoryModel factory = factories[i];
        final List<ProductModel> remaining =
            factory.products.where((ProductModel p) => p.id != productId).toList();
        if (remaining.isEmpty) {
          factories.removeAt(i);
        } else {
          factories[i] = factory.copyWith(products: remaining);
        }
      }
      _replaceActiveCartItems(factories);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<FactoryModel> _groupBySupplier(List<CartProductEntity> entities) {
    final Map<String, List<CartProductEntity>> grouped = <String, List<CartProductEntity>>{};
    for (final CartProductEntity entity in entities) {
      final String key = entity.supplierNumber;
      grouped.putIfAbsent(key, () => <CartProductEntity>[]).add(entity);
    }
    final List<FactoryModel> factories = <FactoryModel>[];
    grouped.forEach((String supplierNumber, List<CartProductEntity> products) {
      final String supplierName = products.isNotEmpty ? products.first.supplierName : '';
      factories.add(
        FactoryModel(
          id: supplierNumber,
          name: supplierName,
          products: products.map(_mapEntityToProductModel).toList(),
        ),
      );
    });
    return factories;
  }

  ProductModel _mapEntityToProductModel(CartProductEntity entity) {
    return ProductModel(
      id: entity.id.toString(),
      name: entity.name,
      sku: entity.sku,
      price: entity.price,
      imageUrl: entity.imageUrl,
      quantity: entity.quantity,
      isSelected: true,
    );
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
