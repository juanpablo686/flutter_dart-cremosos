# Demo Funcional - Guía de Navegación

Este documento proporciona una guía paso a paso de cómo navegar por todas las funcionalidades de la aplicación Cremosos E-Commerce.

## 🎯 Objetivo de la Demo

Demostrar la navegación completa entre todos los estados implementados en la aplicación, mostrando:
- Transiciones de estado
- Manejo de datos
- Interacciones de usuario
- Flujos completos de negocio

---

## 📱 Flujo Completo de Usuario

### PASO 1: Inicio de la Aplicación

**Estado Inicial**: `AuthState(user: null)`

```
┌─────────────────────────────────────┐
│         PANTALLA DE LOGIN           │
│                                     │
│   📧 Email: ___________________    │
│   🔒 Password: _______________     │
│                                     │
│   [ Iniciar Sesión ]               │
│   [ Registrarse ]                  │
└─────────────────────────────────────┘
```

**Acciones disponibles**:
- Ingresar credenciales
- Presionar "Iniciar Sesión"
- Presionar "Registrarse" para crear cuenta

**Credenciales de prueba**:
- Admin: `admin@cremosos.com` / `admin123`
- Usuario: `juan@example.com` / `password123`

---

### PASO 2: Autenticación Exitosa

**Acción**: Usuario ingresa credenciales correctas y presiona "Iniciar Sesión"

**Transición de Estado**:
```
AuthState(user: null, isLoading: false)
         ↓ login()
AuthState(user: null, isLoading: true)  ← Muestra CircularProgressIndicator
         ↓ API response
AuthState(user: User, isLoading: false)
```

**Navegación**:
```
AuthScreen → MainNavigator (BottomNavigationBar activo)
```

**UI Update**:
- Desaparece pantalla de login
- Aparece navegación inferior con 4 tabs
- Se carga pantalla de inicio

---

### PASO 3: Pantalla de Inicio (Home)

**Estado Activo**: `ProductsState(filteredProducts: [140])`

```
┌─────────────────────────────────────┐
│           CREMOSOS 🍨                │
│                                     │
│   ← [Arroz con Leche] →            │
│   ← [Fresas con Crema] →           │
│   ← [Postres Especiales] →         │
│                                     │
│   PRODUCTOS DESTACADOS              │
│   ┌───┐ ┌───┐ ┌───┐ ┌───┐        │
│   │ 1 │ │ 2 │ │ 3 │ │ 4 │        │
│   └───┘ └───┘ └───┘ └───┘        │
│                                     │
│  [🏠] [📦] [🛒] [👤]              │
└─────────────────────────────────────┘
```

**Elementos visibles**:
1. **Carrusel de categorías**: Con flechas de navegación
2. **Grid de productos destacados**: 4 productos por fila
3. **BottomNavigationBar**: 4 tabs (Home, Productos, Carrito, Perfil)
4. **Badge en carrito**: Muestra cantidad de items (inicialmente 0)

**Acciones disponibles**:
- Navegar por categorías con las flechas ← →
- Hacer clic en una categoría para ver productos
- Hacer clic en un producto para ver detalles
- Navegar a otras secciones con el BottomNav

---

### PASO 4: Explorar Categoría

**Acción**: Usuario hace clic en "Arroz con Leche"

**Transición de Estado**:
```
ProductsState(
  selectedCategory: null,
  filteredProducts: [140]
)
         ↓ filterByCategory(arrozConLeche)
ProductsState(
  selectedCategory: arrozConLeche,
  filteredProducts: [20]
)
```

**UI Update**:
```
┌─────────────────────────────────────┐
│      ARROZ CON LECHE (20)           │
│                                     │
│   [Buscar...] [Filtros] [Orden]    │
│                                     │
│   ┌─────┐ ┌─────┐                  │
│   │ ACL │ │ ACL │                  │
│   │  1  │ │  2  │                  │
│   │$18k │ │$20k │                  │
│   │⭐4.8│ │⭐4.9│                  │
│   └─────┘ └─────┘                  │
│   ┌─────┐ ┌─────┐                  │
│   │ ACL │ │ ACL │                  │
│   │  3  │ │  4  │                  │
│   └─────┘ └─────┘                  │
└─────────────────────────────────────┘
```

