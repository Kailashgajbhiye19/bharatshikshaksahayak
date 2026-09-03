import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/history_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Upload & Clear Sync',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sync Data'),
                  content: const Text('This will upload your data and clear local history. Continue?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sync')),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(historyProvider.notifier).syncAndClear();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('History synced and cleared successfully.')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('No scan history found.'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  leading: const Icon(Icons.document_scanner),
                  title: Text(item.title),
                  subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(item.date)),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => DraggableScrollableSheet(
                        expand: false,
                        builder: (context, scrollController) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: 8),
                                Text(DateFormat('MMMM dd, yyyy - HH:mm').format(item.date)),
                                const Divider(height: 32),
                                const Text('Recognized Text:', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(item.text),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
