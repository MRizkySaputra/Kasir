import 'package:flutter/material.dart';
import 'package:kasir/modules/menu/menuModel.dart';
import 'package:kasir/modules/menu/widget/confirm_delete.dart';
import 'package:kasir/modules/menu/widget/menu_form.dart';
import 'package:kasir/modules/menu/widget/status_menu.dart';
import 'package:provider/provider.dart';
import 'menuControllers.dart';
import 'package:kasir/widgets/searchbar.dart'; // sesuaikan path

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String _search = '';

  String _unit = 'all'; // all | porsi | gelas

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductControllers>().fetchMenu());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(int id) async {
    final confirmed = await showConfirmDeleteDialog(context);
    if (confirmed == true) {
      context.read<ProductControllers>().deleteMenu(id);
    }
  }

  void _openForm({Product? product}) {
    showDialog(
      context: context,
      builder: (_) => MenuForm(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ProductControllers>();

    /// FILTER + SEARCH
    final filteredItems = c.items.where((item) {
      final matchSearch = item.name.toLowerCase().contains(
        _search.toLowerCase(),
      );

      final matchUnit = _unit == 'all' || item.unit == _unit;

      return matchSearch && matchUnit;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Data Produk')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: c.loading
          ? const Center(child: CircularProgressIndicator())
          : c.error != null
          ? const Center(child: Text("Periksa jaringan anda"))
          : Column(
              children: [
                /// SEARCH pakai Searchbar
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Searchbar(
                    controller: _searchController,
                    hintText: 'Cari produk...',
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _search = '';
                              });
                            },
                          )
                        : null,
                    onChanged: (value) {
                      setState(() {
                        _search = value;
                      });
                    },
                  ),
                ),

                /// FILTER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      /// UNIT
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _unit,
                          decoration: const InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text('Semua'),
                            ),
                            DropdownMenuItem(
                              value: 'porsi',
                              child: Text('Porsi'),
                            ),
                            DropdownMenuItem(
                              value: 'gelas',
                              child: Text('Gelas'),
                            ),
                          ],
                          onChanged: (v) {
                            setState(() => _unit = v!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// LIST PRODUK
                Expanded(
                  child: filteredItems.isEmpty
                      ? const Center(child: Text('Produk tidak ditemukan'))
                      : ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (_, i) {
                            final item = filteredItems[i];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: ListTile(
                                leading: item.image != null
                                    ? Image.network(
                                        item.image!,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image),
                                title: Text(item.name),
                                subtitle: Text(
                                  'Rp ${item.price} | ${item.unit}',
                                ),
                                trailing: Wrap(
                                  spacing: 8,
                                  children: [
                                    StatusButton(status: item.status),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () => _openForm(product: item),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _confirmDelete(item.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
