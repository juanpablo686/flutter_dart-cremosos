// screens/home_screen.dart - Pantalla principal de inicio

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';
import '../providers/reports_provider.dart';
import '../models/product.dart';
import 'products_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final featuredProducts = ref.watch(featuredProductsProvider);
    final onSaleProducts = ref.watch(onSaleProductsProvider);
    final activeBanners = ref.watch(activeBannersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [Text('🍓'), SizedBox(width: 8), Text('Cremosos')],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProductsScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(featuredProductsProvider);
          ref.invalidate(onSaleProductsProvider);
          ref.read(reportsProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Carousel
              if (activeBanners.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: activeBanners.length,
                    onPageChanged: (index) =>
                        setState(() => _currentBannerIndex = index),
                    itemBuilder: (context, index) {
                      final banner = activeBanners[index];
                      return Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: banner.backgroundColor != null
                              ? Color(int.parse(
                                  '0xFF${banner.backgroundColor!.substring(1)}'))
                              : Colors.deepPurple,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: banner.textColor != null
                                      ? Color(int.parse(
                                          '0xFF${banner.textColor!.substring(1)}'))
                                      : Colors.white,
                                ),
                              ),
                              if (banner.subtitle != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  banner.subtitle!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: banner.textColor != null
                                        ? Color(int.parse(
                                            '0xFF${banner.textColor!.substring(1)}'))
                                        : Colors.white70,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Banner Indicators
              if (activeBanners.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    activeBanners.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentBannerIndex == index
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Category Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Categorías',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ProductCategory.values
                          .where((c) => c != ProductCategory.toppings)
                          .map((category) {
                        final iconData = switch (category) {
                          ProductCategory.arrozConLeche => Icons.rice_bowl,
                          ProductCategory.fresasConCrema => Icons.cake,
                          ProductCategory.postresEspeciales => Icons.icecream,
                          ProductCategory.bebidasCremosas => Icons.local_cafe,
                          ProductCategory.toppings => Icons.add_circle_outline,
                        };
                        final label = switch (category) {
                          ProductCategory.arrozConLeche => 'Arroz',
                          ProductCategory.fresasConCrema => 'Fresas',
                          ProductCategory.postresEspeciales => 'Postres',
                          ProductCategory.bebidasCremosas => 'Bebidas',
                          ProductCategory.toppings => 'Toppings',
                        };
                        return ActionChip(
                          avatar: Icon(iconData, size: 18),
                          label: Text(label),
                          onPressed: () {
                            ref
                                .read(productsProvider.notifier)
                                .filterByCategory(category);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ProductsScreen()));
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Featured Products
              if (featuredProducts.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Destacados',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProductsScreen())),
                        child: const Text('Ver todos'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: featuredProducts.length,
                    itemBuilder: (context, index) {
                      final product = featuredProducts[index];
                      return SizedBox(
                          width: 160, child: _ProductCard(product: product));
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // On Sale Products
              if (onSaleProducts.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.local_offer, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Ofertas',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProductsScreen())),
                        child: const Text('Ver todas'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: onSaleProducts.length,
                    itemBuilder: (context, index) {
                      final product = onSaleProducts[index];
                      return SizedBox(
                          width: 160, child: _ProductCard(product: product));
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 12, bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, size: 48),
                    ),
                  ),
                ),
                if (product.onSale == true)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text('OFERTA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text('${product.rating}',
                          style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (product.salePrice != null) ...[
                    Text('₱${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade600)),
                    Text('₱${product.effectivePrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                  ] else
                    Text('₱${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
