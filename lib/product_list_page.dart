import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final supabase = Supabase.instance.client;
  late Future<List<Product>> _productsFuture;

  Future<List<Product>> fetchProducts() async {
    final response = await supabase
        .from('products')
        .select()
        .order('id', ascending: false);

    return (response as List)
        .map((item) => Product.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Product List')),
    body: FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        final products = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal, // allow horizontal scrolling
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Code')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Batch Product')),
            ],
            rows: products.map((product) {
              return DataRow(cells: [
                DataCell(Text(product.code)),
                DataCell(Text(product.name)),
                DataCell(Text(product.description)),
                DataCell(
                  Icon(
                    product.isBatchProduct ? Icons.check : Icons.close,
                    color: product.isBatchProduct ? Colors.green : Colors.red,
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    ),
  );
}

}
