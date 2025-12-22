import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasir/modules/users/userController.dart';
import 'package:kasir/modules/users/userModel.dart';
import 'package:kasir/widgets/textfield.dart';
import 'package:provider/provider.dart';

class UserFormPage extends StatefulWidget {
  final bool isEdit;
  final UserModel? user;

  const UserFormPage({super.key, this.isEdit = false, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  bool isPasswordHidden = true;
  String? role;

  final roleList = ['admin', 'kasir'];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user?.name ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    addressController = TextEditingController(text: widget.user?.address ?? '');
    phoneController = TextEditingController(text: widget.user?.phone ?? '');
    passwordController = TextEditingController();
    role = widget.user?.role;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserController>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit User' : 'Tambah User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Textfield(
                label: 'Nama',
                prefixIcon: Icons.person,
                controller: nameController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              Textfield(
                label: 'Email',
                prefixIcon: Icons.email,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                  if (!isValidEmail(v.trim()))
                    return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              /// ROLE
              DropdownButtonFormField<String>(
                value: role,
                items: roleList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => role = v),
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'Role wajib dipilih' : null,
              ),

              const SizedBox(height: 12),

              Textfield(
                label: 'Alamat',
                prefixIcon: Icons.home,
                controller: addressController,
              ),
              const SizedBox(height: 12),

              Textfield(
                label: 'No. HP',
                prefixIcon: Icons.phone,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (_) {}, // biar formatter jalan
                validator: (v) {
                  if (v == null || v.isEmpty) return 'No. HP wajib diisi';
                  if (!v.startsWith('+62')) return 'No. HP harus diawali +62';

                  final digitOnly = v.replaceAll(RegExp(r'[^0-9]'), '');

                  if (digitOnly.length < 12) return 'No. HP minimal 12 digit';
                  if (digitOnly.length > 14) return 'No. HP maksimal 14 digit';

                  return null;
                },
              ),
              const SizedBox(height: 12),

              if (!widget.isEdit) ...[
                const SizedBox(height: 12),
                Textfield(
                  label: 'Password',
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                    if (v.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 24),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          try {
                            final user = UserModel(
                              id: widget.user?.id ?? 0,
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              role: role!,
                              address: addressController.text.trim(),
                              phone: phoneController.text.trim(),
                              avatar: '',
                              password: widget.isEdit
                                  ? null
                                  : passwordController.text.trim(),
                            );

                            if (widget.isEdit) {
                              await controller.editUser(widget.user!.id, user);
                            } else {
                              await controller.addUser(user);
                            }

                            if (!mounted) return;
                            Navigator.pop(context, true);
                          } catch (e) {
                            if (!mounted) return;
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Error'),
                                content: Text('Gagal menyimpan user\n$e'),
                              ),
                            );
                          }
                        },
                  child: controller.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(widget.isEdit ? 'Update' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
