# Cremosos E-commerce - Flutter Edition

Sistema completo de gestión de estados para e-commerce especializado en arroz con leche y fresas con cremas, convertido de React+TypeScript a Flutter+Dart.

## 🚀 Características

- ✅ **Arquitectura limpia** con separación de responsabilidades
- ✅ **Gestión de estado** con Riverpod
- ✅ **Modelos de datos** completos con serialización JSON
- ✅ **Persistencia** con SharedPreferences
- ✅ **Navegación** fluida entre pantallas
- ✅ **UI Material Design 3** moderna y atractiva
- ✅ **Código 100% Dart** tipo-seguro

## 📁 Estructura del Proyecto

```
flutter_cremosos/
├── lib/
│   ├── main.dart                 # Punto de entrada de la aplicación
│   ├── models/                   # Modelos de datos
│   │   ├── product.dart          # Product, Topping, Review, ProductCategory
│   │   ├── user.dart             # User, Address, UserPreferences
│   │   ├── cart.dart             # Cart, CartItem, Order
│   │   └── reports.dart          # Banner, SalesReport, etc.
│   ├── providers/                # Gestión de estado con Riverpod
│   │   ├── auth_provider.dart    # Autenticación
│   │   ├── cart_provider.dart    # Carrito de compras
│   │   ├── products_provider.dart # Productos
│   │   └── reports_provider.dart # Reportes
│   ├── data/                     # Datos mock
│   │   ├── products_data.dart
│   │   ├── users_data.dart
│   │   └── reports_data.dart
│   ├── screens/                  # Pantallas de la aplicación
│   │   ├── home_screen.dart
│   │   ├── auth_screen.dart
│   │   ├── products_screen.dart
│   │   ├── product_detail_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── profile_screen.dart
│   │   └── reports_screen.dart
│   ├── widgets/                  # Widgets reutilizables
│   │   ├── product_card.dart
│   │   ├── cart_item_widget.dart
│   │   └── banner_carousel.dart
│   └── utils/                    # Utilidades y helpers
│       ├── constants.dart
│       └── formatters.dart
├── pubspec.yaml                  # Dependencias del proyecto
└── README.md                     # Este archivo
```

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework UI multiplataforma
- **Dart**: Lenguaje de programación
- **Riverpod**: Gestión de estado reactivo
- **SharedPreferences**: Persistencia local de datos
- **GoRouter**: Navegación declarativa
- **GoogleFonts**: Fuentes personalizadas
- **CachedNetworkImage**: Carga y caché de imágenes

## 📦 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0 # Gestión de estado
  shared_preferences: ^2.2.2 # Persistencia
  go_router: ^12.1.1 # Navegación
  google_fonts: ^6.1.0 # Fuentes
  cached_network_image: ^3.3.0 # Imágenes
  intl: ^0.18.1 # Internacionalización
  uuid: ^4.2.1 # Generación de IDs
