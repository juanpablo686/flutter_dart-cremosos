// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../data/users_data.dart';
import '../models/cart.dart';
import 'auth_screen.dart';
import 'reports_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isAdmin = ref.watch(isAdminProvider);

    if (!isAuthenticated || currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text('No has iniciado sesión',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AuthScreen())),
                icon: const Icon(Icons.login),
                label: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      );
    }

    final userOrders = getOrdersByUserId(currentUser.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Estás seguro?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        Navigator.pop(ctx);
                      },
                      child: const Text('Cerrar sesión',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.deepPurple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: currentUser.avatar != null
                          ? ClipOval(
                              child: Image.network(currentUser.avatar!,
                                  fit: BoxFit.cover, width: 100, height: 100))
                          : Text(currentUser.name[0].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 40, color: Colors.deepPurple)),
                    ),
                    const SizedBox(height: 16),
                    Text(currentUser.name,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(currentUser.email,
                        style: const TextStyle(color: Colors.white70)),
                    if (currentUser.phone != null) ...[
                      const SizedBox(height: 4),
                      Text(currentUser.phone!,
                          style: const TextStyle(color: Colors.white70)),
                    ],
                    if (isAdmin) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text('ADMINISTRADOR',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Admin Dashboard Button
            if (isAdmin)
              ListTile(
                leading: const Icon(Icons.dashboard, color: Colors.deepPurple),
                title: const Text('Panel de Administración',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportsScreen())),
              ),

            const Divider(),

            // Account Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mi cuenta',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _InfoCard(
                    icon: Icons.shopping_bag,
                    title: 'Pedidos',
                    subtitle: '${userOrders.length} pedidos realizados',
                  ),
                  _InfoCard(
                    icon: Icons.location_on,
                    title: 'Direcciones',
                    subtitle:
                        '${currentUser.addresses.length} direcciones guardadas',
                  ),
                  _InfoCard(
                    icon: Icons.payment,
                    title: 'Métodos de pago',
                    subtitle:
                        '${currentUser.paymentMethods.length} métodos guardados',
                  ),
                  const SizedBox(height: 24),
                  Text('Historial de pedidos',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (userOrders.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('No tienes pedidos aún',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    ...userOrders.map((order) {
                      final statusColor = switch (order.status) {
                        OrderStatus.pending => Colors.orange,
                        OrderStatus.processing => Colors.blue,
                        OrderStatus.shipped => Colors.purple,
                        OrderStatus.delivered => Colors.green,
                        OrderStatus.cancelled => Colors.red,
                      };

                      final statusText = switch (order.status) {
                        OrderStatus.pending => 'Pendiente',
                        OrderStatus.processing => 'Procesando',
                        OrderStatus.shipped => 'Enviado',
                        OrderStatus.delivered => 'Entregado',
                        OrderStatus.cancelled => 'Cancelado',
                      };

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Pedido #${order.id}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: statusColor),
                                    ),
                                    child: Text(statusText,
                                        style: TextStyle(
                                            color: statusColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('${order.items.length} productos',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14)),
                              const SizedBox(height: 4),
                              Text('₱${order.total.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple)),
                              const SizedBox(height: 4),
                              Text(
                                'Fecha: ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
