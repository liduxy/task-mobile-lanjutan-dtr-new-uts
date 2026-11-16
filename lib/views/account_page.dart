import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/account_controller.dart';
import '../models/user_model.dart';
import '../widgets/app_background.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find<AccountController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Column(
          children: [
            _buildTopBar(controller),
            Expanded(
              child: Obx(() {
                final UserModel? user = controller.user.value;
                final bool isLoading = controller.isLoading.value;

                if (isLoading && user == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white70,
                      strokeWidth: 2.5,
                    ),
                  );
                }

                if (user == null) {
                  return _ErrorView(
                    message: controller.errorMessage.value.isEmpty
                        ? 'Data akun belum tersedia.'
                        : controller.errorMessage.value,
                    onRetry: controller.fetchUser,
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchUser,
                  color: const Color(0xFF7F7FD5),
                  backgroundColor: const Color(0xFF24243E),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    children: [
                      _AccountHero(user: user),
                      const SizedBox(height: 16),
                      _AccountDetails(user: user),
                      if (controller.errorMessage.value.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _InlineError(message: controller.errorMessage.value),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(AccountController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Kembali',
            onTap: Get.back,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Informasi akun dari server',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white70,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : _CircleIconButton(
                    icon: Icons.refresh_rounded,
                    tooltip: 'Muat ulang',
                    onTap: controller.fetchUser,
                  ),
          ),
        ],
      ),
    );
  }
}

class _AccountHero extends StatelessWidget {
  final UserModel user;

  const _AccountHero({required this.user});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7F7FD5),
                  Color(0xFF86A8E7),
                  Color(0xFF91EAE4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              user.initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name.isEmpty ? 'Pengguna' : user.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _copyEmail(user.email),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      user.email.isEmpty ? '-' : user.email,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.copy_rounded,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _InfoChip(
                icon: Icons.shield_rounded,
                label: user.roleLabel,
                color: const Color(0xFF86A8E7),
              ),
              _InfoChip(
                icon: user.isEmailVerified
                    ? Icons.mark_email_read_rounded
                    : Icons.mark_email_unread_rounded,
                label: user.isEmailVerified
                    ? 'Email terverifikasi'
                    : 'Belum diverifikasi',
                color: user.isEmailVerified
                    ? Colors.greenAccent
                    : Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountDetails extends StatelessWidget {
  final UserModel user;

  const _AccountDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Akun',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.badge_rounded,
            label: 'ID Akun',
            value: '#${user.id}',
          ),
          _divider(),
          _InfoRow(
            icon: Icons.person_rounded,
            label: 'Nama Lengkap',
            value: user.name.isEmpty ? '-' : user.name,
          ),
          _divider(),
          _InfoRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: user.email.isEmpty ? '-' : user.email,
            onTap: () => _copyEmail(user.email),
            trailing: Icon(
              Icons.copy_rounded,
              color: Colors.white.withValues(alpha: 0.4),
              size: 16,
            ),
          ),
          _divider(),
          _InfoRow(
            icon: Icons.admin_panel_settings_rounded,
            label: 'Role',
            value: user.roleLabel,
          ),
          _divider(),
          _InfoRow(
            icon: Icons.verified_rounded,
            label: 'Status Email',
            value: user.isEmailVerified
                ? 'Terverifikasi'
                : 'Belum diverifikasi',
          ),
          _divider(),
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Terdaftar',
            value: _formatDateTime(user.createdAt),
          ),
          _divider(),
          _InfoRow(
            icon: Icons.update_rounded,
            label: 'Terakhir Diperbarui',
            value: _formatDateTime(user.updatedAt),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: Icon(icon, color: Colors.white70, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        GlassCard(
          child: Column(
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Gagal memuat akun',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;

  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orangeAccent,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _divider() {
  return Divider(color: Colors.white.withValues(alpha: 0.08), height: 1);
}

String _formatDateTime(DateTime? value) {
  if (value == null) return '-';

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  final date = value.toLocal();
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '${date.day} ${months[date.month - 1]} ${date.year} • $hour:$minute';
}

Future<void> _copyEmail(String email) async {
  if (email.isEmpty || email == '-') return;

  await Clipboard.setData(ClipboardData(text: email));

  Get.snackbar(
    'Berhasil',
    'Email disalin ke clipboard.',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFF302B63),
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 14,
  );
}
