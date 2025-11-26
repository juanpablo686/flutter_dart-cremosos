// data/reports_data.dart - Datos mock de reportes y banners

import '../models/reports.dart';

/// Banners activos para el home
final List<Banner> activeBanners = [
  Banner(
    id: 'banner-001',
    title: '¡Nueva Temporada de Fresas!',
    subtitle: 'Frescas y deliciosas, directo del campo',
    image: 'https://images.unsplash.com/photo-1464454709131-ffd692591ee5?w=800',
    backgroundColor: '#FF6B9D',
    textColor: '#FFFFFF',
    ctaText: 'Ver productos',
    ctaLink: '/products?category=fresas-con-crema',
    isActive: true,
    priority: 1,
    startDate: DateTime(2024, 1, 1),
    endDate: DateTime(2024, 3, 31),
  ),
  Banner(
    id: 'banner-002',
    title: 'Arroz con Leche Premium',
    subtitle: 'Ahora con 20% de descuento',
    image: 'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=800',
    backgroundColor: '#9C27B0',
    textColor: '#FFFFFF',
    ctaText: 'Aprovechar oferta',
    ctaLink: '/products/acl-003',
    isActive: true,
    priority: 2,
    startDate: DateTime(2024, 1, 10),
    endDate: DateTime(2024, 2, 15),
  ),
  Banner(
    id: 'banner-003',
    title: 'Postres Especiales',
    subtitle: 'Tiramisú, Panna Cotta y más deliciosas opciones',
    image: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800',
    backgroundColor: '#FF9800',
    textColor: '#FFFFFF',
    ctaText: 'Descubrir',
    ctaLink: '/products?category=postres-especiales',
    isActive: true,
    priority: 3,
    startDate: DateTime(2024, 1, 5),
    endDate: DateTime(2024, 12, 31),
  ),
  Banner(
    id: 'banner-004',
    title: 'Bebidas Cremosas',
    subtitle: 'Batidos y smoothies refrescantes',
    image: 'https://images.unsplash.com/photo-1553979459-d2229ba7433a?w=800',
    backgroundColor: '#00BCD4',
    textColor: '#FFFFFF',
    ctaText: 'Ver bebidas',
    ctaLink: '/products?category=bebidas-cremosas',
    isActive: true,
    priority: 4,
    startDate: DateTime(2024, 1, 1),
    endDate: DateTime(2024, 6, 30),
  ),
];

/// Datos de ventas para reportes (últimos 7 días)
final List<DailySales> dailySalesData = [
  DailySales(
    date: DateTime(2024, 1, 12),
    sales: 145000,
    orders: 18,
    averageTicket: 8056,
  ),
  DailySales(
    date: DateTime(2024, 1, 13),
    sales: 198000,
    orders: 24,
    averageTicket: 8250,
  ),
  DailySales(
    date: DateTime(2024, 1, 14),
    sales: 167000,
    orders: 21,
    averageTicket: 7952,
  ),
  DailySales(
    date: DateTime(2024, 1, 15),
    sales: 234000,
    orders: 29,
    averageTicket: 8069,
  ),
  DailySales(
    date: DateTime(2024, 1, 16),
    sales: 189000,
    orders: 23,
    averageTicket: 8217,
  ),
  DailySales(
    date: DateTime(2024, 1, 17),
    sales: 276000,
    orders: 34,
    averageTicket: 8118,
  ),
  DailySales(
    date: DateTime(2024, 1, 18),
    sales: 312000,
    orders: 38,
    averageTicket: 8211,
  ),
];

