import 'dart:io';
import 'package:flutter/material.dart';
import 'package:school_lookup_app/core/theme/app_theme.dart';
import '../../domain/models/scan_result.dart';

class ScanResultPage extends StatelessWidget {
  final ScanResult result;

  const ScanResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    // Simulated Data Science Analysis
    final analysis = _performDataScienceAnalysis(result.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Analysis Result"),
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Preview Card
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Image.file(
                File(result.imagePath),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // 2. Data Science Analysis Section
            const Text(
              "Data Science Analysis",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkTeal),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: analysis.isMatched ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: analysis.isMatched ? Colors.green : Colors.orange),
              ),
              child: Row(
                children: [
                  Icon(
                    analysis.isMatched ? Icons.check_circle : Icons.info_outline,
                    color: analysis.isMatched ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          analysis.isMatched ? "Topic Found in Dataset" : "Topic Not Recognized",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: analysis.isMatched ? Colors.green.shade800 : Colors.orange.shade800,
                          ),
                        ),
                        Text(
                          analysis.message,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Extracted Text Section
            const Text(
              "Digitized Content",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                result.text.isEmpty ? "No text detected." : result.text,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 32),

            // 4. Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("DONE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _AnalysisResult _performDataScienceAnalysis(String text) {
    final lowerText = text.toLowerCase();
    
    // Predefined Book Dataset (Simplified Simulation)
    final Map<String, List<String>> dataset = {
      "Class 8 Science (NCERT)": [
        "crop production", "microorganisms", "synthetic fibres", "materials", "metals",
        "coal", "petroleum", "combustion", "flame", "conservation", "plants", "animals",
        "cell", "reproduction", "adolescence", "force", "pressure", "friction", "sound",
        "chemical effects", "electric current", "natural phenomena", "light", "stars", "solar system",
        "pollution", "air", "water"
      ],
      "Class 7 Mathematics": [
        "integers", "fractions", "decimals", "data handling", "simple equations",
        "lines", "angles", "triangles", "congruence", "quantities", "rational numbers",
        "practical geometry", "perimeter", "area", "algebraic expressions", "exponents", "powers",
        "symmetry", "visualising solid shapes"
      ]
    };

    String matchedBook = "";
    List<String> matchedTopics = [];

    dataset.forEach((book, topics) {
      for (var topic in topics) {
        if (lowerText.contains(topic)) {
          matchedBook = book;
          matchedTopics.add(topic);
        }
      }
    });

    if (matchedTopics.isNotEmpty) {
      return _AnalysisResult(
        isMatched: true,
        message: "This content matches topics: ${matchedTopics.take(3).join(', ')} from '$matchedBook'.",
      );
    } else {
      return _AnalysisResult(
        isMatched: false,
        message: "No matching topics found in the predefined dataset for NCERT/State Board books.",
      );
    }
  }
}

class _AnalysisResult {
  final bool isMatched;
  final String message;
  _AnalysisResult({required this.isMatched, required this.message});
}
