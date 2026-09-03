import 'package:flutter/material.dart';
import 'package:school_lookup_app/core/theme/app_theme.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teaching Resources"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "My Subjects",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _ResourceFolder(
            title: "Class 8 Science",
            count: 12,
            color: AppColors.primaryOrange,
          ),
          _ResourceFolder(
            title: "Class 7 Mathematics",
            count: 8,
            color: AppColors.darkTeal,
          ),
          const SizedBox(height: 24),
          const Text(
            "Syllabus & Guides",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
            title: const Text("NCERT Science Guide 2024"),
            subtitle: const Text("PDF • 4.2 MB"),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
            title: const Text("Math Lesson Plans Term 1"),
            subtitle: const Text("PDF • 2.8 MB"),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceFolder extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _ResourceFolder({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(Icons.folder, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$count Items"),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
