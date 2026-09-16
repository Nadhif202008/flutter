import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final AppState appState;

  const ProfilePage({super.key, required this.appState});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text('Keluar Akun'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              appState.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anda telah berhasil keluar.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage(appState: appState)),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser;
    final isLoggedIn = appState.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(
                      isLoggedIn ? Icons.person : Icons.person_outline,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoggedIn ? (user?.name ?? 'Pengguna') : 'Tamu / Belum Login',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLoggedIn
                              ? (user?.email ?? user?.phone ?? '')
                              : 'Silakan masuk untuk akses penuh fitur',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        if (isLoggedIn)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '⭐ Member VIP GrabUnlimited',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber),
                            ),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => LoginPage(appState: appState)),
                              );
                            },
                            icon: const Icon(Icons.login, size: 16, color: Colors.white),
                            label: const Text('Masuk / Daftar', style: TextStyle(fontSize: 12, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Profile Options Menu
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildProfileTile(
                    icon: Icons.account_balance_wallet,
                    title: 'Metode Pembayaran',
                    subtitle: 'GrabPay, OVO, Kartu Debit/Kredit',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: Icons.location_on_outlined,
                    title: 'Alamat Tersimpan',
                    subtitle: appState.deliveryAddress,
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: Icons.card_giftcard,
                    title: 'Voucher & Promo Saya',
                    subtitle: '3 Voucher Diskon Aktif',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: Icons.history,
                    title: 'Riwayat Transaksi',
                    subtitle: '${appState.orders.length} Pesanan sebelumnya',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: Icons.help_outline,
                    title: 'Pusat Bantuan / Help Center',
                    subtitle: 'Bantuan 24 jam mengenai kendala pesanan',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan Aplikasi',
                    subtitle: 'Notifikasi, Bahasa, Mode Gelap',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            if (isLoggedIn) ...[
              const SizedBox(height: 16),
              // Logout Tile
              Container(
                color: Colors.white,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.logout, color: Colors.red),
                  ),
                  title: const Text(
                    'Keluar Akun',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
                  ),
                  subtitle: const Text('Keluar dari sesi saat ini', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.red),
                  onTap: () => _showLogoutDialog(context),
                ),
              ),
            ],

            const SizedBox(height: 20),
            Text(
              'GrabFood Clone v1.0.0 • Miss Cindy App Assignment',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
