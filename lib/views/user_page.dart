import 'package:flutter/material.dart';

import '../widgets/app_background.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'User',
                subtitle: 'Daftar pengguna aplikasi',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: EmptyStateCard(
                  icon: Icons.people_rounded,
                  title: 'Belum ada data user',
                  message:
                      'Daftar pengguna akan tampil di sini setelah tersedia.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
