# Documentación de Estados - Cremosos E-Commerce

Este documento proporciona una documentación detallada de todos los estados implementados en la aplicación Cremosos E-Commerce, incluyendo ejemplos de código, casos de uso y mejores prácticas.

## Índice

1. [AuthState - Estado de Autenticación](#authstate)
2. [CartState - Estado del Carrito](#cartstate)
3. [ProductsState - Estado de Productos](#productsstate)
4. [ReportsState - Estado de Reportes](#reportsstate)
5. [NavigationState - Estado de Navegación](#navigationstate)
6. [ProfileState - Estado de Perfil](#profilestate)
7. [Patrones y Mejores Prácticas](#patrones)

---

## AuthState - Estado de Autenticación

### Ubicación
`lib/providers/auth_provider.dart`

### Descripción Completa
El AuthState es el estado central de autenticación que controla el acceso a la aplicación. Utiliza un StateNotifier para gestionar las operaciones asíncronas de login, registro y logout.

### Estructura del Estado

```dart
class AuthState {
  final User? user;           // Usuario actual (null = no autenticado)
  final bool isLoading;       // true durante operaciones async
  final String? errorMessage; // Mensaje de error si ocurre

  AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  // Constructor para copiar estado con cambios
  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
```

### StateNotifier

```dart
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Login - Autenticar usuario existente
  Future<void> login(String email, String password) async {
    // 1. Cambiar a estado loading
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 2. Simular llamada a API (en producción: await api.login())
      await Future.delayed(Duration(seconds: 1));

      // 3. Buscar usuario en datos mock
      final user = mockUsers.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => throw Exception('Credenciales inválidas'),
      );

      // 4. Actualizar estado con usuario autenticado
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      // 5. Manejar error
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Register - Crear nuevo usuario
  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(Duration(seconds: 1));

      // Verificar si el email ya existe
      final exists = mockUsers.any((u) => u.email == email);
      if (exists) {
        throw Exception('El email ya está registrado');
      }

      // Crear nuevo usuario
      final newUser = User(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        role: UserRole.customer,
      );

      // En producción: guardar en backend
      mockUsers.add(newUser);

      state = state.copyWith(user: newUser, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Logout - Cerrar sesión
  void logout() {
    state = AuthState(); // Resetear a estado inicial
  }

  // Limpiar mensajes de error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
```

### Provider

```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Provider computado para verificar autenticación
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).user != null;
});
```

### Uso en UI

#### 1. Pantalla de Login

```dart
class AuthScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // Mostrar indicador de carga
    if (authState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Mostrar error si existe
    if (authState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.errorMessage!)),
        );
        authNotifier.clearError();
      });
    }

    return Scaffold(
      body: LoginForm(
        onLogin: (email, password) {
          authNotifier.login(email, password);
        },
      ),
    );
  }
}
```

#### 2. Navegación Condicional

```dart
class AppRoot extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return MaterialApp(
      home: isAuthenticated ? MainNavigator() : AuthScreen(),
    );
  }
}
```

#### 3. Botón de Logout

```dart
ElevatedButton(
  onPressed: () {
    ref.read(authProvider.notifier).logout();
  },
  child: Text('Cerrar Sesión'),
);
```

### Casos de Uso

1. **Login exitoso**: Usuario ingresa credenciales correctas
2. **Login fallido**: Usuario ingresa credenciales incorrectas
3. **Registro de nuevo usuario**: Usuario crea cuenta nueva
4. **Logout**: Usuario cierra sesión
5. **Sesión persistente**: Mantener sesión después de cerrar app (con SharedPreferences)

### Mejoras Futuras

- [ ] Integrar con Firebase Auth o backend real
- [ ] Implementar refresh tokens
- [ ] Agregar autenticación con redes sociales (Google, Facebook)
- [ ] Implementar recuperación de contraseña
- [ ] Agregar verificación de email
- [ ] Implementar 2FA (autenticación de dos factores)

---

## CartState - Estado del Carrito

### Ubicación
`lib/providers/cart_provider.dart`

### Descripción Completa
El CartState gestiona el carrito de compras, incluyendo la adición de productos, modificación de cantidades, selección de toppings y cálculo de totales con impuestos.

### Estructura del Estado

```dart
class CartState {
  final List<Map<String, dynamic>> items;

  CartState({this.items = const []});

  // Cada item tiene la estructura:
  // {
  //   'product': Product,
  //   'quantity': int,
  //   'toppings': List<Product>,
  //   'subtotal': double,
  // }

  CartState copyWith({List<Map<String, dynamic>>? items}) {
    return CartState(items: items ?? this.items);
  }

  // Computed properties
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item['subtotal']);
  }

  double get tax {
    return subtotal * 0.19; // IVA 19% Colombia
  }

  double get total {
    return subtotal + tax;
  }

  int get itemCount {
    return items.length;
  }

  int get totalQuantity {
    return items.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }
}
```

### StateNotifier

```dart
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  // Agregar item al carrito
  void addItem(Product product, int quantity, List<Product> toppings) {
    // Calcular precio de toppings
    final toppingsPrice = toppings.fold(0.0, (sum, t) => sum + t.price);
    
    // Calcular subtotal del item
    final itemSubtotal = (product.price + toppingsPrice) * quantity;

    // Crear nuevo item
    final newItem = {
      'product': product,
      'quantity': quantity,
      'toppings': toppings,
      'subtotal': itemSubtotal,
    };

    // Verificar si el producto ya existe en el carrito
    final existingIndex = state.items.indexWhere(
      (item) => item['product'].id == product.id,
    );

    List<Map<String, dynamic>> updatedItems;

    if (existingIndex >= 0) {
      // Actualizar cantidad si ya existe
      updatedItems = List.from(state.items);
      final existingItem = updatedItems[existingIndex];
      final newQuantity = existingItem['quantity'] + quantity;
      updatedItems[existingIndex] = {
        ...existingItem,
        'quantity': newQuantity,
        'subtotal': (product.price + toppingsPrice) * newQuantity,
      };
    } else {
      // Agregar como nuevo item
      updatedItems = [...state.items, newItem];
    }

    state = state.copyWith(items: updatedItems);
  }

  // Remover item del carrito
  void removeItem(String productId) {
    final updatedItems = state.items
        .where((item) => item['product'].id != productId)
        .toList();
    state = state.copyWith(items: updatedItems);
  }

  // Actualizar cantidad de un item
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item['product'].id == productId) {
        final product = item['product'] as Product;
        final toppings = item['toppings'] as List<Product>;
        final toppingsPrice = toppings.fold(0.0, (sum, t) => sum + t.price);
        
        return {
          ...item,
          'quantity': newQuantity,
          'subtotal': (product.price + toppingsPrice) * newQuantity,
        };
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  // Vaciar carrito
  void clearCart() {
    state = CartState();
  }

  // Aplicar cupón de descuento
  void applyCoupon(String couponCode) {
    // Implementar lógica de cupones
    // Por ahora solo ejemplo
    if (couponCode == 'DESCUENTO10') {
      // Aplicar 10% de descuento
    }
  }
}
```

### Provider

```dart
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Provider para contar items
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

// Provider para total
final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).total;
});
```

### Uso en UI

#### 1. Agregar Producto al Carrito

```dart
class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int quantity = 1;
    List<Product> selectedToppings = [];

    return Scaffold(
      body: Column(
        children: [
          // UI del producto...
          
          ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).addItem(
                product,
                quantity,
                selectedToppings,
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Agregado al carrito')),
              );
            },
            child: Text('Agregar al Carrito'),
          ),
        ],
      ),
    );
  }
}
```

#### 2. Mostrar Badge de Carrito

```dart
Stack(
  children: [
    Icon(Icons.shopping_cart),
    Positioned(
      right: 0,
      top: 0,
      child: Consumer(
        builder: (context, ref, child) {
          final itemCount = ref.watch(cartItemCountProvider);
          if (itemCount == 0) return SizedBox.shrink();
          
          return Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$itemCount',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          );
        },
      ),
    ),
  ],
);
```

#### 3. Pantalla del Carrito

```dart
class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    if (cartState.items.isEmpty) {
      return Center(child: Text('El carrito está vacío'));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Carrito')),
      body: Column(
        children: [
          // Lista de items
          Expanded(
            child: ListView.builder(
              itemCount: cartState.items.length,
              itemBuilder: (context, index) {
                final item = cartState.items[index];
                final product = item['product'] as Product;
                final quantity = item['quantity'] as int;
                final subtotal = item['subtotal'] as double;

                return CartItemWidget(
                  product: product,
                  quantity: quantity,
                  subtotal: subtotal,
                  onQuantityChanged: (newQty) {
                    cartNotifier.updateQuantity(product.id, newQty);
                  },
                  onRemove: () {
                    cartNotifier.removeItem(product.id);
                  },
                );
              },
            ),
          ),

          // Resumen de totales
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal:'),
                      Text('\$${cartState.subtotal.toStringAsFixed(0)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('IVA (19%):'),
                      Text('\$${cartState.tax.toStringAsFixed(0)}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '\$${cartState.total.toStringAsFixed(0)}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Botón de checkout
          ElevatedButton(
            onPressed: () => _showCheckoutDialog(context, ref),
            child: Text('Proceder al Pago'),
          ),
        ],
      ),
    );
  }
}
```

### Casos de Uso

1. **Agregar producto simple**: Sin toppings
2. **Agregar producto con toppings**: Con extras personalizados
3. **Modificar cantidad**: Aumentar/disminuir cantidad
4. **Eliminar producto**: Quitar del carrito
5. **Aplicar cupón**: Descuento en total
6. **Checkout completo**: Procesar orden y vaciar carrito

### Mejoras Futuras

- [ ] Persistencia con SharedPreferences
- [ ] Sincronización con backend
- [ ] Límite de stock en tiempo real
- [ ] Sistema de cupones más robusto
- [ ] Cálculo de envío según ubicación
- [ ] Productos relacionados (upselling)

---

## ProductsState - Estado de Productos

### Ubicación
`lib/providers/products_provider.dart`

### Descripción Completa
El ProductsState gestiona el catálogo completo de productos, filtrado por categorías, búsqueda por texto y ordenamiento por diferentes criterios.

### Estructura del Estado

```dart
class ProductsState {
  final List<Product> allProducts;       // Catálogo completo
  final List<Product> filteredProducts;  // Productos después de filtros
  final ProductCategory? selectedCategory;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  ProductsState({
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  ProductsState copyWith({
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    ProductCategory? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductsState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
```

### StateNotifier

```dart
class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier() : super(ProductsState()) {
    loadProducts();
  }

  // Cargar todos los productos
  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);

    try {
      // Simular carga desde API
      await Future.delayed(Duration(milliseconds: 500));

      // En producción: final products = await api.getProducts();
      final products = allProducts; // Mock data

      state = state.copyWith(
        allProducts: products,
        filteredProducts: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Filtrar por categoría
  void filterByCategory(ProductCategory? category) {
    if (category == null) {
      // Mostrar todos
      state = state.copyWith(
        selectedCategory: null,
        filteredProducts: state.allProducts,
      );
      return;
    }

    final filtered = state.allProducts
        .where((p) => p.category == category)
        .toList();

    state = state.copyWith(
      selectedCategory: category,
      filteredProducts: filtered,
    );
  }

  // Buscar productos por texto
  void searchProducts(String query) {
    if (query.isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        filteredProducts: state.selectedCategory != null
            ? state.allProducts
                .where((p) => p.category == state.selectedCategory)
                .toList()
            : state.allProducts,
      );
      return;
    }

    final lowerQuery = query.toLowerCase();
    var filtered = state.allProducts.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();

    // Aplicar filtro de categoría si está activo
    if (state.selectedCategory != null) {
      filtered = filtered
          .where((p) => p.category == state.selectedCategory)
          .toList();
    }

    state = state.copyWith(
      searchQuery: query,
      filteredProducts: filtered,
    );
  }

  // Ordenar productos
  void sortProducts(SortType sortType) {
    final sorted = List<Product>.from(state.filteredProducts);

    switch (sortType) {
      case SortType.priceAsc:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceDesc:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.ratingDesc:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    state = state.copyWith(filteredProducts: sorted);
  }

  // Obtener producto por ID
  Product? getProductById(String id) {
    try {
      return state.allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Limpiar filtros
  void clearFilters() {
    state = state.copyWith(
      selectedCategory: null,
      searchQuery: '',
      filteredProducts: state.allProducts,
    );
  }
}

enum SortType {
  priceAsc,
  priceDesc,
  nameAsc,
  ratingDesc,
}
```

### Provider

```dart
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier();
});

// Provider para obtener categorías únicas
final categoriesProvider = Provider<List<ProductCategory>>((ref) {
  final products = ref.watch(productsProvider).allProducts;
  return products.map((p) => p.category).toSet().toList();
});
```

### Uso en UI

#### 1. Lista de Productos

```dart
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);

    if (productsState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, ref),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, ref),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: productsState.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = productsState.filteredProducts[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}
```

#### 2. Búsqueda de Productos

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Buscar productos...',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (query) {
    ref.read(productsProvider.notifier).searchProducts(query);
  },
);
```

#### 3. Filtro por Categoría

```dart
DropdownButton<ProductCategory?>(
  value: ref.watch(productsProvider).selectedCategory,
  hint: Text('Todas las categorías'),
  items: [
    DropdownMenuItem(value: null, child: Text('Todas')),
    ...ProductCategory.values.map((category) {
      return DropdownMenuItem(
        value: category,
        child: Text(category.displayName),
      );
    }),
  ],
  onChanged: (category) {
    ref.read(productsProvider.notifier).filterByCategory(category);
  },
);
```

### Casos de Uso

1. **Explorar catálogo completo**: Ver todos los productos
2. **Filtrar por categoría**: Ver solo una categoría
3. **Buscar por nombre**: Encontrar producto específico
4. **Ordenar por precio**: Más barato/más caro primero
5. **Ordenar por rating**: Mejor calificados primero
6. **Combinar filtros**: Categoría + búsqueda

---

## Patrones y Mejores Prácticas

### 1. Inmutabilidad del Estado

```dart
// ❌ INCORRECTO - Mutación directa
state.items.add(newItem);

// ✅ CORRECTO - Crear nuevo estado
state = state.copyWith(items: [...state.items, newItem]);
```

### 2. Manejo de Estados Asíncronos

```dart
Future<void> loadData() async {
  // 1. Estado de carga
  state = state.copyWith(isLoading: true, errorMessage: null);

  try {
    // 2. Operación asíncrona
    final data = await fetchData();

    // 3. Estado exitoso
    state = state.copyWith(data: data, isLoading: false);
  } catch (e) {
    // 4. Estado de error
    state = state.copyWith(isLoading: false, errorMessage: e.toString());
  }
}
```

### 3. Separación de Responsabilidades

```dart
// UI Layer - Solo renderiza
class MyWidget extends ConsumerWidget {
  Widget build(context, ref) {
    final state = ref.watch(myProvider);
    return Text(state.value);
  }
}

// State Management Layer - Lógica de negocio
class MyNotifier extends StateNotifier<MyState> {
  void updateValue(String newValue) {
    // Validaciones, transformaciones, etc.
    state = state.copyWith(value: newValue);
  }
}

// Data Layer - Acceso a datos
class MyRepository {
  Future<Data> fetchData() async {
    // Llamadas HTTP, queries DB, etc.
  }
}
```

### 4. Testing de Estados

```dart
test('AuthProvider - Login exitoso', () async {
  final container = ProviderContainer();
  final notifier = container.read(authProvider.notifier);

  // Act
  await notifier.login('test@example.com', 'password');

  // Assert
  final state = container.read(authProvider);
  expect(state.user, isNotNull);
  expect(state.user?.email, 'test@example.com');
  expect(state.isLoading, false);
  expect(state.errorMessage, null);
});
```

### 5. Optimización de Rendimiento

```dart
// Provider específico para evitar reconstrucciones innecesarias
final userNameProvider = Provider<String>((ref) {
  return ref.watch(authProvider.select((state) => state.user?.name ?? ''));
});

// En el widget
Text(ref.watch(userNameProvider)); // Solo se reconstruye si el nombre cambia
```

---

## Conclusión

Esta documentación cubre todos los estados implementados en Cremosos E-Commerce. Cada estado sigue las mejores prácticas de Flutter y Riverpod, garantizando:

- ✅ Código mantenible y escalable
- ✅ Separación clara de responsabilidades
- ✅ Fácil testing
- ✅ Rendimiento optimizado
- ✅ Experiencia de usuario fluida

Para más información, consulta:
- [Documentación oficial de Riverpod](https://riverpod.dev/)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- README.md del proyecto
