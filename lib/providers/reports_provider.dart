// providers/reports_provider.dart - Provider de Reportes

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reports.dart';
import '../data/reports_data.dart';

// Estado de reportes
class ReportsState {
  final SalesReport? salesReport;
  final List<Banner> banners;
  final bool isLoading;
  final String? error;

  ReportsState({
    this.salesReport,
    this.banners = const [],
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    SalesReport? salesReport,
    List<Banner>? banners,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      salesReport: salesReport ?? this.salesReport,
      banners: banners ?? this.banners,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notificador de reportes
class ReportsNotifier extends StateNotifier<ReportsState> {
  ReportsNotifier() : super(ReportsState()) {
    loadReports();
  }

  // Cargar reportes
  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 800));

      final report = getSalesReport();
      final banners = getActiveBanners();

      state = ReportsState(
        salesReport: report,
        banners: banners,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Refrescar reportes
  Future<void> refresh() async {
    await loadReports();
  }
}

// Provider de reportes
final reportsProvider =
    StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  return ReportsNotifier();
});

// Provider de banners activos
final activeBannersProvider = Provider<List<Banner>>((ref) {
  return ref.watch(reportsProvider).banners;
});

// Provider de reporte de ventas
final salesReportProvider = Provider<SalesReport?>((ref) {
  return ref.watch(reportsProvider).salesReport;
});

// Provider de top productos
final topProductsProvider = Provider<List<TopProduct>>((ref) {
  final report = ref.watch(salesReportProvider);
  return report?.topProducts ?? [];
});

// Provider de ventas por categoría
final categorySalesProvider = Provider<List<CategorySales>>((ref) {
  final report = ref.watch(salesReportProvider);
  return report?.categorySales ?? [];
});

// Provider de ventas diarias
final dailySalesProvider = Provider<List<DailySales>>((ref) {
  final report = ref.watch(salesReportProvider);
  return report?.dailySales ?? [];
});

// Provider de estadísticas de inventario
final inventoryStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return getInventoryStats();
});

// Provider de estadísticas de clientes
final customerStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return getCustomerStats();
});
