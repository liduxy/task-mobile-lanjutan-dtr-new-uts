import 'package:flutter/material.dart';

import '../widgets/app_background.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

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
                title: 'Product',
                subtitle: 'Kelola produk yang tersedia',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: EmptyStateCard(
                  icon: Icons.inventory_2_rounded,
                  title: 'Belum ada produk',
                  message:
                      'Data produk akan tampil di sini setelah ditambahkan.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
