import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/scan_provider.dart';
import '../../../../core/theme/app_theme.dart';

class ScanCenterPage extends ConsumerWidget {
  const ScanCenterPage({super.key});

  Future<void> _handleScan(BuildContext context, WidgetRef ref, String title) async {
    try {
      final result = await ref.read(scanServiceProvider).scanImage(title);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Center"), centerTitle: true),
      body: Padding(
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
            const Spacer(),
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
