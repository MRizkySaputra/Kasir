import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kasir/modules/menu/menuControllers.dart';
import 'package:kasir/modules/menu/menuModel.dart';
import 'package:kasir/widgets/textfield.dart';
import 'package:provider/provider.dart';

class MenuForm extends StatefulWidget {
  final Product? product;
  const MenuForm({super.key, this.product});

  @override
  State<MenuForm> createState() => _MenuForm();
}

class _MenuForm extends State<MenuForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameC;
  late TextEditingController descC;
  late TextEditingController priceC;
  late TextEditingController stokC;

  String? status;
  String? unit;

  File? _image;
  bool isLoading = false;

  final statusList = ['tersedia', 'habis', 'nonaktif'];
  final unitList = ['porsi', 'gelas'];

  @override
  void initState() {
    super.initState();
    final p = widget.product;

    nameC = TextEditingController(text: p?.name ?? '');
    descC = TextEditingController(text: p?.description ?? '');
    priceC = TextEditingController(text: p?.price.toString() ?? '');
    stokC = TextEditingController(text: p?.stok.toString() ?? '');

    status = p?.status;
    unit = p?.unit;
  }

  @override
  void dispose() {
    nameC.dispose();
    descC.dispose();
    priceC.dispose();
    stokC.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.read<ProductControllers>();

    return AlertDialog(
      title: Text(widget.product == null ? 'Tambah Produk' : 'Edit Produk'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _imagePreview(),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: isLoading ? null : _pickImage,
                icon: const Icon(Icons.upload),
                label: const Text('Upload Gambar'),
              ),
              const SizedBox(height: 12),

              Textfield(
                label: 'Nama Produk',
                prefixIcon: Icons.fastfood,
                controller: nameC,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),

              const SizedBox(height: 10),

              Textfield(
                label: 'Deskripsi',
                prefixIcon: Icons.description,
                controller: descC,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Deskripsi wajib diisi' : null,
              ),

              const SizedBox(height: 10),

              Textfield(
                label: 'Harga',
                prefixIcon: Icons.attach_money,
                controller: priceC,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Harga wajib diisi' : null,
              ),

              const SizedBox(height: 10),

              Textfield(
                label: 'Stok',
                prefixIcon: Icons.inventory,
                controller: stokC,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Stok wajib diisi' : null,
              ),

              /// ===== DROPDOWN STATUS =====
              DropdownButtonFormField<String>(
                value: status,
                items: statusList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => status = v),
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'Status wajib dipilih' : null,
              ),

              const SizedBox(height: 10),

              /// ===== DROPDOWN UNIT =====
              DropdownButtonFormField<String>(
                value: unit,
                items: unitList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => unit = v),
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'Unit wajib dipilih' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) return;
                  if (_image == null && widget.product?.image == null) {
                    _showError('Gambar wajib diupload');
                    return;
                  }

                  setState(() => isLoading = true);

                  try {
                    if (widget.product == null) {
                      await c.createMenu(
                        name: nameC.text,
                        description: descC.text,
                        price: int.parse(priceC.text),
                        stok: int.parse(stokC.text),
                        status: status!,
                        unit: unit!,
                        image: _image,
                      );
                    } else {
                      await c.updateMenu(
                        id: widget.product!.id,
                        name: nameC.text,
                        description: descC.text,
                        price: int.parse(priceC.text),
                        stok: int.parse(stokC.text),
                        status: status!,
                        unit: unit!,
                        image: _image,
                      );
                    }
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menyimpan data: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    if (mounted) setState(() => isLoading = false);
                  }
                },
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }

  Widget _imagePreview() {
    if (_image != null) {
      return Image.file(_image!, height: 120, fit: BoxFit.cover);
    }
    if (widget.product?.image != null) {
      return Image.network(
        widget.product!.image!,
        height: 120,
        fit: BoxFit.cover,
      );
    }
    return const Icon(Icons.image, size: 80);
  }

  bool _isImageValid() {
    if (_image != null) return true;
    if (widget.product?.image != null) return true;
    return false;
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
