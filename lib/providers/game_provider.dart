import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/scenario.dart';
import '../models/history_log.dart';
import '../services/api_service.dart';
import 'history_provider.dart';

class GameProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Core navigation state
  String _gameState = 'menu'; // 'menu' | 'choose_category' | 'playing' | 'feedback' | 'end' | 'trends' | 'history' | 'manage_sim'
  
  // Game session states
  List<Scenario> _currentPool = [];
  int _currentIndex = 0;
  int _score = 0;
  int _shields = 3;
  bool _isTyping = false;
  
  bool? _lastChoiceCorrect;
  String _outcomeFeedback = '';
  bool _isAnalyzing = false;
  List<ScenarioResult> _sessionResults = [];

  // Steps system states
  String _playStep = 'identify'; // 'identify' | 'red_flags' | 'respond'
  
  // Step 1 states
  bool? _identifiedIsScam;
  String? _identifyFeedback;
  bool? _isIdentifyCorrect;

  // Step 2 states
  List<String> _foundRedFlags = [];
  String _redFlagMessage = '';
  bool _showPlayHint = false;

  // Getters
  String get gameState => _gameState;
  List<Scenario> get currentPool => _currentPool;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int get shields => _shields;
  bool get isTyping => _isTyping;
  bool? get lastChoiceCorrect => _lastChoiceCorrect;
  String get outcomeFeedback => _outcomeFeedback;
  bool get isAnalyzing => _isAnalyzing;
  List<ScenarioResult> get sessionResults => _sessionResults;
  String get playStep => _playStep;
  
  bool? get identifiedIsScam => _identifiedIsScam;
  String? get identifyFeedback => _identifyFeedback;
  bool? get isIdentifyCorrect => _isIdentifyCorrect;
  
  List<String> get foundRedFlags => _foundRedFlags;
  String get redFlagMessage => _redFlagMessage;
  bool get showPlayHint => _showPlayHint;

  Scenario? get currentScenario =>
      _currentPool.isNotEmpty && _currentIndex < _currentPool.length
          ? _currentPool[_currentIndex]
          : null;

  void setGameState(String state) {
    _gameState = state;
    notifyListeners();
  }

  void setShowPlayHint(bool val) {
    _showPlayHint = val;
    notifyListeners();
  }

  void triggerTyping() {
    _isTyping = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 800), () {
      _isTyping = false;
      notifyListeners();
    });
  }

  // Check if a word qualifies as a red flag (suspicious trigger word)
  bool isWordRedFlag(String word) {
    final clean = word
        .toLowerCase()
        .replaceAll(RegExp(r'[.,\/#!$%\^&\*;:{}=\-_`~()?"' "'" r'\[\]]'), '')
        .trim();
        
    if (clean.length < 3) return false;

    const triggers = [
      "http", "https", "clicks-verify", "bankislam-cancel", "mahkamah-e-filing", "petronas-rezeki-rahmah",
      "shopee-bonanza", "pos-laju-redelivery", "netflix-update", "netflix-billing", "video-viral", "pinjaman-ekspres",
      "shariah-crypto", "batal", "verify", "dinyahaktifkan", "gantung", "sekat", "cvv", "tac", "otp", "rebat", "hadiah",
      "menang", "pemenang", "transit", "segera", "serta-merta", "cepat", "komisen", "saman", "tuntutan", "mahkamah",
      "polis", "inspektor", "sarjan", "lhdn", "petronas", "shopee", "mencurigakan", "waran", "pemindahan", "transfer",
      "clicks", "secure", "laju", "kurier", "teksi", "cucu", "menangis", "adik", "mak", "ibu", "tok", "dadah", "jenayah",
      "yuran", "deposit", "klik", "layari", "kemaskini", "viral", "video", "pinjaman", "pelaburan", "kripto", "crypto",
      "paypal", "e-filing", "ikat", "jamin", "tebus", ".shop", ".top", ".click", ".info", ".apk", "sistem_semakan_pdrm"
    ];

    return triggers.any((t) {
      final cleanT = t
          .toLowerCase()
          .replaceAll(RegExp(r'[.,\/#!$%\^&\*;:{}=\-_`~()?"' "'" r'\[\]]'), '')
          .trim();
      return clean.contains(cleanT);
    });
  }

  // Context Hint Builder for Warga Emas
  String getScenarioHint(Scenario? scen) {
    if (scen == null) return "Berhati-hati dengan desakan masa, pautan web yang janggal, atau arahan melakukan pindahan wang kecemasan.";
    
    if (scen.type == 'phone') {
      return "PANDUAN: Scammer telefon (vishing/Macau scam) sering mendakwa dari balai polis atau bank, bercakap dengan nada tegas/menakutkan, mendesak pindahan wang ke akaun asing segera. Cari perkataan gertakan seperti 'Waran', 'Transit', 'Jenayah' atau 'Lokap'.";
    }
    if (scen.type == 'whatsapp') {
      return "PANDUAN: Scammer WhatsApp gemar menyamar sebagai institusi sah atau kenalan/anak dalam kesusahan. Mereka sering meminta kod TAC/OTP atau mendesak anda memasang fail .apk berbahaya. Cari perkataan 'Batal', '.apk', atau pinjaman 'Segera'.";
    }
    if (scen.type == 'email') {
      return "PANDUAN: E-mel pancingan data (phishing) datang daripada alamat yang mencurigakan (bukan domain korporat rasmi) dan membekalkan pautan luar palsu untuk menuntut maklumat perbankan peribadi anda. Cari pautan yang kelihatan asing.";
    }
    if (scen.type == 'sms') {
      return "PANDUAN: SMS palsu (smishing) sering meniru jenama terkemuka (seperti Pos Laju, CIMB, atau LHDN) dan menuntut anda menekan pautan .click/.info/.top untuk membetulkan status akaun atau alamat bungkusan.";
    }
    return "PANDUAN: Kenal pasti ciri manipulasi psikologi siber seperti desakan masa (24 jam), tawaran hadiah lumayan (RM5,000), atau ugutan tindakan sivil/jenayah.";
  }

  bool isScenarioInId(Scenario s, String catId) {
    final cat = normalizeCategoryLabel(s.category);
    if (catId == 'tech_support') {
      return cat == kCategoryTechSupport ||
          cat.contains('Sokongan Teknikal') ||
          cat.contains('Tech Support');
    }
    if (catId == 'authority') {
      return cat == kCategoryAuthority ||
          cat.contains('Agensi Kerajaan') ||
          cat.contains('Pihak Berkuasa') ||
          cat.contains('Authority');
    }
    if (catId == 'giveaway') {
      return cat == kCategoryGiveaway ||
          cat.contains('Cabutan Bertuah') ||
          cat.contains('Hadiah Palsu') ||
          cat.contains('Giveaways');
    }
    if (catId == 'phishing') {
      return cat == kCategoryPhishing ||
          cat.contains('Phishing') ||
          cat.contains('Smishing');
    }
    if (catId == 'family') {
      return cat == kCategoryFamily ||
          cat.contains('Penyamaran Keluarga') ||
          cat.contains('Family Impersonation');
    }
    if (catId == 'others') {
      return cat == kCategoryOthers ||
          (!isScenarioInId(s, 'tech_support') &&
              !isScenarioInId(s, 'authority') &&
              !isScenarioInId(s, 'giveaway') &&
              !isScenarioInId(s, 'phishing') &&
              !isScenarioInId(s, 'family'));
    }
    return false;
  }

  // Start new training pool based on category selection
  void startNewGameWithCategory(String catId, List<Scenario> masterList) {
    final activeScenarios = masterList.where((s) => s.isActive).toList();
    if (activeScenarios.isEmpty) return;

    List<Scenario> filtered = [];
    if (catId == 'all') {
      filtered = List.from(activeScenarios);
    } else {
      filtered = activeScenarios.where((s) => isScenarioInId(s, catId)).toList();
    }

    if (filtered.isEmpty) return;

    // Shuffle and pick
    filtered.shuffle(Random());
    _currentPool = filtered;
    _currentIndex = 0;
    _score = 0;
    _shields = 3;
    _sessionResults = [];
    
    // Reset steps states
    _playStep = 'identify';
    _identifiedIsScam = null;
    _identifyFeedback = null;
    _isIdentifyCorrect = null;
    _foundRedFlags = [];
    _redFlagMessage = '';
    _showPlayHint = false;

    _gameState = 'playing';
    notifyListeners();
    triggerTyping();
  }

  // Step 1 check
  void handleIdentifyClick(bool userSaysScam) {
    if (_identifiedIsScam != null) return;
    _identifiedIsScam = userSaysScam;

    final scenario = currentScenario;
    if (scenario == null) return;

    final bool correctValue = scenario.isScam;
    final bool isCorrect = userSaysScam == correctValue;
    _isIdentifyCorrect = isCorrect;

    if (isCorrect) {
      if (correctValue) {
        _identifyFeedback = "Tepat Sekali! Anda bijak. Ini sememangnya penipuan siber yang sangat merbahaya. (Scam)";
      } else {
        _identifyFeedback = "Tepat Sekali! Anda bijak. Ini sememangnya bukan penipuan siber dan selamat.(Bukan scam)";
      }
    } else {
      if (correctValue) {
        _identifyFeedback = "Salah! Ini sebenarnya adalah satu penipuan siber.(Scam)";
      } else {
        _identifyFeedback = "Salah! Ini sebenarnya bukan penipuan siber.(Bukan scam)";
      }
      _shields = max(0, _shields - 1);
    }
    notifyListeners();
  }

  // Step 2 selection
  void handleWordClick(String word, bool isFlag) {
    final cleanWord = word
        .toLowerCase()
        .replaceAll(RegExp(r'[.,\/#!$%\^&\*;:{}=\-_`~()?"' "'" r'\[\]]'), '')
        .trim();

    if (cleanWord.isEmpty || cleanWord.length < 2) return;
    if (_foundRedFlags.contains(cleanWord)) return;

    _foundRedFlags.add(cleanWord);

    if (isFlag) {
      _redFlagMessage = 'Hebat! "$word" ialah bukti Red Flag siber yang sah. Modus operandi ini direka khas untuk memperdaya mangsa.';
    } else {
      _redFlagMessage = '"$word" ialah perkataan biasa. Cuba cari pautan asing, desakan masa, atau permintaan maklumat bank.';
    }
    notifyListeners();
  }

  void skipToStep3() {
    _playStep = 'respond';
    _redFlagMessage = '';
    notifyListeners();
  }

  void goToStep2() {
    _playStep = 'red_flags';
    notifyListeners();
  }

  // Step 3 API Evaluation
  Future<void> analyzeUserReply(String selectedText) async {
    if (_isAnalyzing || currentScenario == null) return;
    _isAnalyzing = true;
    notifyListeners();

    final scenario = currentScenario!;
    try {
      final result = await _apiService.analyzeReply(
        message: scenario.message,
        reply: selectedText,
        scenario: scenario,
      );

      _handleActionOutcome(result.isCorrect, '${result.feedback}\n\n${result.why}', selectedText);
    } catch (_) {
      // Direct local fallback is already built into apiService, so this catch shouldn't trigger under normal conditions
      _handleActionOutcome(false, "Sistem ralat menghubungi AI.", selectedText);
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  void _handleActionOutcome(bool isCorrect, String feedback, String selectedText) {
    final scenario = currentScenario!;
    
    if (!isCorrect) {
      _shields = max(0, _shields - 1);
    }

    final currentResult = ScenarioResult(
      id: scenario.id,
      type: scenario.type,
      category: scenario.category,
      difficulty: scenario.difficulty,
      threatLevel: scenario.threatLevel,
      technique: scenario.technique,
      sender: scenario.sender,
      timestamp: scenario.timestamp,
      message: scenario.message,
      isScam: scenario.isScam,
      explanation: scenario.explanation,
      identifyAnswerText: _identifiedIsScam == null
          ? null
          : (_identifiedIsScam! ? 'Ya, Ini Scam!' : 'Tidak, Ini bukan scam'),
      redFlagAnswers: List<String>.from(_foundRedFlags),
      userChoiceText: selectedText,
      userCorrect: isCorrect,
      userFeedback: feedback,
      shieldsRemainingAtStep: _shields,
    );

    _sessionResults.add(currentResult);
    _lastChoiceCorrect = isCorrect;
    _outcomeFeedback = feedback;

    if (isCorrect) {
      _score += 1;
    }

    _gameState = 'feedback';
    notifyListeners();
  }

  // Next Round flow
  void nextScenario(HistoryProvider historyProvider) {
    if (_shields <= 0) {
      finalizeSession(historyProvider);
      return;
    }

    if (_currentIndex < _currentPool.length - 1) {
      _currentIndex += 1;
      _playStep = 'identify';
      _identifiedIsScam = null;
      _identifyFeedback = null;
      _isIdentifyCorrect = null;
      _foundRedFlags = [];
      _redFlagMessage = '';
      _showPlayHint = false;
      _gameState = 'playing';
      notifyListeners();
      triggerTyping();
    } else {
      finalizeSession(historyProvider);
    }
  }

  void finalizeSession(HistoryProvider historyProvider) {
    final dateString = _formatCurrentMalayDate();
    
    final newReport = HistoryLog(
      id: DateTime.now().millisecondsSinceEpoch,
      date: dateString,
      score: _score,
      total: _currentPool.length,
      shields: _shields,
      status: _shields > 0 ? 'TAMAT' : 'KECUNDANG',
      results: _sessionResults,
    );

    historyProvider.addLog(newReport);
    _gameState = 'end';
    notifyListeners();
  }

  String _formatCurrentMalayDate() {
    final now = DateTime.now();
    final List<String> months = [
      'Jan', 'Feb', 'Mac', 'Apr', 'Mei', 'Jun', 'Jul', 'Ogo', 'Sep', 'Okt', 'Nov', 'Dis'
    ];
    final day = now.day.toString();
    final month = months[now.month - 1];
    final year = now.year.toString();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    
    return '$day $month $year, $hour:$minute';
  }
}