**Elementos visibles**:
- Título con cantidad de productos (20)
- Barra de búsqueda
- Botones de filtros y ordenamiento
- Grid de productos (2 columnas)
- Cada card muestra: imagen, nombre, precio, rating

---

### PASO 5: Ver Detalle de Producto

**Acción**: Usuario hace clic en "Arroz con Leche Tradicional"

**Navegación**: `ProductsScreen → ProductDetailScreen(product)`

```
┌─────────────────────────────────────┐
│  ← Arroz con Leche Tradicional      │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │      [IMAGEN PRODUCTO]      │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Arroz con Leche Tradicional        │
│  ⭐⭐⭐⭐⭐ 4.8 (24 reseñas)       │
│  $18,000                            │
│                                     │
│  Delicioso arroz con leche...       │
│                                     │
│  TOPPINGS DISPONIBLES:              │
│  ☐ Canela ($2,000)                 │
│  ☐ Uvas Pasas ($1,500)             │
│  ☐ Coco Rallado ($2,500)           │
│                                     │
│  CANTIDAD: [-] 1 [+]                │
│                                     │
│  [ AGREGAR AL CARRITO - $18,000 ]  │
│                                     │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━       │
│  RESEÑAS:                           │
│  👤 Juan Pérez ⭐⭐⭐⭐⭐           │
│     "¡Excelente! Muy cremoso..."   │
└─────────────────────────────────────┘
```

**Interacciones disponibles**:
1. Seleccionar toppings (checkboxes)
2. Ajustar cantidad (botones - y +)
3. Ver precio actualizado en tiempo real
4. Leer reseñas de otros usuarios
5. Agregar al carrito

---

### PASO 6: Agregar Producto al Carrito

**Acción**: 
1. Usuario selecciona toppings: Canela ($2,000)
2. Aumenta cantidad a 2
3. Presiona "Agregar al Carrito"

**Cálculo en tiempo real**:
```
Precio base: $18,000
Topping (Canela): $2,000
Subtotal por unidad: $20,000
Cantidad: 2
Total del item: $40,000
```

**Transición de Estado**:
```
CartState(items: [], total: 0)
         ↓ addItem(product, 2, [canela])
CartState(
  items: [{
    product: Arroz con Leche,
    quantity: 2,
    toppings: [Canela],
    subtotal: 40000
  }],
  total: 40000
)
```

**UI Feedback**:
- SnackBar: "✅ Producto agregado al carrito"
- Badge del carrito actualiza: 0 → 1
- Botón cambia temporalmente de color

---

### PASO 7: Navegar al Carrito

**Acción**: Usuario presiona el ícono del carrito en BottomNavigationBar

**Navegación**: `ProductDetailScreen → CartScreen`

