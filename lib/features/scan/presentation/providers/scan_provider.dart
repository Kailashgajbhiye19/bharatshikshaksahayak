import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/scan_result.dart';
import '../../data/repositories/scan_repository.dart';
import '../../../history/presentation/providers/history_provider.dart';

final scanServiceProvider = Provider((ref) => ScanService(ref));

class ScanService {
  final Ref _ref;
  final _picker = ImagePicker();
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  ScanService(this._ref);

  Future<ScanResult?> scanImage(String title, {required ImageSource source}) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return null;

    final inputImage = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    final result = ScanResult(
      id: const Uuid().v4(),
      title: title,
      text: recognizedText.text,
      date: DateTime.now(),
      imagePath: image.path,
    );

    await _ref.read(scanRepositoryProvider).saveScanResult(result);
    _ref.read(historyProvider.notifier).loadHistory();
    
    return result;
  }
}
