import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kasir/controllers/menu_controllers.dart';
import 'package:kasir/widgets/textfield.dart';
import 'package:kasir/widgets/admin_product_card.dart'; // Import widget baru

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _searchQuery = "";

  // controllers untuk dialog add/edit
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();

  @override
  void dispose() {
    _nameC.dispose();
    _priceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MenuControllers>(context);
    final items = _searchQuery.isEmpty ? controller.items : controller.search(_searchQuery);

    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Menu")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            // Search Bar
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() {
                    _searchQuery = "";
                  }),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  mainAxisSpacing: 12, 
                  crossAxisSpacing: 12, 
                  childAspectRatio: 0.80, // Disesuaikan agar muat tombol edit/delete
                ),
                itemBuilder: (context, i) {
                  final item = items[i];
                  
                  // PENGGUNAAN WIDGET BARU
                  return AdminProductCard(
                    name: item.name,
                    price: item.price,
                    image: item.image,
                    onEdit: () => _showEditDialog(context, controller, i),
                    onDelete: () => _confirmDelete(context, controller, i),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Tombol Tambah Menu
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  // DIALOG ADD
  void _showAddDialog(BuildContext ctx, MenuControllers controller) {
    _nameC.clear();
    _priceC.clear();

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Menu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Textfield(label: "Nama Menu", prefixIcon: Icons.fastfood, controller: _nameC),
            const SizedBox(height: 8),
            Textfield(label: "Harga (angka)", prefixIcon: Icons.payments, keyboardType: TextInputType.number, controller: _priceC),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final name = _nameC.text.trim();
              final price = int.tryParse(_priceC.text.trim()) ?? 0;
              if (name.isNotEmpty && price > 0) {
                controller.addMenu(name, price);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // DIALOG EDIT
  void _showEditDialog(BuildContext ctx, MenuControllers controller, int index) {
    final item = controller.items[index];
    _nameC.text = item.name;
    _priceC.text = item.price.toString();

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text("Edit Menu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Textfield(label: "Nama Menu", prefixIcon: Icons.fastfood, controller: _nameC),
            const SizedBox(height: 8),
            Textfield(label: "Harga (angka)", prefixIcon: Icons.payments, keyboardType: TextInputType.number, controller: _priceC),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final name = _nameC.text.trim();
              final price = int.tryParse(_priceC.text.trim()) ?? 0;
              if (name.isNotEmpty && price > 0) {
                controller.editMenu(index, name, price);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // CONFIRM DELETE
  void _confirmDelete(BuildContext ctx, MenuControllers controller, int index) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text("Hapus menu?"),
        content: const Text("Apakah anda yakin ingin menghapus menu ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.deleteMenu(index);
              Navigator.pop(ctx);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}