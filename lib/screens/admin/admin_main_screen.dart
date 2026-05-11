import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/category_service.dart';
import 'product_form_screen.dart';
import 'categories_screen.dart';
import 'users_screen.dart';
import 'bulk_discount_screen.dart';
import 'widgets/admin_sidebar.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  String _selectedCategory = 'Todos';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductService>().fetchProducts(limit: 200);
      context.read<CategoryService>().fetchCategories(adminAll: true);
    });
  }

  Future<void> _deleteProduct(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Eliminar producto',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(
          '¿Seguro que deseas eliminar "${product.name}"?',
          style: TextStyle(color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await context.read<ProductService>().deleteProduct(product.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto eliminado')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  void _performSearch() {
    context.read<ProductService>().fetchProducts(
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
      limit: 200,
    );
  }

  List<Product> _filteredProducts(List<Product> products) {
    if (_selectedCategory == 'Todos') return products;
    return products
        .where((p) =>
            p.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  String _formatPrice(double price) {
    final intPrice = price.toInt();
    final str = intPrice.toString();
    final result = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) result.write('.');
      result.write(str[i]);
    }
    return '\$ ${result.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const UsersScreen()),
                          );
                        },
                        icon: const Icon(Icons.people_outlined, size: 18),
                        label: const Text('Usuarios'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black87,
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const CategoriesScreen()),
                          );
                          if (mounted) {
                            context
                                .read<CategoryService>()
                                .fetchCategories(adminAll: true);
                          }
                        },
                        icon: const Icon(Icons.category_outlined, size: 18),
                        label: const Text('Categorias'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black87,
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    const BulkDiscountScreen()),
                          );
                          if (mounted) {
                            context
                                .read<ProductService>()
                                .fetchProducts(limit: 200);
                          }
                        },
                        icon: const Icon(Icons.discount_outlined, size: 18),
                        label: const Text('Descuentos'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black87,
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const ProductFormScreen()),
                          );
                          if (mounted) {
                            context
                                .read<ProductService>()
                                .fetchProducts(limit: 200);
                          }
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Agregar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                _StatsBar(),
                const SizedBox(height: 8),
                _CategoryFilterBar(
                  selectedCategory: _selectedCategory,
                  onSelected: (cat) =>
                      setState(() => _selectedCategory = cat),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar productos...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                      _performSearch();
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Consumer<ProductService>(
                    builder: (_, service, __) {
                      if (service.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF00ACC1)),
                        );
                      }

                      final filtered = _filteredProducts(service.products);

                      if (filtered.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined,
                                  size: 60, color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              Text(
                                'Sin productos en esta categoria',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 15),
                              ),
                            ],
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 16,
                            horizontalMargin: 16,
                            border: TableBorder(
                              bottom: BorderSide(color: Colors.grey[200]!),
                              horizontalInside:
                                  BorderSide(color: Colors.grey[200]!),
                            ),
                            headingRowColor: MaterialStatePropertyAll(
                              const Color(0xFF00ACC1).withOpacity(0.05),
                            ),
                            headingTextStyle: const TextStyle(
                              color: Color(0xFF00ACC1),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            dataRowHeight: 70,
                            columns: const [
                              DataColumn(label: Text('Código')),
                              DataColumn(label: Text('Nombre Comercial')),
                              DataColumn(label: Text('Categoría')),
                              DataColumn(label: Text('Stock')),
                              DataColumn(label: Text('Precio')),
                              DataColumn(label: Text('Descuento')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: List.generate(
                              filtered.length,
                              (index) {
                                final product = filtered[index];
                                return DataRow(
                                  color: MaterialStatePropertyAll(
                                    index % 2 == 0
                                        ? Colors.white
                                        : Colors.grey[50],
                                  ),
                                  cells: [
                                    DataCell(Text(
                                      product.id.toString().substring(0, 6),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    )),
                                    DataCell(
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(
                                      product.category,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: product.stock > 0
                                              ? const Color(0xFFE8F5E9)
                                              : const Color(0xFFFFEBEE),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${product.stock}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: product.stock > 0
                                                ? const Color(0xFF2E7D32)
                                                : const Color(0xFFD32F2F),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(
                                      _formatPrice(product.price),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF00ACC1),
                                      ),
                                    )),
                                    DataCell(
                                      product.discountPercent != null
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color:
                                                    const Color(0xFFE91E63),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                '-${product.discountPercent!.toInt()}%',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : const Text('-'),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.edit_outlined,
                                                size: 18,
                                                color: Colors.black54),
                                            onPressed: () async {
                                              await Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ProductFormScreen(
                                                    product: product,
                                                  ),
                                                ),
                                              );
                                              if (mounted) {
                                                context
                                                    .read<ProductService>()
                                                    .fetchProducts(
                                                        limit: 200);
                                              }
                                            },
                                            tooltip: 'Editar',
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline,
                                                size: 18,
                                                color: Color(0xFFD32F2F)),
                                            onPressed: () =>
                                                _deleteProduct(product),
                                            tooltip: 'Eliminar',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: const Color(0xFF00ACC1),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.home, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          const Text(
            'isfarma',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 24),
          const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          const Text(
            'Productos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                'EN LÍNEA',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                'Admin',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductService>(
      builder: (_, service, __) {
        final total = service.products.length;
        final categories =
            service.products.map((p) => p.category).toSet().length;

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              _StatItem(
                label: 'Total productos',
                value: '$total',
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFF1565C0),
              ),
              const SizedBox(width: 12),
              _StatItem(
                label: 'Categorias',
                value: '$categories',
                icon: Icons.category_outlined,
                color: const Color(0xFF2E7D32),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const _CategoryFilterBar({
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductService>(
      builder: (_, service, __) {
        final usedCategories =
            service.products.map((p) => p.category).toSet().toList();
        usedCategories.sort();
        final allCategories = ['Todos', ...usedCategories];

        return SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final cat = allCategories[index];
              final isSelected = selectedCategory == cat;
              return GestureDetector(
                onTap: () => onSelected(cat),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? Colors.black
                          : const Color(0xFFDDDDDD),
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
