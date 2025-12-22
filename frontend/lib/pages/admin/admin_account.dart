import 'package:flutter/material.dart';
import 'package:kasir/auth/login_page.dart';
import 'package:kasir/modules/users/userController.dart';
import 'package:kasir/modules/users/userView.dart';
import 'package:kasir/modules/users/widget/UserFormPage.dart';
import 'package:kasir/themes/app_textstyle.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserController>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserController>();
    final user = controller.currentUser;
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(child: Text('Error: ${controller.errorMessage}'));
    }

    if (user == null) {
      return const Center(child: Text('User belum login'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Akun")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 44)),
            const SizedBox(height: 12),

            Text(user.name, style: AppTextStyle.h2),
            const SizedBox(height: 6),
            Text(user.email, style: AppTextStyle.bodyMedium),

            const SizedBox(height: 30),

            /// 🔥 LIHAT USER (ADMIN ONLY)
            if (controller.role == 'admin')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.people),
                  label: const Text("Lihat User"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UserPage()),
                    );
                  },
                ),
              ),

            if (controller.role == 'admin') const SizedBox(height: 12),

            /// ➕ TAMBAH USER (ADMIN ONLY)
            if (controller.role == 'admin')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text("Tambah User"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UserFormPage()),
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),

            /// ✏️ EDIT PROFIL
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profil"),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserFormPage(isEdit: true, user: user),
                    ),
                  );

                  if (result == true) {
                    await controller.fetchProfile(); // optional refresh
                  }
                },
              ),
            ),

            const Spacer(),

            /// 🚪 LOGOUT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 114, 52),
                ),
                onPressed: () {
                  controller.clearUser();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
