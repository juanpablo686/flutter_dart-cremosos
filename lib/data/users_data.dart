// data/users_data.dart - Datos mock de usuarios y órdenes

import '../models/user.dart';
import '../models/cart.dart';
import '../models/product.dart';

/// Usuarios de prueba
final List<User> mockUsers = [
  User(
    id: 'user-001',
    email: 'juan.perez@email.com',
    name: 'Juan Pérez',
    phone: '+57 300 123 4567',
    role: UserRole.customer,
    createdAt: DateTime(2023, 6, 15),
    avatar: 'https://i.pravatar.cc/150?img=12',
    addresses: [
      Address(
        id: 'addr-001',
        label: 'Casa',
        street: 'Calle 45 #12-34',
        city: 'Bogotá',
        state: 'Cundinamarca',
        postalCode: '110111',
        country: 'Colombia',
        type: AddressType.home,
        isDefault: true,
        recipientName: 'Juan Pérez',
        recipientPhone: '+57 300 123 4567',
      ),
      Address(
        id: 'addr-002',
        label: 'Oficina',
        street: 'Carrera 7 #85-21',
        city: 'Bogotá',
        state: 'Cundinamarca',
        postalCode: '110221',
        country: 'Colombia',
        type: AddressType.work,
        isDefault: false,
        recipientName: 'Juan Pérez',
        recipientPhone: '+57 300 123 4567',
        additionalInfo: 'Torre B, Piso 4, Oficina 405',
      ),
    ],
    preferences: UserPreferences(
      newsletter: true,
      pushNotifications: true,
      emailNotifications: true,
      smsNotifications: false,
      theme: 'light',
      language: 'es',
    ),
    paymentMethods: [
      PaymentMethod(
        id: 'pm-001',
        type: 'credit_card',
        last4: '4242',
        brand: 'Visa',
        expiryMonth: 12,
        expiryYear: 2025,
        isDefault: true,
        holderName: 'Juan Pérez',
      ),
    ],
  ),
  User(
    id: 'user-002',
    email: 'maria.garcia@email.com',
    name: 'María García',
    phone: '+57 310 987 6543',
    role: UserRole.customer,
    createdAt: DateTime(2023, 8, 22),
    avatar: 'https://i.pravatar.cc/150?img=45',
    addresses: [
      Address(
        id: 'addr-003',
        label: 'Casa',
        street: 'Avenida 15 #89-23',
        city: 'Medellín',
        state: 'Antioquia',
        postalCode: '050001',
        country: 'Colombia',
        type: AddressType.home,
        isDefault: true,
        recipientName: 'María García',
        recipientPhone: '+57 310 987 6543',
      ),
    ],
    preferences: UserPreferences(
      newsletter: true,
      pushNotifications: true,
      emailNotifications: true,
      smsNotifications: true,
      theme: 'dark',
      language: 'es',
    ),
    paymentMethods: [
      PaymentMethod(
        id: 'pm-002',
        type: 'debit_card',
        last4: '8888',
        brand: 'Mastercard',
        expiryMonth: 8,
        expiryYear: 2026,
        isDefault: true,
        holderName: 'María García',
      ),
    ],
  ),
  User(
    id: 'user-003',
    email: 'carlos.rodriguez@email.com',
    name: 'Carlos Rodríguez',
    phone: '+57 320 456 7890',
    role: UserRole.customer,
    createdAt: DateTime(2023, 10, 5),
    avatar: 'https://i.pravatar.cc/150?img=33',
    addresses: [
      Address(
        id: 'addr-004',
        label: 'Apartamento',
        street: 'Calle 100 #18-45',
        city: 'Cali',
        state: 'Valle del Cauca',
        postalCode: '760001',
        country: 'Colombia',
        type: AddressType.home,
        isDefault: true,
        recipientName: 'Carlos Rodríguez',
        recipientPhone: '+57 320 456 7890',
        additionalInfo: 'Apartamento 302, Edificio Palmeras',
      ),
    ],
    preferences: UserPreferences(
      newsletter: false,
      pushNotifications: true,
      emailNotifications: false,
      smsNotifications: false,
      theme: 'light',
      language: 'es',
    ),
    paymentMethods: [
      PaymentMethod(
        id: 'pm-003',
        type: 'pse',
        last4: '0123',
        brand: 'Bancolombia',
        isDefault: true,
        holderName: 'Carlos Rodríguez',
      ),
    ],
  ),
  User(
    id: 'user-admin',
    email: 'admin@cremosos.com',
    name: 'Administrador',
    phone: '+57 300 000 0000',
    role: UserRole.admin,
    createdAt: DateTime(2023, 1, 1),
    avatar: 'https://i.pravatar.cc/150?img=68',
    addresses: [
      Address(
        id: 'addr-admin',
        label: 'Sede Principal',
        street: 'Carrera 50 #100-25',
        city: 'Bogotá',
        state: 'Cundinamarca',
        postalCode: '110111',
        country: 'Colombia',
        type: AddressType.work,
        isDefault: true,
        recipientName: 'Cremosos Admin',
        recipientPhone: '+57 300 000 0000',
      ),
    ],
    preferences: UserPreferences(
      newsletter: true,
      pushNotifications: true,
      emailNotifications: true,
      smsNotifications: true,
      theme: 'light',
      language: 'es',
    ),
    paymentMethods: [],
  ),
];

