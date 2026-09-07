import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/scan_provider.dart';
import '../providers/qr_scan_service.dart';
import '../../../../core/theme/app_theme.dart';

class ScanCenterPage extends ConsumerWidget {
  const ScanCenterPage({super.key});

  Future<ImageSource?> _showSourcePicker(BuildContext context) async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Source",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SourceOption(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  _SourceOption(
                    icon: Icons.photo_library,
                    label: "Gallery",
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleScan(BuildContext context, WidgetRef ref, String title) async {
    final source = await _showSourcePicker(context);
    if (source == null) return;

    try {
      final result = await ref.read(scanServiceProvider).scanImage(title, source: source);
      if (result != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan saved: ${result.title}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleQrScan(BuildContext context, WidgetRef ref) async {
    final source = await _showSourcePicker(context);
    if (source == null) return;

    try {
      final code = await ref.read(qrScanServiceProvider).scanQr(source: source);
      if (code != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code Detected: $code')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Center"), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _ScanOptionCard(
                title: "Digitize Textbook",
                icon: Icons.menu_book,
                color: AppColors.primaryOrange,
                onTap: () => _handleScan(context, ref, "Textbook"),
              ),
              const SizedBox(height: 16),
              _ScanOptionCard(
                title: "Handwritten Notes",
                icon: Icons.edit_note,
                color: AppColors.darkTeal,
                onTap: () => _handleScan(context, ref, "Notes"),
              ),
              const SizedBox(height: 16),
              _ScanOptionCard(
                title: "Quick ID Scan",
                icon: Icons.badge,
                color: Colors.brown,
                onTap: () => _handleScan(context, ref, "ID Scan"),
              ),
              const SizedBox(height: 16),
              _ScanOptionCard(
                title: "QR Code / Redirect",
                icon: Icons.qr_code_scanner,
                color: Colors.deepPurple,
                onTap: () => _handleQrScan(context, ref),
              ),
              const SizedBox(height: 24),
              // Scanner Tips Card
              Card(
                color: AppColors.lightOrange.withValues(alpha: 0.5),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.primaryOrange,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Scanner Tips",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "• Ensure good, even lighting. Natural daylight works best.",
                      ),
                      Text(
                        "• Keep the document flat and parallel to the camera.",
                      ),
                      Text("• Use a contrasting background like a dark table."),
                      Text(
                        "• Tap the screen to focus if the text appears blurry.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.primaryOrange),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ScanOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ScanOptionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
