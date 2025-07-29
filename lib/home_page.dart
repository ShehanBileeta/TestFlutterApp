import 'package:flutter/material.dart';
import 'product_details.dart';
import 'product_list_page.dart';  // Import your product list page

class HomePage extends StatelessWidget {
  final String? userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello $userEmail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigate back to login page (replace as needed)
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text(
                userEmail ?? 'User',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Add Product'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductDetailsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Product List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductListPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warehouse),
              title: const Text('Warehouse'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation when Warehouse page is ready
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Programme'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation when Programme page is ready
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text("Home Page")),
    );
  }
}
