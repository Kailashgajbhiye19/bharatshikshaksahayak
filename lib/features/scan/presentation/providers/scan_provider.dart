import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/scan_result.dart';
import '../../data/repositories/scan_repository.dart';
import '../../../history/presentation/providers/history_provider.dart';

final scanServiceProvider = Provider((ref) => ScanService(ref));

/// [ScanService] handles the technical aspects of capturing and processing images.
/// It uses [ImagePicker] for capture and [Google ML Kit] for OCR.
class ScanService {
  final Ref _ref;
  final _picker = ImagePicker();
  
  // Initialize OCR engine with Latin script support.
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  ScanService(this._ref);

  /// Captures an image from the specified [source] and processes it for text.
  Future<ScanResult?> scanImage(String title, {required ImageSource source}) async {
    // 1. Capture the image
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return null;

    // 2. Process image with ML Kit OCR
    final inputImage = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    // 3. Create the data model
    final result = ScanResult(
      id: const Uuid().v4(),
      title: title,
      text: recognizedText.text,
      date: DateTime.now(),
      imagePath: image.path,
    );

    // -------------------------------------------------------------------------
    // BACKEND INTEGRATION POINT: 
    // If you want to auto-upload scans to the server, call your API service here.
    // Example: await _ref.read(apiProvider).uploadScan(result);
    // -------------------------------------------------------------------------

    // 4. Save to local storage (Hive) for offline access
    await _ref.read(scanRepositoryProvider).saveScanResult(result);
    
    // 5. Refresh the UI history list
    _ref.read(historyProvider.notifier).loadHistory();
    
    return result;
  }
}
