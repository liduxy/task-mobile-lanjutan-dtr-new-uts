import 'package:flutter/material.dart';

import '../widgets/app_background.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
                title: 'History',
                subtitle: 'Riwayat aktivitas Anda',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: EmptyStateCard(
                  icon: Icons.history_rounded,
                  title: 'Belum ada riwayat',
                  message: 'Aktivitas yang Anda lakukan akan tercatat di sini.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
