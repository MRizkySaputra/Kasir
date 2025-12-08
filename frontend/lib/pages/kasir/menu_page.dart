import 'package:flutter/material.dart';
import 'package:kasir/models/menu_model.dart';
import 'package:kasir/pages/payment/payment_page.dart';
import 'package:kasir/widgets/product_card.dart';
import 'package:kasir/themes/app_themes.dart';
import 'package:intl/intl.dart';
import 'package:kasir/controllers/order_controller.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // State Data
  String _selectedCategory = 'Semua';
  String _customerName = "";
  String _orderType = "Dine in";

  final List<OrderItem> _cart = [];

  // Dummy Data
  final List<Product> _products = [
    Product('1', 'Ayam Bumbu Hitam', 30000, 'Ayam', 'assets/images/food.png'),
    Product('2', 'Ayam Geprek', 25000, 'Ayam', 'assets/images/food.png'),
    Product('3', 'Es Teh Manis', 5000, 'Minuman', 'assets/images/food.png'),
    Product('4', 'Jus Jeruk', 12000, 'Minuman', 'assets/images/food.png'),
    Product('5', 'Kerupuk', 2000, 'Pelengkap', 'assets/images/food.png'),
    Product('6', 'Sambal Ijo', 3000, 'Pelengkap', 'assets/images/food.png'),
  ];

  // Formatter Mata Uang
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        _cart[index].quantity++;
      } else {
        _cart.add(OrderItem(product: product));
      }
    });
  }

  void _updateQty(int index, int delta) {
    setState(() {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
    });
  }

  double get _subTotal => _cart.fold(0, (sum, item) => sum + item.total);
  double get _tax => _subTotal * 0.03;
  double get _total => _subTotal + _tax;

  @override
  Widget build(BuildContext context) {
    final displayProducts = _selectedCategory == 'Semua'
        ? _products
        : _products.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        title: const Text(
          "Menu",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // SEARCH & KATEGORI
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Cari menu...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua', 'Ayam', 'Minuman', 'Pelengkap']
                        .map(
                          (cat) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _buildCategoryChip(cat),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),

          // GRID MENU
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: displayProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final product = displayProducts[index];

                // Cek qty di cart
                int qty = 0;
                final cartIndex = _cart.indexWhere(
                  (item) => item.product.id == product.id,
                );
                if (cartIndex != -1) qty = _cart[cartIndex].quantity;

                return ProductCard(
                  product: product,
                  quantity: qty,
                  onTap: () => _addToCart(product),
                );
              },
            ),
          ),
        ],
      ),

      // FLOATING CART BUTTON
      bottomNavigationBar: _cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showDetailOrderSheet,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_cart.length} Items",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Text(
                      "Lihat Pesanan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _currencyFormatter.format(_total),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // --- BOTTOM SHEET ---
  void _showDetailOrderSheet() {
    // 1. Buat controller DI LUAR builder agar tidak reset saat error muncul
    final TextEditingController nameController = TextEditingController(text: _customerName);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // 2. Variabel state lokal untuk error message
        String? nameErrorText;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header Bottom Sheet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Detail Order",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton<String>(
                          value: _orderType,
                          underline: const SizedBox(),
                          items: ["Dine in", "Take away"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setSheetState(() => _orderType = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- TEXT FIELD NAMA ---
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nama Pelanggan",
                      // 3. Tampilkan errorText di sini jika ada error
                      errorText: nameErrorText, 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (val) {
                      _customerName = val;
                      // Hapus error saat user mulai mengetik lagi
                      if (nameErrorText != null) {
                        setSheetState(() => nameErrorText = null);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // List Item
                  Expanded(
                    child: ListView.separated(
                      itemCount: _cart.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _cart[index];
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _currencyFormatter.format(item.product.price),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setSheetState(
                                        () => _updateQty(index, -1),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  Text(
                                    "${item.quantity}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setSheetState(
                                        () => _updateQty(index, 1),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _summaryRow("Sub Total", _subTotal),
                        _summaryRow("Tax 3%", _tax),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Payment",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _currencyFormatter.format(_total),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // 4. Validasi Nama Pelanggan
                            if (_customerName.trim().isEmpty) {
                              setSheetState(() {
                                nameErrorText = "Nama Pelanggan wajib diisi!";
                              });
                              return; // Stop proses
                            }

                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  cart: _cart,
                                  subtotal: _subTotal,
                                  tax: _tax,
                                  total: _total,
                                  customerName: _customerName,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Pay Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryYellow,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Validasi juga untuk tombol Later (Opsional)
                            if (_customerName.trim().isEmpty) {
                              setSheetState(() {
                                nameErrorText = "Nama Pelanggan wajib diisi!";
                              });
                              return;
                            }

                            // 1. Simpan ke OrderController dengan status 'Proses'
                            context.read<OrderController>().addOrder(
                              customerName: _customerName,
                              tableNumber: "A1",
                              status: "Proses",
                              items: _cart,
                              tax: _tax,
                              total: _total,
                            );

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Pesanan disimpan (Proses)!"),
                              ),
                            );
                            setState(() => _cart.clear());
                          },
                          child: const Text(
                            "Later",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _summaryRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            value == 0 ? "-" : _currencyFormatter.format(value),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}