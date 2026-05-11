import 'package:flutter/material.dart';
import '../../../models/product.dart';

class ProductsTable extends StatelessWidget {
  final List<Product> products;

  const ProductsTable({
    super.key,
    required this.products,
  });

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
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay productos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
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
            horizontalInside: BorderSide(color: Colors.grey[200]!),
          ),
          headingRowColor: MaterialStatePropertyAll(
            const Color(0xFF00ACC1).withOpacity(0.05),
          ),
          headingTextStyle: const TextStyle(
            color: Color(0xFF00ACC1),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          dataRowHeight: 60,
          columns: const [
            DataColumn(label: Text('Código')),
            DataColumn(label: Text('Nombre Comercial')),
            DataColumn(label: Text('Nombre Genérico')),
            DataColumn(label: Text('Forma Farmacéutica')),
            DataColumn(label: Text('Concentración')),
            DataColumn(label: Text('Acción Farmacéutica')),
            DataColumn(label: Text('Presentación')),
            DataColumn(label: Text('Marca')),
            DataColumn(label: Text('Laboratorio')),
            DataColumn(label: Text('Precio')),
            DataColumn(label: Text('Margen')),
            DataColumn(label: Text('Margen (%)')),
            DataColumn(label: Text('Precio Venta')),
            DataColumn(label: Text('Mínimo Stock')),
            DataColumn(label: Text('Máximo Stock')),
            DataColumn(label: Text('Alerta de Caducidad')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: List.generate(
            products.length,
            (index) {
              final product = products[index];
              return DataRow(
                color: MaterialStatePropertyAll(
                  index % 2 == 0 ? Colors.white : Colors.grey[50],
                ),
                cells: [
                  DataCell(Text(
                    product.id.toString().substring(0, 6),
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    product.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataCell(Text(
                    product.category,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataCell(Text(
                    'Forma',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    product.description ?? '-',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataCell(Text(
                    'Acción',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    'Presentación',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    'Marca',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    'Lab',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    _formatPrice(product.price),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                  DataCell(Text(
                    '0.00',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    '0.0',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    _formatPrice(product.price * 1.2),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00ACC1),
                    ),
                  )),
                  DataCell(Text(
                    '5',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    '100',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(Text(
                    '60',
                    style: const TextStyle(fontSize: 12),
                  )),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 18, color: Colors.grey),
                          onPressed: () {},
                          tooltip: 'Editar',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outlined,
                              size: 18, color: Color(0xFFE53935)),
                          onPressed: () {},
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
  }
}