/// Top productos más vendidos
final List<TopProduct> topProducts = [
  TopProduct(
    productId: 'fcc-001',
    productName: 'Fresas con Crema Natural',
    productImage:
        'https://images.unsplash.com/photo-1464454709131-ffd692591ee5?w=200',
    sales: 1245000,
    units: 287,
    trend: 12.5,
  ),
  TopProduct(
    productId: 'acl-001',
    productName: 'Arroz con Leche Clásico',
    productImage:
        'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=200',
    sales: 1098000,
    units: 244,
    trend: 8.3,
  ),
  TopProduct(
    productId: 'pe-001',
    productName: 'Tiramisú Cremoso',
    productImage:
        'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=200',
    sales: 892000,
    units: 105,
    trend: 15.7,
  ),
  TopProduct(
    productId: 'fcc-003',
    productName: 'Fresas con Crema y Chocolate',
    productImage:
        'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=200',
    sales: 745000,
    units: 143,
    trend: -3.2,
  ),
  TopProduct(
    productId: 'bc-001',
    productName: 'Batido de Fresa Cremoso',
    productImage:
        'https://images.unsplash.com/photo-1553979459-d2229ba7433a?w=200',
    sales: 623000,
    units: 130,
    trend: 5.8,
  ),
  TopProduct(
    productId: 'acl-003',
    productName: 'Arroz con Leche Premium',
    productImage:
        'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=200',
    sales: 598000,
    units: 92,
    trend: 22.4,
  ),
  TopProduct(
    productId: 'fcc-008',
    productName: 'Fresas con Crema y Brownie',
    productImage:
        'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=200',
    sales: 534000,
    units: 71,
    trend: 18.9,
  ),
  TopProduct(
    productId: 'pe-003',
    productName: 'Mousse de Chocolate Negro',
    productImage:
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=200',
    sales: 467000,
    units: 79,
    trend: -1.5,
  ),
];

/// Ventas por categoría
final List<CategorySales> categorySalesData = [
  CategorySales(
    category: 'Fresas con Crema',
    sales: 3245000,
    percentage: 42.3,
    orders: 456,
    color: '#FF6B9D',
  ),
  CategorySales(
    category: 'Arroz con Leche',
    sales: 2567000,
    percentage: 33.5,
    orders: 389,
    color: '#9C27B0',
  ),
  CategorySales(
    category: 'Postres Especiales',
    sales: 1234000,
    percentage: 16.1,
    orders: 178,
    color: '#FF9800',
  ),
  CategorySales(
    category: 'Bebidas Cremosas',
    sales: 623000,
    percentage: 8.1,
    orders: 142,
    color: '#00BCD4',
  ),
];

/// Reporte de ventas general
final SalesReport currentSalesReport = SalesReport(
  totalSales: 7669000,
  totalOrders: 1165,
  averageTicket: 6584,
  totalCustomers: 456,
  newCustomers: 87,
  returningCustomers: 369,
  topProducts: topProducts,
  categorySales: categorySalesData,
  dailySales: dailySalesData,
  period: 'Enero 2024',
  periodStart: DateTime(2024, 1, 1),
  periodEnd: DateTime(2024, 1, 31),
  comparisonPeriod: 'Diciembre 2023',
  growthRate: 14.3,
  topSellingCategory: 'Fresas con Crema',
  lowStockProducts: [
    'acl-007',
    'fcc-008',
    'pe-001',
  ],
);

/// Funciones de utilidad
List<Banner> getActiveBanners() {
  final now = DateTime.now();
  return activeBanners
      .where((banner) =>
          banner.isActive &&
          now.isAfter(banner.startDate) &&
          (banner.endDate == null || now.isBefore(banner.endDate!)))
      .toList()
    ..sort((a, b) => a.priority.compareTo(b.priority));
}

List<TopProduct> getTopProducts({int limit = 5}) {
  return topProducts.take(limit).toList();
}

List<DailySales> getDailySales({int days = 7}) {
  return dailySalesData.reversed.take(days).toList().reversed.toList();
}

CategorySales? getCategorySales(String category) {
  try {
    return categorySalesData.firstWhere(
      (cat) => cat.category.toLowerCase() == category.toLowerCase(),
    );
  } catch (e) {
    return null;
  }
}

SalesReport getSalesReport() {
  return currentSalesReport;
}

/// Estadísticas de inventario
Map<String, dynamic> getInventoryStats() {
  return {
    'totalProducts': 23,
    'inStock': 20,
    'lowStock': 3,
    'outOfStock': 0,
    'totalValue': 4567000,
    'averagePrice': 5890,
  };
}

/// Estadísticas de clientes
Map<String, dynamic> getCustomerStats() {
  return {
    'totalCustomers': 456,
    'newThisMonth': 87,
    'activeThisMonth': 234,
    'averageOrderValue': 6584,
    'repeatCustomerRate': 80.9,
    'customerSatisfaction': 4.7,
  };
}