```
┌─────────────────────────────────────┐
│         🛒 CARRITO DE COMPRAS        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [IMG] Arroz con Leche       │   │
│  │       Tradicional           │   │
│  │       + Canela              │   │
│  │       Cantidad: 2           │   │
│  │       [-] 2 [+]        🗑️   │   │
│  │       $40,000               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ RESUMEN DEL PEDIDO          │   │
│  │                             │   │
│  │ Subtotal:        $40,000    │   │
│  │ IVA (19%):        $7,600    │   │
│  │ ─────────────────────────   │   │
│  │ TOTAL:           $47,600    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   PROCEDER AL PAGO          │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

**Funcionalidades del carrito**:
1. **Ver items**: Lista completa con detalles
2. **Modificar cantidad**: Botones - y +
3. **Eliminar items**: Botón de basura 🗑️
4. **Ver totales**: Subtotal, IVA (19%), Total
5. **Proceder al pago**: Botón de checkout

---

### PASO 8: Proceso de Checkout

**Acción**: Usuario presiona "Proceder al Pago"

**Diálogo de Confirmación**:
```
┌─────────────────────────────────────┐
│     CONFIRMAR PEDIDO                │
│                                     │
│  RESUMEN:                           │
│  • Arroz con Leche x2               │
│    + Canela                         │
│                                     │
│  INFORMACIÓN DE ENTREGA:            │
│  📍 Calle 123 #45-67                │
│     Bogotá, Colombia                │
│                                     │
│  👤 Juan Pérez                      │
│  📱 +57 300 123 4567                │
│                                     │
│  💳 FORMA DE PAGO:                  │
│  Visa **** 1234                     │
│                                     │
│  TOTAL A PAGAR: $47,600             │
│                                     │
│  [ CANCELAR ] [ CONFIRMAR ]         │
└─────────────────────────────────────┘
```

**Acción**: Usuario presiona "Confirmar"

**Flujo de procesamiento**:
```
1. Mostrar loading
   CartState(isProcessing: true)

2. Simular procesamiento (1 segundo)
   [CircularProgressIndicator]

3. Generar número de orden
   Order #12345

4. Limpiar carrito
   CartState(items: [], total: 0)

5. Mostrar confirmación
   Dialog: "✅ Pedido confirmado"
