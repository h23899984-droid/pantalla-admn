import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: const Color(0xFF263238),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF1A1F23),
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Icon(Icons.settings, color: Color(0xFF00ACC1), size: 24),
                SizedBox(width: 12),
                Text(
                  'Panel de datos',
                  style: TextStyle(
                    color: Color(0xFF00ACC1),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard,
                  label: 'Panel de datos',
                  onTap: () {},
                ),
                _SidebarItem(
                  icon: Icons.security,
                  label: 'Administración',
                  onTap: () {},
                  hasSubmenu: true,
                ),
                _SidebarItem(
                  icon: Icons.shopping_cart,
                  label: 'Productos',
                  onTap: () {},
                  isActive: true,
                  hasSubmenu: true,
                ),
                _SidebarItem(
                  icon: Icons.shopping_bag,
                  label: 'Compras',
                  onTap: () {},
                  hasSubmenu: true,
                ),
                _SidebarItem(
                  icon: Icons.trending_up,
                  label: 'Ventas',
                  onTap: () {},
                  hasSubmenu: true,
                ),
                _SidebarItem(
                  icon: Icons.inventory,
                  label: 'Inventarios',
                  onTap: () {},
                  hasSubmenu: true,
                ),
                _SidebarItem(
                  icon: Icons.account_balance,
                  label: 'Finanzas',
                  onTap: () {},
                  hasSubmenu: true,
                ),
                _SidebarItem(
                  icon: Icons.exit_to_app,
                  label: 'Salir',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool hasSubmenu;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.hasSubmenu = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isActive ? const Color(0xFF00ACC1).withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFF00ACC1) : Colors.grey[400],
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF00ACC1) : Colors.grey[300],
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: hasSubmenu
            ? Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
                size: 20,
              )
            : null,
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
