// providers/cart_provider.dart - Provider del Carrito

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart.dart';
import '../data/products_data.dart';

// Cupones disponibles
class Coupon {
  final String code;
  final String description;
  final double discount; // Porcentaje de descuento
  final int? minPurchase; // Mínimo de compra requerido
  final DateTime? expiryDate;

  Coupon({
    required this.code,
    required this.description,
    required this.discount,
    this.minPurchase,
    this.expiryDate,
  });

  bool isValid(int subtotal) {
    if (expiryDate != null && DateTime.now().isAfter(expiryDate!)) {
      return false;
    }
    if (minPurchase != null && subtotal < minPurchase!) {
      return false;
    }
    return true;
  }
}

// Cupones mock
final availableCoupons = [
  Coupon(
    code: 'BIENVENIDO10',
    description: '10% de descuento en tu primera compra',
    discount: 10,
  ),
  Coupon(
    code: 'CREMOSOS15',
    description: '15% de descuento en compras mayores a \$20,000',
    discount: 15,
    minPurchase: 20000,
  ),
  Coupon(
    code: 'FAMILIA20',
    description: '20% de descuento en compras mayores a \$30,000',
    discount: 20,
    minPurchase: 30000,
  ),
  Coupon(
    code: 'TOPPINGS5',
    description: '5% de descuento en productos con toppings',
    discount: 5,
  ),
];

// Notificador del carrito
class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(Cart.empty()) {
    _loadCart();
  }

  // Cargar carrito guardado
  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('cart');
      if (cartJson != null) {
        final data = json.decode(cartJson);
        state = Cart.fromJson(data);
        _recalculate();
      }
    } catch (e) {
      // Ignorar errores de carga
    }
  }

  // Guardar carrito
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart', json.encode(state.toJson()));
    } catch (e) {
      // Ignorar errores de guardado
    }
  }

  // Agregar item
  void addItem(String productId,
      {int quantity = 1, List<String> toppings = const []}) {
    final product = getProductById(productId);
    if (product == null) return;

    final existingIndex = state.items.indexWhere(
      (item) =>
          item.productId == productId &&
          _listEquals(item.selectedToppings, toppings),
    );

    List<CartItem> updatedItems;

    if (existingIndex >= 0) {
      // Actualizar cantidad
      updatedItems = List.from(state.items);
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      // Agregar nuevo item
      updatedItems = [
        ...state.items,
        CartItem(
          productId: productId,
          quantity: quantity,
          selectedToppings: toppings,
        ),
      ];
    }

    state = state.copyWith(items: updatedItems);
    _recalculate();
    _saveCart();
  }

  // Remover item
  void removeItem(String productId, {List<String> toppings = const []}) {
    final updatedItems = state.items
        .where(
          (item) => !(item.productId == productId &&
              _listEquals(item.selectedToppings, toppings)),
        )
        .toList();

    state = state.copyWith(items: updatedItems);
    _recalculate();
    _saveCart();
  }

  // Actualizar cantidad
  void updateQuantity(String productId, int quantity,
      {List<String> toppings = const []}) {
    if (quantity <= 0) {
      removeItem(productId, toppings: toppings);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.productId == productId &&
          _listEquals(item.selectedToppings, toppings)) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
    _recalculate();
    _saveCart();
  }

  // Aplicar cupón
  void applyCoupon(String code) {
    final coupon = availableCoupons.firstWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
      orElse: () => throw Exception('Cupón no válido'),
    );

    if (!coupon.isValid(state.subtotal)) {
      if (coupon.minPurchase != null) {
        throw Exception('Compra mínima de \$${coupon.minPurchase} requerida');
      }
      throw Exception('Cupón expirado');
    }

    state = state.copyWith(couponCode: code);
    _recalculate();
    _saveCart();
  }

  // Remover cupón
  void removeCoupon() {
    state = state.copyWith(couponCode: null);
    _recalculate();
    _saveCart();
  }

  // Limpiar carrito
  void clear() {
    state = Cart.empty();
    _saveCart();
  }

  // Recalcular totales
  void _recalculate() {
    int subtotal = 0;

    for (final item in state.items) {
      final product = getProductById(item.productId);
      if (product != null) {
        int itemPrice = product.effectivePrice.round() * item.quantity;

        // Agregar precio de toppings
        for (final toppingId in item.selectedToppings) {
          final topping = availableToppings.firstWhere(
            (t) => t.id == toppingId,
            orElse: () => availableToppings.first,
          );
          itemPrice += topping.price.round() * item.quantity;
        }

        subtotal += itemPrice;
      }
    }

    // Calcular descuento
    int discount = 0;
    if (state.couponCode != null) {
      final coupon = availableCoupons.firstWhere(
        (c) => c.code.toUpperCase() == state.couponCode!.toUpperCase(),
        orElse: () => availableCoupons.first,
      );
      discount = (subtotal * coupon.discount / 100).round();
    }

    // Calcular impuesto (16%)
    final taxableAmount = subtotal - discount;
    final tax = (taxableAmount * 0.16).round();

    // Calcular envío (gratis si es mayor a $25,000, sino $3,000)
    final shipping = (subtotal - discount) >= 25000 ? 0 : 3000;

    // Total
    final total = subtotal - discount + tax + shipping;

    state = state.copyWith(
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      shipping: shipping,
      total: total,
    );
  }

  // Comparar listas
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// Provider del carrito
final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});

// Provider de cantidad de items
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

// Provider de subtotal formateado
final cartSubtotalProvider = Provider<String>((ref) {
  final subtotal = ref.watch(cartProvider).subtotal;
  return '\$${subtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
});

// Provider de total formateado
final cartTotalProvider = Provider<String>((ref) {
  final total = ref.watch(cartProvider).total;
  return '\$${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
});

// Provider de items con detalles de producto
final cartItemsWithDetailsProvider =
    Provider<List<Map<String, dynamic>>>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.items.map((item) {
    final product = getProductById(item.productId);
    final toppings = item.selectedToppings
        .map((id) => availableToppings.firstWhere((t) => t.id == id))
        .toList();

    return {
      'item': item,
      'product': product,
      'toppings': toppings,
    };
  }).toList();
});