```

**Mensaje de éxito**:
```
┌─────────────────────────────────────┐
│     ✅ PEDIDO CONFIRMADO             │
│                                     │
│  Su pedido #12345 ha sido           │
│  procesado exitosamente.            │
│                                     │
│  Recibirá un correo de              │
│  confirmación en:                   │
│  juan@example.com                   │
│                                     │
│  Tiempo estimado de entrega:        │
│  45-60 minutos                      │
│                                     │
│  [ Ver Mis Pedidos ] [ Cerrar ]     │
└─────────────────────────────────────┘
```

---

### PASO 9: Pantalla de Perfil

**Acción**: Usuario navega a la pestaña Perfil

**Navegación**: `CartScreen → ProfileScreen`

```
┌─────────────────────────────────────┐
│         👤 MI PERFIL                 │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  [AVATAR]  Juan Pérez       │   │
│  │            juan@example.com │   │
│  │            ⭐ Cliente VIP    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌──────┐ ┌──────┐ ┌──────┐       │
│  │ 15   │ │ 12   │ │  3   │       │
│  │Pedidos│ │Entreg│ │Proceso│      │
│  └──────┘ └──────┘ └──────┘       │
│                                     │
│  💰 Total Gastado: $450,000         │
│                                     │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━       │
│                                     │
│  ✏️  Editar Perfil              →   │
│  📍 Mis Direcciones             →   │
│  💳 Métodos de Pago             →   │
│  ❤️  Favoritos                  →   │
│  📦 Mis Pedidos                 →   │
│  🔔 Notificaciones              →   │
│  🔒 Cambiar Contraseña          →   │
│  ❓ Centro de Ayuda             →   │
│  🚪 Cerrar Sesión                   │
└─────────────────────────────────────┘
```

**Estadísticas mostradas**:
- Total de pedidos realizados
- Pedidos entregados
- Pedidos en proceso
- Total gastado en la plataforma

**Acciones disponibles** (8 diálogos interactivos):

---

### PASO 10: Editar Perfil

**Acción**: Usuario presiona "Editar Perfil"

```
┌─────────────────────────────────────┐
│     EDITAR PERFIL                   │
│                                     │
│  Nombre:                            │
│  [Juan Pérez____________]           │
│                                     │
│  Teléfono:                          │
│  [+57 300 123 4567______]           │
│                                     │
│  [ CANCELAR ] [ GUARDAR ]           │
└─────────────────────────────────────┘
```

---

### PASO 11: Gestión de Direcciones

**Acción**: Usuario presiona "Mis Direcciones"

```
┌─────────────────────────────────────┐
│     MIS DIRECCIONES                 │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 Casa (Predeterminada)    │   │
│  │ Calle 123 #45-67            │   │
│  │ Bogotá, Cundinamarca        │   │
│  │ 110111                      │   │
│  │                    [Editar] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 Oficina                  │   │
│  │ Carrera 7 #32-10            │   │
│  │ Bogotá, Cundinamarca        │   │
│  │ 110211                      │   │
│  │              [Eliminar]     │   │
│  └─────────────────────────────┘   │
│                                     │
│  [ + AGREGAR NUEVA DIRECCIÓN ]      │
│  [ CERRAR ]                         │
└─────────────────────────────────────┘
```

**Funcionalidades**:
- Ver todas las direcciones guardadas
- Marcar dirección como predeterminada
- Editar direcciones existentes
- Eliminar direcciones
- Agregar nuevas direcciones

---

### PASO 12: Métodos de Pago

**Acción**: Usuario presiona "Métodos de Pago"

```
┌─────────────────────────────────────┐
│     MÉTODOS DE PAGO                 │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💳 Visa terminada en 1234   │   │
│  │ Vence: 12/25                │   │
│  │              [Predeterminada]│   │
│  │                    [Eliminar]│   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💳 Mastercard **** 5678     │   │
│  │ Vence: 08/26                │   │
│  │                    [Eliminar]│   │
│  └─────────────────────────────┘   │
│                                     │
│  [ + AGREGAR TARJETA ]              │
│  [ CERRAR ]                         │
└─────────────────────────────────────┘
```

---

### PASO 13: Configurar Notificaciones

**Acción**: Usuario presiona "Notificaciones"

```
┌─────────────────────────────────────┐
│     PREFERENCIAS DE NOTIFICACIONES  │
│                                     │
│  Notificaciones Push          [ON]  │
│  Recibir alertas en tiempo real     │
│                                     │
│  Email de Pedidos             [ON]  │
│  Confirmaciones y actualizaciones   │
│                                     │
│  Promociones                  [OFF] │
│  Ofertas y descuentos especiales    │
│                                     │
│  Newsletter                   [ON]  │
│  Novedades y recetas                │
│                                     │
│  [ GUARDAR CAMBIOS ]                │
└─────────────────────────────────────┘
```

---

### PASO 14: Dashboard de Reportes (Solo Admin)

**Acción**: Usuario admin navega a pestaña "Reportes"

```
┌─────────────────────────────────────┐
│     📊 DASHBOARD DE VENTAS           │
│                                     │
│  [ Día ] [ Semana ] [Mes] [ Año ]   │
│                                     │
│  ┌──────┐ ┌──────┐ ┌──────┐       │
│  │ $15M │ │ 234  │ │$64.1k│       │
│  │Ingresos│ │Órdenes│ │Promedio│    │
│  └──────┘ └──────┘ └──────┘       │
│                                     │
│  VENTAS POR MES                     │
│  ▁▂▄▆█▇▅▃▂▁▂▅                      │
│                                     │
│  CATEGORÍAS MÁS VENDIDAS            │
│  ████████ Arroz con Leche (35%)     │
│  ██████ Fresas con Crema (25%)      │
│  ████ Postres Especiales (18%)      │
│  ███ Bebidas Cremosas (12%)         │
│  ██ Otros (10%)                     │
│                                     │
│  TOP 5 PRODUCTOS                    │
│  1. Arroz con Leche Tradicional     │
│  2. Fresas con Crema Clásica        │
│  3. Brownie con Helado              │
│  4. Café Cremoso                    │
│  5. Tres Leches Especial            │
└─────────────────────────────────────┘
```

**Métricas mostradas**:
- Ingresos totales del período
- Número de órdenes
- Valor promedio por orden
- Gráfico de ventas por mes
- Distribución por categorías
- Top productos más vendidos

---

### PASO 15: Cerrar Sesión

**Acción**: Usuario presiona "Cerrar Sesión" en Perfil

**Diálogo de confirmación**:
```
┌─────────────────────────────────────┐
│     CERRAR SESIÓN                   │
│                                     │
│  ¿Está seguro que desea             │
│  cerrar sesión?                     │
│                                     │
│  [ CANCELAR ] [ CONFIRMAR ]         │
└─────────────────────────────────────┘
```

**Transición de Estado**:
```
AuthState(user: User)
         ↓ logout()