```

## 🚀 Instalación y Ejecución

### Requisitos Previos

1. **Flutter SDK** (versión 3.0.0 o superior)

   - Descargar desde: https://flutter.dev/docs/get-started/install
   - Verificar instalación: `flutter doctor`

2. **Android Studio** o **VS Code** con extensiones de Flutter

3. **Emulador Android** o **Simulador iOS** (o dispositivo físico)

### Pasos de Instalación

1. **Navegar a la carpeta del proyecto:**

   ```powershell
   cd "c:\Users\User\Desktop\implementacion gestion datos\flutter_cremosos"
   ```

2. **Instalar dependencias:**

   ```powershell
   flutter pub get
   ```

3. **Verificar dispositivos disponibles:**

   ```powershell
   flutter devices
   ```

4. **Ejecutar la aplicación:**

   ```powershell
   # En modo debug
   flutter run

   # En modo release (mejor rendimiento)
   flutter run --release

   # En un dispositivo específico
   flutter run -d <device_id>
   ```

### Ejecución en Web

```powershell
flutter run -d chrome
```

### Ejecución en Windows

```powershell
flutter run -d windows
```

## 📱 Pantallas Disponibles

### 1. 🏠 Home Screen

- Banner promocional con gradientes
- Productos destacados en grid
- Navegación rápida a categorías

### 2. 🔐 Auth Screen

- Login de usuarios
- Registro de nuevos usuarios
- Recuperación de contraseña
- Validaciones completas

### 3. 🛍️ Products Screen

- Catálogo completo de productos
- Filtros por categoría, precio, rating
- Búsqueda por texto
- Ordenamiento múltiple
- Paginación

### 4. 📋 Product Detail Screen

- Información detallada del producto
- Galería de imágenes
- Selección de toppings personalizables
- Reseñas y valoraciones
- Agregar al carrito con opciones

### 5. 🛒 Cart Screen

- Visualización de items del carrito
- Modificación de cantidades
- Aplicación de cupones de descuento
- Cálculo automático de totales
- Proceso de checkout

### 6. 👤 Profile Screen

- Datos del usuario
- Historial de pedidos
- Direcciones guardadas
- Preferencias y configuración
- Métodos de pago

### 7. 📊 Reports Screen (Admin)

- Dashboard de ventas
- Gráficos de rendimiento
- Productos más vendidos
- Análisis de inventario
- Métricas de usuarios

## 🎨 Tema y Diseño

- **Material Design 3** con esquema de colores personalizado
- **Gradientes** en headers y banners
- **Tarjetas** con bordes redondeados y sombras
- **Animaciones** suaves en transiciones
- **Responsive** para diferentes tamaños de pantalla
- **Dark Mode** (opcional, implementar en settings)

## 🔧 Configuración Adicional

### Configurar Firebase (Opcional)

Para habilitar autenticación y base de datos en tiempo real:

```powershell
flutter pub add firebase_core firebase_auth cloud_firestore
flutterfire configure
```

### Configurar notificaciones Push (Opcional)

```powershell
flutter pub add firebase_messaging flutter_local_notifications
```

## 🧪 Testing

```powershell
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Ver reporte de cobertura
genhtml coverage/lcov.info -o coverage/html
```

## 📦 Build para Producción

### Android APK

```powershell
flutter build apk --release
```

### Android App Bundle (recomendado para Play Store)

```powershell
flutter build appbundle --release
```

### iOS

```powershell
flutter build ios --release
```

### Web

```powershell
flutter build web --release
```

### Windows

```powershell
flutter build windows --release
```

## 🔄 Migración desde React+TypeScript

Este proyecto es una conversión completa del sistema React+TypeScript original:

| React/TypeScript                    | Flutter/Dart                         |
| ----------------------------------- | ------------------------------------ |
| `useState`, `useEffect`             | `StateNotifier`, `ConsumerWidget`    |
| Custom Hooks (`useAuth`, `useCart`) | Riverpod Providers                   |
| `localStorage`                      | `SharedPreferences`                  |
| TypeScript interfaces               | Dart classes con `fromJson`/`toJson` |
| React Router                        | GoRouter                             |
| CSS/Styled Components               | Material Design widgets              |
| `fetch`/`axios`                     | `http` package                       |

### Principales Diferencias

1. **Gestión de Estado**: Hooks → Riverpod Providers
2. **UI**: JSX/Components → Widgets
3. **Tipado**: TypeScript → Dart (null-safety)
4. **Persistencia**: localStorage → SharedPreferences
5. **Navegación**: React Router → GoRouter
6. **Styling**: CSS → Widget properties

## 📝 Datos Mock

Todos los datos mock del proyecto React han sido convertidos:

- ✅ 7 productos de Arroz con Leche
- ✅ 8 productos de Fresas con Crema
- ✅ 4 productos de Postres Especiales
- ✅ 2 productos de Bebidas Cremosas
- ✅ 14 toppings personalizables
- ✅ 4 usuarios mock (3 customers, 1 admin)
- ✅ 2 pedidos de ejemplo
- ✅ 4 reseñas de productos
- ✅ 4 banners promocionales
- ✅ Reportes de ventas, inventario y usuarios

## 🤝 Contribución

Este es un proyecto de demostración. Las mejoras sugeridas incluyen:

- [ ] Implementar datos mock completos
- [ ] Añadir animaciones avanzadas
- [ ] Implementar modo oscuro
- [ ] Añadir internacionalización (i18n)
- [ ] Conectar con backend real
- [ ] Implementar pagos con pasarelas reales
- [ ] Añadir geolocalización para entregas
- [ ] Implementar chat de soporte
- [ ] Añadir notificaciones push
- [ ] Optimizar rendimiento de listas

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👨‍💻 Autor

Proyecto convertido desde React+TypeScript a Flutter+Dart como demostración de arquitectura de estados en Flutter.

## 🌟 Características Próximas

- [ ] Integración con API REST
- [ ] Autenticación con Firebase
- [ ] Pasarela de pagos real
- [ ] Notificaciones en tiempo real
- [ ] Geolocalización y mapas
- [ ] Modo offline con sincronización
- [ ] Análisis con Firebase Analytics
- [ ] Tests unitarios y de integración
- [ ] CI/CD con GitHub Actions

---

**¡Disfruta desarrollando con Flutter! 🎉🍓**
