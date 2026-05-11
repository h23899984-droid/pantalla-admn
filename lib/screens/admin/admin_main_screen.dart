import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/category_service.dart';
import 'widgets/admin_sidebar.dart';
import 'widgets/products_table.dart';
import 'widgets/filter_section.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  String _searchQuery = '';
  String _selectedSucursal = 'Todos';
  String _selectedMarca = 'Todos';
  String _selectedCategoria = 'Todos';
  String _selectedSubCategoria = 'Todos';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductService>().fetchProducts(limit: 500);
      context.read<CategoryService>().fetchCategories(adminAll: true);
    });
  }

  List<Product> _getFilteredProducts(List<Product> products) {
    return products.where((product) {
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat =
          _selectedCategoria == 'Todos' ||
          product.category.toLowerCase() ==
              _selectedCategoria.toLowerCase();
      return matchesSearch && matchesCat;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                FilterSection(
                  selectedSucursal: _selectedSucursal,
                  selectedMarca: _selectedMarca,
                  selectedCategoria: _selectedCategoria,
                  selectedSubCategoria: _selectedSubCategoria,
                  onSucursalChanged: (val) =>
                      setState(() => _selectedSucursal = val),
                  onMarcaChanged: (val) =>
                      setState(() => _selectedMarca = val),
                  onCategoriaChanged: (val) =>
                      setState(() => _selectedCategoria = val),
                  onSubCategoriaChanged: (val) =>
                      setState(() => _selectedSubCategoria = val),
                  searchQuery: _searchQuery,
                  onSearchChanged: (val) =>
                      setState(() => _searchQuery = val),
                ),
                Expanded(
                  child: Consumer<ProductService>(
                    builder: (_, service, __) {
                      final filtered = _getFilteredProducts(service.products);
                      return ProductsTable(products: filtered);
                    },
                  ),
                ),
                _buildBottomBar(),
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

  Widget _buildBottomBar() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Agregar nuevo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Editar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Eliminar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
