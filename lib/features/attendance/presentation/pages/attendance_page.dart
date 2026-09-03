import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';

// State Model
class Student {
  final String name;
  final int rollNo;
  String status; // "Present", "Absent", "Late"

  Student({required this.name, required this.rollNo, this.status = "Present"});
}

class AttendanceNotifier extends StateNotifier<List<Student>> {
  AttendanceNotifier()
    : super([
        Student(name: "Aarav Sharma", rollNo: 1),
        Student(name: "Diya Patel", rollNo: 2, status: "Absent"),
        Student(name: "Ishaan Kumar", rollNo: 3, status: "Late"),
        Student(name: "Neha Gupta", rollNo: 4),
      ]);

  void updateStatus(int index, String status) {
    state = [...state]..[index].status = status;
  }
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, List<Student>>(
      (ref) => AttendanceNotifier(),
    );

class AttendancePage extends ConsumerWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(attendanceProvider);
    int present = students.where((s) => s.status == "Present").length;
    int absent = students.where((s) => s.status == "Absent").length;
    int late = students.where((s) => s.status == "Late").length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Morning Attendance"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stats Grid
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: "TOTAL",
                    value: students.length.toString(),
                    color: Colors.black,
                    borderColor: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    label: "PRESENT",
                    value: present.toString(),
                    color: AppColors.darkTeal,
                    borderColor: AppColors.darkTeal,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    label: "ABSENT",
                    value: absent.toString(),
                    color: Colors.red,
                    borderColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    label: "LATE",
                    value: late.toString(),
                    color: Colors.orange,
                    borderColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search student name...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // List
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(child: Text(student.name[0])),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Roll No. ${student.rollNo.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _StatusButton(
                          label: "Present",
                          color: AppColors.primaryOrange,
                          isActive: student.status == "Present",
                          onTap: () => ref
                              .read(attendanceProvider.notifier)
                              .updateStatus(index, "Present"),
                        ),
                        const SizedBox(width: 4),
                        _StatusButton(
                          label: "Absent",
                          color: Colors.red.shade400,
                          isActive: student.status == "Absent",
                          onTap: () => ref
                              .read(attendanceProvider.notifier)
                              .updateStatus(index, "Absent"),
                        ),
                        const SizedBox(width: 4),
                        _StatusButton(
                          label: "Late",
                          color: Colors.orange,
                          isActive: student.status == "Late",
                          onTap: () => ref
                              .read(attendanceProvider.notifier)
                              .updateStatus(index, "Late"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Attendance Submitted Successfully!"),
                  ),
                ),
                icon: const Icon(Icons.send),
                label: const Text("Submit Attendance"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sub-widgets to reduce boilerplate
class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color, borderColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isActive ? color : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
