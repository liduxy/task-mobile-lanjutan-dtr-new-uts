import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/account_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/app_background.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AccountController _account = Get.find<AccountController>();
  final DashboardController _dashboard = Get.find<DashboardController>();
  final GetStorage _storage = GetStorage();

  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = _storage.read('notifications_enabled') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: RefreshIndicator(
          onRefresh: _account.fetchUser,
          color: const Color(0xFF7F7FD5),
          backgroundColor: const Color(0xFF24243E),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: 'Profile',
                  subtitle: 'Kelola akun dan pengaturan Anda',
                  trailing: Obx(
                    () => _account.isLoading.value
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
                        : _HeaderIconButton(
                            icon: Icons.refresh_rounded,
                            tooltip: 'Muat ulang akun',
                            onTap: _account.fetchUser,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: 16),
                      _buildQuickActions(),
                      const SizedBox(height: 16),
                      _buildSettingsCard(),
                      const SizedBox(height: 20),
                      _buildLogoutButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== Profile card ====================

  Widget _buildProfileCard() {
    return Obx(() {
      final user = _account.user.value;
      final name = user != null && user.name.trim().isNotEmpty
          ? user.name
          : (_dashboard.username.value.isNotEmpty
                ? _dashboard.username.value
                : 'Pengguna');
      final email = user != null && user.email.trim().isNotEmpty
          ? user.email
          : (_dashboard.email.value.isNotEmpty ? _dashboard.email.value : '-');
      final initial = name.trim().isEmpty
          ? '?'
          : name.trim().substring(0, 1).toUpperCase();
      final role = user?.roleLabel;

      return GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Container(
              width: 84,
              height: 84,
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
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
            if (role != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF86A8E7).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF86A8E7).withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  role,
                  style: const TextStyle(
                    color: Color(0xFF86A8E7),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (_account.errorMessage.value.isNotEmpty && user == null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orangeAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _account.errorMessage.value,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            // const SizedBox(height: 16),
            // SizedBox(
            //   width: double.infinity,
            //   child: OutlinedButton.icon(
            //     onPressed: () => Get.toNamed(AppRoutes.account),
            //     icon: const Icon(Icons.badge_rounded, size: 18),
            //     label: const Text('Lihat Detail Akun'),
            //     style: OutlinedButton.styleFrom(
            //       foregroundColor: Colors.white,
            //       side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
            //       padding: const EdgeInsets.symmetric(vertical: 12),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }

  // ==================== Quick actions ====================

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Fitur Cepat',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.15,
          children: [
            _QuickActionTile(
              icon: Icons.account_circle_rounded,
              label: 'Akun Saya',
              subtitle: 'Informasi Detail Akun',
              gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
              onTap: () => Get.toNamed(AppRoutes.account),
            ),
            _QuickActionTile(
              icon: Icons.edit_rounded,
              label: 'Edit Profil',
              subtitle: 'Perbarui data akun',
              gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
              onTap: () => _showInfoDialog(
                title: 'Edit Profil',
                message: 'Fitur edit profil akan segera tersedia. Saat ini data akun hanya dapat dilihat dari endpoint /api/user.',
                icon: Icons.edit_rounded,
              ),
            ),
            _QuickActionTile(
              icon: Icons.lock_rounded,
              label: 'Keamanan',
              subtitle: 'Password & akses',
              gradient: const [Color(0xFFF7971E), Color(0xFFFFD200)],
              onTap: () => _showInfoDialog(
                title: 'Keamanan Akun',
                message: 'Fitur ubah password dan pengaturan keamanan akan tersedia pada pembaruan berikutnya. Jangan bagikan token atau password Anda kepada siapa pun.',
                icon: Icons.shield_rounded,
              ),
            ),
            _QuickActionTile(
              icon: Icons.help_rounded,
              label: 'Bantuan',
              subtitle: 'Pusat bantuan',
              gradient: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
              onTap: () => _showInfoDialog(
                title: 'Pusat Bantuan',
                message: 'Jika Anda mengalami kendala saat menggunakan aplikasi, silakan hubungi administrator atau tim support dan sertakan detail masalah yang Anda alami.',
                icon: Icons.support_agent_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== Settings ====================

  Widget _buildSettingsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Pengaturan',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              // _SettingsRow(
              //   icon: Icons.badge_rounded,
              //   title: 'Akun Saya',
              //   subtitle: 'Informasi lengkap dari /api/user',
              //   onTap: () => Get.toNamed(AppRoutes.account),
              // ),
              // _menuDivider(),
              _SettingsRow(
                icon: Icons.password_rounded,
                title: 'Ubah Password',
                subtitle: 'Perbarui kata sandi akun',
                onTap: () => _showInfoDialog(
                  title: 'Ubah Password',
                  message: 'Fitur ubah password belum tersedia pada aplikasi versi ini.',
                  icon: Icons.password_rounded,
                ),
              ),
              _menuDivider(),
              _SettingsRow(
                icon: Icons.notifications_rounded,
                title: 'Notifikasi',
                subtitle: 'Terima pemberitahuan aplikasi',
                onTap: () => _setNotificationsEnabled(!_notificationsEnabled),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: _setNotificationsEnabled,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF7F7FD5),
                  inactiveThumbColor: Colors.white70,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              _menuDivider(),
              _SettingsRow(
                icon: Icons.privacy_tip_rounded,
                title: 'Kebijakan Privasi',
                subtitle: 'Cara kami menjaga data Anda',
                onTap: () => _showInfoDialog(
                  title: 'Kebijakan Privasi',
                  message: 'Aplikasi ini hanya menggunakan data akun (nama, email, dan role) untuk keperluan autentikasi dan menampilkan informasi profil. Data tidak dibagikan kepada pihak ketiga.',
                  icon: Icons.privacy_tip_rounded,
                ),
              ),
              _menuDivider(),
              _SettingsRow(
                icon: Icons.info_rounded,
                title: 'Tentang Aplikasi',
                subtitle: 'taskdtr v0.1.0',
                onTap: () => _showInfoDialog(
                  title: 'Tentang Aplikasi',
                  message: 'taskdtr v0.1.0\n\nAplikasi manajemen berbasis Flutter dengan GetX, GetStorage, dan API Laravel Sanctum.',
                  icon: Icons.info_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  // ==================== Handlers ====================

  void _setNotificationsEnabled(bool value) {
    setState(() => _notificationsEnabled = value);
    _storage.write('notifications_enabled', value);
  }

  Future<void> _logout() async {
    await _dashboard.logout();
  }

  void _showInfoDialog({
    required String title,
    required String message,
    IconData icon = Icons.info_outline_rounded,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF24243E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(icon, color: const Color(0xFF86A8E7), size: 32),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13.5,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFF91EAE4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuDivider() {
    return Divider(
      color: Colors.white.withValues(alpha: 0.08),
      height: 1,
      indent: 12,
      endIndent: 12,
    );
  }
}

// ==================== Reusable widgets ====================

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _HeaderIconButton({
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

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: GlassCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(colors: gradient),
                ),
                child: Icon(icon, color: Colors.white, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                child: Icon(icon, color: Colors.white70, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