AuthState(user: null)
```

**Navegación**:
```
ProfileScreen → AuthScreen
```

**UI Update**:
- Desaparece MainNavigator
- Aparece pantalla de Login
- Carrito se limpia
- Estados se resetean

---

## 🎯 Resumen de Estados Navegados

### Estados Principales:

1. ✅ **AuthState**: No autenticado → Autenticando → Autenticado → Logout
2. ✅ **ProductsState**: Todos → Filtrado por categoría → Búsqueda
3. ✅ **CartState**: Vacío → Con items → Checkout → Procesando → Confirmado
4. ✅ **ProfileState**: Ver datos → Editar perfil → Gestionar direcciones
5. ✅ **ReportsState**: Ver dashboard → Filtrar por período
6. ✅ **NavigationState**: Home → Productos → Carrito → Perfil

### Transiciones Demostradas:

- Login exitoso ✅
- Filtrado de productos ✅
- Agregar al carrito ✅
- Modificar cantidades ✅
- Checkout completo ✅
- Gestión de perfil ✅
- Visualización de reportes ✅
- Logout ✅

---

## 📹 Grabar Demo en Video

Para grabar la demo funcional:

1. **Iniciar aplicación**:
   ```bash
   flutter run -d chrome
   ```

2. **Usar herramienta de grabación**:
   - Windows: Xbox Game Bar (Win + G)
   - OBS Studio (gratuito)
   - Screen-o-Matic

3. **Seguir este script**:
   - 0:00-0:30: Mostrar login y autenticación
   - 0:30-1:00: Navegar por categorías
   - 1:00-1:30: Ver detalle de producto y agregar al carrito
   - 1:30-2:00: Proceso de checkout
   - 2:00-2:30: Explorar perfil y sus opciones
   - 2:30-3:00: Ver dashboard de reportes
   - 3:00-3:30: Cerrar sesión

4. **Exportar y subir**:
   - Formato: MP4, 1080p
   - Duración: 3-4 minutos
   - Subir a: YouTube, GitHub (como release)

---

## ✅ Checklist de Demo Completa

- [ ] Mostrar pantalla de login
- [ ] Autenticación exitosa
- [ ] Navegación por carrusel de categorías
- [ ] Filtrado de productos
- [ ] Búsqueda de productos
- [ ] Ver detalle de producto
- [ ] Seleccionar toppings
- [ ] Agregar producto al carrito
- [ ] Badge del carrito actualizado
- [ ] Ver carrito con items
- [ ] Modificar cantidad en carrito
- [ ] Ver cálculo de totales (subtotal + IVA)
- [ ] Proceso de checkout
- [ ] Confirmación de pedido
- [ ] Carrito vacío después de checkout
- [ ] Ver perfil de usuario
- [ ] Editar información personal
- [ ] Gestionar direcciones
- [ ] Ver métodos de pago
- [ ] Configurar notificaciones
- [ ] Ver historial de pedidos
- [ ] Dashboard de reportes (admin)
- [ ] Cerrar sesión
- [ ] Volver a pantalla de login

---

**Total de pantallas navegadas**: 8
**Total de estados modificados**: 6
**Total de interacciones demostradas**: 25+
**Tiempo estimado de demo**: 3-4 minutos

🎉 **Demo completa que muestra toda la funcionalidad de la aplicación!**