/// Órdenes de ejemplo
final List<Order> mockOrders = [
  Order(
    id: 'order-001',
    userId: 'user-001',
    items: [
      CartItem(
        productId: 'acl-001',
        quantity: 2,
        selectedToppings: ['top-003', 'top-009'],
      ),
      CartItem(
        productId: 'fcc-001',
        quantity: 1,
        selectedToppings: ['top-005'],
      ),
    ],
    subtotal: 14100,
    tax: 2256,
    shipping: 3000,
    discount: 1410,
    total: 17946,
    status: OrderStatus.delivered,
    createdAt: DateTime(2024, 1, 15, 10, 30),
    deliveredAt: DateTime(2024, 1, 15, 12, 45),
    shippingAddress: Address(
      id: 'addr-001',
      label: 'Casa',
      street: 'Calle 45 #12-34',
      city: 'Bogotá',
      state: 'Cundinamarca',
      postalCode: '110111',
      country: 'Colombia',
      type: AddressType.home,
      isDefault: true,
      recipientName: 'Juan Pérez',
      recipientPhone: '+57 300 123 4567',
    ),
    paymentMethod: PaymentMethod(
      id: 'pm-001',
      type: 'credit_card',
      last4: '4242',
      brand: 'Visa',
      expiryMonth: 12,
      expiryYear: 2025,
      isDefault: true,
      holderName: 'Juan Pérez',
    ),
    couponCode: 'BIENVENIDO10',
    notes: 'Por favor, tocar el timbre',
    trackingNumber: 'CREM-2024-001',
  ),
  Order(
    id: 'order-002',
    userId: 'user-002',
    items: [
      CartItem(
        productId: 'pe-001',
        quantity: 1,
        selectedToppings: [],
      ),
      CartItem(
        productId: 'bc-001',
        quantity: 3,
        selectedToppings: ['top-002', 'top-014'],
      ),
    ],
    subtotal: 22900,
    tax: 3664,
    shipping: 0,
    discount: 0,
    total: 26564,
    status: OrderStatus.processing,
    createdAt: DateTime(2024, 1, 18, 14, 20),
    shippingAddress: Address(
      id: 'addr-003',
      label: 'Casa',
      street: 'Avenida 15 #89-23',
      city: 'Medellín',
      state: 'Antioquia',
      postalCode: '050001',
      country: 'Colombia',
      type: AddressType.home,
      isDefault: true,
      recipientName: 'María García',
      recipientPhone: '+57 310 987 6543',
    ),
    paymentMethod: PaymentMethod(
      id: 'pm-002',
      type: 'debit_card',
      last4: '8888',
      brand: 'Mastercard',
      expiryMonth: 8,
      expiryYear: 2026,
      isDefault: true,
      holderName: 'María García',
    ),
    trackingNumber: 'CREM-2024-002',
  ),
];

/// Reviews de productos
final List<Review> mockReviews = [
  Review(
    id: 'rev-001',
    productId: 'acl-001',
    userId: 'user-001',
    userName: 'Juan Pérez',
    userAvatar: 'https://i.pravatar.cc/150?img=12',
    rating: 5,
    comment:
        'Delicioso! El mejor arroz con leche que he probado. La textura es perfecta y el sabor a canela es increíble.',
    createdAt: DateTime(2024, 1, 16, 9, 15),
    helpful: 12,
    verified: true,
  ),
  Review(
    id: 'rev-002',
    productId: 'fcc-001',
    userId: 'user-002',
    userName: 'María García',
    userAvatar: 'https://i.pravatar.cc/150?img=45',
    rating: 5,
    comment:
        'Las fresas estaban súper frescas y la crema natural es de excelente calidad. Lo recomiendo 100%.',
    createdAt: DateTime(2024, 1, 10, 15, 30),
    helpful: 8,
    verified: true,
  ),
  Review(
    id: 'rev-003',
    productId: 'pe-001',
    userId: 'user-003',
    userName: 'Carlos Rodríguez',
    userAvatar: 'https://i.pravatar.cc/150?img=33',
    rating: 5,
    comment:
        'El tiramisú es auténtico italiano. El café espresso le da un sabor increíble. Volveré a ordenar.',
    createdAt: DateTime(2024, 1, 12, 18, 45),
    helpful: 15,
    verified: true,
  ),
  Review(
    id: 'rev-004',
    productId: 'fcc-003',
    userId: 'user-001',
    userName: 'Juan Pérez',
    userAvatar: 'https://i.pravatar.cc/150?img=12',
    rating: 4,
    comment:
        'Muy buena combinación de fresas y chocolate. La porción es generosa. Solo le faltó un poquito más de crema.',
    createdAt: DateTime(2024, 1, 8, 11, 20),
    helpful: 5,
    verified: false,
  ),
];

/// Funciones de utilidad
User? getUserById(String id) {
  try {
    return mockUsers.firstWhere((user) => user.id == id);
  } catch (e) {
    return null;
  }
}

User? getUserByEmail(String email) {
  try {
    return mockUsers.firstWhere((user) => user.email == email);
  } catch (e) {
    return null;
  }
}

List<Order> getOrdersByUserId(String userId) {
  return mockOrders.where((order) => order.userId == userId).toList();
}

List<Review> getReviewsByProductId(String productId) {
  return mockReviews.where((review) => review.productId == productId).toList();
}

List<Review> getReviewsByUserId(String userId) {
  return mockReviews.where((review) => review.userId == userId).toList();
}

/// Credenciales de prueba para login
final Map<String, String> testCredentials = {
  'juan.perez@email.com': 'password123',
  'maria.garcia@email.com': 'password123',
  'carlos.rodriguez@email.com': 'password123',
  'admin@cremosos.com': 'admin123',
};

/// Simulación de respuesta de autenticación
AuthResponse simulateLogin(String email, String password) {
  if (testCredentials[email] == password) {
    final user = getUserByEmail(email);
    if (user != null) {
      return AuthResponse(
        user: user,
        token: 'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_${user.id}',
        expiresIn: 3600,
      );
    }
  }
  throw Exception('Credenciales inválidas');
}
