import 'package:flutter/material.dart';
import 'package:kasir/models/menu_model.dart';
import 'package:kasir/themes/app_themes.dart'; // Import tema

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final int quantity; // Jumlah item di keranjang

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.quantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Produk
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  // image: DecorationImage(image: AssetImage(product.imageAsset), fit: BoxFit.cover),
                ),
                child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
              ),
            ),
            
            // Informasi Produk
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp ${product.price.toInt()}",
                        style: const TextStyle(
                          color: primaryGreen, // Pakai dari app_themes
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // Indikator Add atau Quantity
                      quantity > 0
                          ? CircleAvatar(
                              radius: 12,
                              backgroundColor: primaryGreen,
                              child: Text(
                                "$quantity",
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: primaryGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Colors.white, size: 16),
                            ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}