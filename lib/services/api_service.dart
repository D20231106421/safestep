import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/scenario.dart';

class ApiAnalysisResult {
  final bool isCorrect;
  final String feedback;
  final String why;

  ApiAnalysisResult({
    required this.isCorrect,
    required this.feedback,
    required this.why,
  });
}

class ApiService {
  // Configurable endpoint for the proxy Express server
  static String proxyServerUrl = 'http://localhost:3000';
  
  // Optional direct client-side API Key
  static String? geminiApiKey;

  // Primary evaluation method
  Future<ApiAnalysisResult> analyzeReply({
    required String message,
    required String reply,
    required Scenario scenario,
  }) async {
    // 1. Try to contact local/configured Express server proxy first (hiding API keys)
    try {
      final response = await http.post(
        Uri.parse('$proxyServerUrl/api/analyze-reply'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message, 'reply': reply}),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return ApiAnalysisResult(
          isCorrect: decoded['isCorrect'] as bool? ?? false,
          feedback: decoded['feedback'] as String? ?? '',
          why: decoded['why'] as String? ?? '',
        );
      }
    } catch (_) {
      // Fail silently and try next fallback
    }

    // 2. Fallback: Try direct client-side Gemini call if api key is provided
    if (geminiApiKey != null && geminiApiKey!.trim().isNotEmpty) {
      try {
        final model = GenerativeModel(
          model: 'gemini-3.5-flash',
          apiKey: geminiApiKey!,
          systemInstruction: Content.system(
            'Anda adalah pakar pencegahan penipuan siber dari Jabatan Siasatan Jenayah Komersil (JSJK) PDRM & SKMM.'
          ),
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            responseSchema: Schema.object(
              properties: {
                'isCorrect': Schema.boolean(
                  description: "True if the response is completely safe/protective (e.g. telling them they're reporting to police or refusing scam), false if it engages/trusts the scammer or compromises safety"
                ),
                'feedback': Schema.string(
                  description: "A short, sharp, highly professional and direct warning or advice in Malay concerning the choice"
                ),
                'why': Schema.string(
                  description: "An in-depth explanation in Malay on why this action is safe or dangerous"
                ),
              },
              requiredProperties: ['isCorrect', 'feedback', 'why'],
            ),
          ),
        );

        final payloadText = '''Sila analisis pilihan jawapan berikut:
Mesej Scam: "$message"
Pilihan Jawapan Pengguna: "$reply"

Tentukan jika jawapan itu selamat atau mengundang bahaya. Secara umum, membalas mesej penipu atau mengikut arahan mereka adalah salah (berbahaya). Menolak dengan tegas atau mengancam laporan polis, atau mengabaikan/sekat biasanya selamat. Sila berikan keputusan dan maklum balas dalam Bahasa Melayu.''';

        final content = [Content.text(payloadText)];
        final response = await model.generateContent(content).timeout(const Duration(seconds: 8));
        
        if (response.text != null) {
          final decoded = json.decode(response.text!);
          return ApiAnalysisResult(
            isCorrect: decoded['isCorrect'] as bool? ?? false,
            feedback: decoded['feedback'] as String? ?? '',
            why: decoded['why'] as String? ?? '',
          );
        }
      } catch (_) {
        // Direct API failed, proceed to local fallback
      }
    }

    // 3. Last Fallback: Static rule evaluation (identical to React's frontend local fallback)
    final bool isActionSafe = reply == 'Saya abaikan dan padam mesej ini tanpa klik pautan.' ||
        reply == 'Saya terus sekat (block) nombor pengirim ini di telefon saya.';

    final matchedOpt = scenario.replyOptions.firstWhere(
      (o) => o.text == reply,
      orElse: () => ReplyOption(text: reply, safety: isActionSafe ? 'selamat' : 'bahaya'),
    );

    final String safetyLevel = matchedOpt.safety;
    final bool isCorrect = safetyLevel == 'selamat';

    String feedback = '';
    String why = '';

    if (isCorrect) {
      feedback = 'Tindakan Cemerlang!';
      why = 'Anda menolak taktik tipu muslihat scammer dengan tegas dan mengekalkan privasi anda secara selamat.';
    } else if (safetyLevel == 'bahaya') {
      feedback = 'Berisiko tinggi!';
      why = 'Menjawab atau bertanya lanjut menunjukkan nombor anda aktif, membolehkan scammer melancarkan taktik emosi lanjutan.';
    } else {
      feedback = 'Sangat Bahaya!';
      why = 'Menyerahkan butiran perbankan, maklumat sulit atau bersetuju dengan pindahan wang akan menyebabkan kerugian kewangan mutlak.';
    }

    return ApiAnalysisResult(
      isCorrect: isCorrect,
      feedback: '$feedback $why',
      why: '',
    );
  }
}
