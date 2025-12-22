import 'package:flutter/material.dart';
import 'package:kasir/modules/menu/menuControllers.dart';
import 'package:kasir/modules/menu/menuModel.dart';
import 'package:kasir/modules/menu/widget/status_menu.dart';
import 'package:kasir/modules/transaction/widget/orderDetail.dart';
import 'package:kasir/modules/menu/widget/product_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kasir/widgets/searchbar.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  final List<CartItem> _cart = [];
  String selectedCategory = 'Semua';
  String searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // ============================
  // HELPER STATUS PRODUK
  // ============================
  bool _isProductAvailable(Product product) {
    return product.status.toLowerCase() == 'tersedia';
  }

  void _showProductStatusInfo(Product product) {
    String message;

    if (product.status.toLowerCase() == 'habis') {
      message = 'Produk ini habis';
    } else if (product.status.toLowerCase() == 'nonaktif') {
      message = 'Produk ini nonaktif';
    } else {
      message = 'Produk tidak tersedia';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  // ============================
  // FILTER PRODUK
  // ============================
  List<Product> get displayProducts {
    final products = context.read<ProductControllers>().items;
    List<Product> filtered = [];

    if (selectedCategory == 'Semua') {
      filtered = products;
    } else if (selectedCategory == 'Makanan') {
      filtered = products
          .where((p) => p.unit.toLowerCase().contains('prosi'))
          .toList();
    } else if (selectedCategory == 'Minuman') {
      filtered = products.where((p) {
        final unit = p.unit.toLowerCase();
        return unit.contains('gelas') || unit.contains('minuman');
      }).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return filtered;
  }

  int get _total =>
      _cart.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductControllers>().fetchMenu());

    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        _cart[index].quantity++;
      } else {
        _cart.add(CartItem(product: product, quantity: 1));
      }
    });
  }

  Widget _buildCategoryChip(String cat) {
    final bool isSelected = selectedCategory == cat;
    return ChoiceChip(
      label: Text(cat),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedCategory = selected ? cat : 'Semua';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ProductControllers>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Menu",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Searchbar(
                  controller: _searchController,
                  hintText: "Cari menu...",
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => searchQuery = '');
                          },
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua', 'Makanan', 'Minuman']
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
          Expanded(
            child: c.loading
                ? const Center(child: CircularProgressIndicator())
                : c.error != null
                ? const Center(child: Text("Periksa jaringan anda"))
                : displayProducts.isEmpty
                ? const Center(child: Text("Produk tidak ditemukan"))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];

                      int qty = 0;
                      final cartIndex = _cart.indexWhere(
                        (item) => item.product.id == product.id,
                      );
                      if (cartIndex != -1) {
                        qty = _cart[cartIndex].quantity;
                      }

                      final isAvailable = _isProductAvailable(product);

                      return Stack(
                        children: [
                          Opacity(
                            opacity: isAvailable ? 1.0 : 0.5,
                            child: ProductCard(
                              product: product,
                              quantity: qty,
                              onTap: () {
                                if (isAvailable) {
                                  _addToCart(product);
                                } else {
                                  _showProductStatusInfo(product);
                                }
                              },
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: StatusButton(status: product.status),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 114, 52),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 7, 114, 52),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => OrderDetailSheet(
                      cart: _cart,
                      total: _total,
                      currencyFormatter: _currencyFormatter,
                      onClearCart: () {
                        setState(() => _cart.clear());
                      },
                    ),
                  );
                },
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
}
