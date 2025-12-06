import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MobilePosPage(),
  ));
}

// --- DATA MODEL ---
class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageAsset; // Placeholder logic

  Product(this.id, this.name, this.price, this.category, this.imageAsset);
}

class OrderItem {
  final Product product;
  int quantity;
  String note;

  OrderItem({required this.product, this.quantity = 1, this.note = ''});

  double get total => product.price * quantity;
}

// --- MAIN PAGE ---
class MobilePosPage extends StatefulWidget {
  const MobilePosPage({super.key});

  @override
  State<MobilePosPage> createState() => _MobilePosPageState();
}

class _MobilePosPageState extends State<MobilePosPage> {
  // Warna dari desain gambar (Green Theme)
  final Color primaryGreen = const Color(0xFF2E5A48); 
  final Color secondaryYellow = const Color(0xFFFFF571);
  final Color bgGrey = const Color(0xFFF5F5F5);

  // State Data
  String selectedCategory = 'Semua';
  List<OrderItem> cart = [];
  String customerName = "Ariel Hikmat"; // Default dari gambar
  bool isDineIn = true;

  // Dummy Data Produk
  final List<Product> products = [
    Product('1', 'Ayam Bumbu Hitam', 30000, 'Ayam', 'assets/ayam.png'),
    Product('2', 'Ayam Geprek', 25000, 'Ayam', 'assets/geprek.png'),
    Product('3', 'Es Teh Manis', 5000, 'Minuman', 'assets/teh.png'),
    Product('4', 'Nasi Putih', 5000, 'Pelengkap', 'assets/nasi.png'),
    Product('5', 'Sambal Ijo', 3000, 'Pelengkap', 'assets/sambal.png'),
    Product('6', 'Jus Jeruk', 12000, 'Minuman', 'assets/jus.png'),
  ];

  // Logic Cart
  void _addToCart(Product product) {
    setState(() {
      final index = cart.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        cart[index].quantity++;
      } else {
        cart.add(OrderItem(product: product));
      }
    });
  }

  void _updateQty(int index, int delta) {
    setState(() {
      cart[index].quantity += delta;
      if (cart[index].quantity <= 0) {
        cart.removeAt(index);
      }
    });
  }

  double get _subtotal => cart.fold(0, (sum, item) => sum + item.total);
  double get _tax => _subtotal * 0.03; // 3% Tax sesuai gambar
  double get _total => _subtotal + _tax;

  @override
  Widget build(BuildContext context) {
    // Filter produk berdasarkan kategori
    final displayProducts = selectedCategory == 'Semua'
        ? products
        : products.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: bgGrey,
      // APP BAR & DRAWER MENGGANTIKAN SIDEBAR KIRI
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryGreen),
        title: Text("Menu", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      drawer: _buildDrawer(), // Sidebar kiri diubah jadi Drawer
      
      body: Column(
        children: [
          // 1. SEARCH & KATEGORI (Bagian Atas Gambar)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search a name, order, etc...",
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Kategori Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua', 'Ayam', 'Minuman', 'Pelengkap']
                        .map((cat) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(cat),
                                selected: selectedCategory == cat,
                                selectedColor: primaryGreen,
                                labelStyle: TextStyle(
                                  color: selectedCategory == cat ? Colors.white : Colors.black,
                                ),
                                onSelected: (val) {
                                  setState(() => selectedCategory = cat);
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),

          // 2. GRID MENU (Bagian Tengah Gambar)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 Kolom untuk HP
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: displayProducts.length,
              itemBuilder: (context, index) {
                final product = displayProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),

      // 3. FLOATING CART SUMMARY (Memicu Bagian Kanan Gambar)
      bottomNavigationBar: cart.isNotEmpty 
        ? SafeArea(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0,4))]
              ),
              child: InkWell(
                onTap: () => _showOrderSheet(context), // BUKA DETAIL ORDER
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${cart.length} Item", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        Text("Rp ${_total.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: const [
                        Text("Detail Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_up, color: Colors.white)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ) 
        : null,
    );
  }

  // --- WIDGETS ---

  // 1. Sidebar (Mobile Drawer)
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: primaryGreen,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(radius: 40, backgroundColor: Colors.grey),
            const SizedBox(height: 10),
            const Text("Kasir", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _buildDrawerItem("Dashboard", false),
            _buildDrawerItem("Menu", true), // Aktif
            _buildDrawerItem("Order", false),
            const Spacer(),
            _buildDrawerItem("Keluar", false),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, bool isActive) {
    return ListTile(
      title: Text(
        title, 
        style: TextStyle(
          color: Colors.white, 
          fontSize: 18, 
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          decoration: isActive ? TextDecoration.underline : TextDecoration.none,
          decorationColor: Colors.white,
        )
      ),
      onTap: () {},
    );
  }

  // 2. Product Card
  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rp ${product.price.toInt()}", style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () => _addToCart(product),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 3. Bottom Sheet (Bagian Kanan Gambar - Detail Order)
  void _showOrderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder( // Agar state di bottom sheet bisa berubah
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 20),
                  
                  // Header: Title & Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Detail Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {}, 
                            icon: const Icon(Icons.refresh, size: 14), 
                            label: const Text("Reset", style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: isDineIn ? "Dine in" : "Take away",
                            underline: Container(),
                            style: const TextStyle(color: Colors.black, fontSize: 12),
                            items: ["Dine in", "Take away"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (val) {
                              setSheetState(() => isDineIn = val == "Dine in");
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Customer Name Input
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Nama Pelanggan",
                      hintText: "Masukkan nama...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    controller: TextEditingController(text: customerName),
                  ),
                  const SizedBox(height: 16),

                  // List Item (Scrollable)
                  Expanded(
                    child: ListView.separated(
                      itemCount: cart.length,
                      separatorBuilder: (ctx, i) => const Divider(),
                      itemBuilder: (ctx, i) {
                        final item = cart[i];
                        return Row(
                          children: [
                            // Gambar Kecil
                            Container(
                              width: 60, height: 60,
                              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            // Nama & Harga
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Rp ${item.product.price.toInt()}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            // Quantity Controls
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                                  onPressed: () {},
                                ),
                                Container(
                                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setSheetState(() => _updateQty(i, -1));
                                          setState((){}); // Update parent UI
                                        },
                                        child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.remove, size: 14)),
                                      ),
                                      Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                      InkWell(
                                        onTap: () {
                                          setSheetState(() => _updateQty(i, 1));
                                          setState((){}); // Update parent UI
                                        },
                                        child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.add, size: 14)),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    setSheetState(() => cart.removeAt(i));
                                    setState((){}); // Update parent UI
                                  },
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),

                  // Payment Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow("Sub Total", _subtotal),
                        _buildSummaryRow("Discount", 0),
                        _buildSummaryRow("Tax 3%", _tax),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Payment", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Rp ${_total.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                             Navigator.pop(context);
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pembayaran Berhasil!")));
                             setState(() => cart.clear());
                          },
                          child: const Text("Pay Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryYellow,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Later", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }

  Widget _buildSummaryRow(String label, double val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(val == 0 ? "-" : "Rp ${val.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}