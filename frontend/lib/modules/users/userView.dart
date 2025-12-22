import 'package:flutter/material.dart';
import 'package:kasir/modules/users/userController.dart';
import 'package:kasir/modules/users/widget/UserFormPage.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final Set<int> _deletingIds = {};

  @override
  void initState() {
    super.initState();

    // 🔥 fetch users saat page dibuka
    Future.microtask(() {
      context.read<UserController>().fetchUsers();
    });
  }

  Future<void> _deleteUser(
    BuildContext context,
    UserController controller,
    int userId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus user ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _deletingIds.add(userId));

    try {
      await controller.removeUser(userId);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Berhasil'),
          content: Text('User berhasil dihapus'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Gagal menghapus user\n$e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _deletingIds.remove(userId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserController>();

    /// 🔐 VALIDASI ROLE
    if (controller.role != 'admin') {
      return const Scaffold(
        body: Center(
          child: Text(
            'Akses ditolak\n(Admin only)',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('List Users')),

      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.errorMessage != null
          ? Center(child: Text('Error: ${controller.errorMessage}'))
          : controller.users.isEmpty
          ? const Center(child: Text('Belum ada user'))
          : ListView.builder(
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
                final isDeleting = _deletingIds.contains(user.id);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user.email}'),
                        Text('Role: ${user.role}'),
                        Text('Phone: ${user.phone}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Wrap(
                      spacing: 6,
                      children: [
                        /// ✏️ EDIT
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    UserFormPage(isEdit: true, user: user),
                              ),
                            );

                            if (result == true) {
                              await controller.fetchUsers();
                            }
                          },
                        ),

                        /// 🗑 DELETE
                        IconButton(
                          icon: isDeleting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.delete, color: Colors.red),
                          onPressed: isDeleting
                              ? null
                              : () => _deleteUser(context, controller, user.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
