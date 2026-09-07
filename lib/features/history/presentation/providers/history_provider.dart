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

  Future<void> clearAllLocalData() async {
    await _repository.clearHistory();
    loadHistory();
  }
}
