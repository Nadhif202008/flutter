import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  final AppState appState;

  const ProfilePage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Header Profile Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ahmad Nadhif',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text('+62 812-3456-7890', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 6),
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
