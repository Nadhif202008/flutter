import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class OrderTrackingPage extends StatefulWidget {
  final Order order;
  final AppState appState;

  const OrderTrackingPage({
    super.key,
    required this.order,
    required this.appState,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    // Simulate real-time progress steps
    _statusTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() {
        if (widget.order.status == OrderStatus.accepted) {
          widget.order.status = OrderStatus.preparing;
        } else if (widget.order.status == OrderStatus.preparing) {
          widget.order.status = OrderStatus.onTheWay;
        } else if (widget.order.status == OrderStatus.onTheWay) {
          widget.order.status = OrderStatus.delivered;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  String _getStatusTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return 'Pesanan Diterima Restoran';
      case OrderStatus.preparing:
        return 'Makanan Sedang Dimasak 🍳';
      case OrderStatus.onTheWay:
        return 'Driver Menuju Lokasimu 🛵';
      case OrderStatus.delivered:
        return 'Makanan Sudah Sampai! 🎉';
    }
  }

  String _getStatusSubtitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return 'Restoran sedang mengonfirmasi daftar pesananmu.';
      case OrderStatus.preparing:
        return 'Koki sedang menyiapkan hidangan dengan bahan segar.';
      case OrderStatus.onTheWay:
        return 'Driver ${widget.order.driverName} sedang membawa pesananmu.';
      case OrderStatus.delivered:
        return 'Selamat menikmati hidangan lezatmu!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final status = order.status;

    return Scaffold(
      appBar: AppBar(
        title: Text('Status Pesanan #${order.id}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      status == OrderStatus.delivered
                          ? Icons.check_circle
                          : (status == OrderStatus.onTheWay ? Icons.two_wheeler : Icons.restaurant),
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getStatusTitle(status),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _getStatusSubtitle(status),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Estimasi Tiba: ${order.estimatedDelivery}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Driver Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, size: 30, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.driverName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Honda Vario • ${order.driverPlate}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: IconButton(
                      icon: const Icon(Icons.phone, color: AppColors.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Menghubungi driver ${order.driverPhone}...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Membuka fitur Chat Driver')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Timeline Stepper
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Proses Pengiriman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildStepTile('Pesanan Diterima', 'Restoran menerima pesananmu', isPassed: true),
                  _buildStepTile('Sedang Dimasak', 'Makanan disiapkan oleh koki', isPassed: status.index >= OrderStatus.preparing.index),
                  _buildStepTile('Dalam Perjalanan', 'Driver sedang mengantar ke lokasimu', isPassed: status.index >= OrderStatus.onTheWay.index),
                  _buildStepTile('Pesanan Selesai', 'Makanan sampai dan diterima', isPassed: status.index >= OrderStatus.delivered.index, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Kembali ke Beranda'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTile(String title, String subtitle, {required bool isPassed, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isPassed ? AppColors.primary : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isPassed
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isPassed ? AppColors.primary : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isPassed ? AppColors.textPrimary : Colors.grey,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
