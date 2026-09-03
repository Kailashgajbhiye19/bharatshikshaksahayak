import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_lookup_app/features/scan/domain/models/scan_result.dart';
import 'package:school_lookup_app/features/scan/data/repositories/scan_repository.dart';

final historyProvider = StateNotifierProvider<HistoryNotifier, List<ScanResult>>((ref) {
  return HistoryNotifier(ref.watch(scanRepositoryProvider));
});

class HistoryNotifier extends StateNotifier<List<ScanResult>> {
  final ScanRepository _repository;

  HistoryNotifier(this._repository) : super([]) {
    loadHistory();
  }

  void loadHistory() {
    state = _repository.getScanHistory();
  }

  Future<void> syncAndClear() async {
    // In a real app, you would upload to a server here.
    // Requirement 4: Provide a way to "Upload/Sync" data, which then clears the local history and starts a fresh 30-day cycle.
    await _repository.clearHistory();
    loadHistory();
  }
}
