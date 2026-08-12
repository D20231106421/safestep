class ScenarioResult {
  final int id;
  final String type;
  final String category;
  final String difficulty;
  final String threatLevel;
  final String technique;
  final String sender;
  final String timestamp;
  final String message;
  final bool isScam;
  final String explanation;
  final String? identifyAnswerText;
  final List<String> redFlagAnswers;
  final String? userChoiceText;
  final bool userCorrect;
  final String userFeedback;
  final int shieldsRemainingAtStep;

  ScenarioResult({
    required this.id,
    required this.type,
    required this.category,
    required this.difficulty,
    required this.threatLevel,
    required this.technique,
    required this.sender,
    required this.timestamp,
    required this.message,
    required this.isScam,
    required this.explanation,
    this.identifyAnswerText,
    this.redFlagAnswers = const [],
    this.userChoiceText,
    required this.userCorrect,
    required this.userFeedback,
    required this.shieldsRemainingAtStep,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'category': category,
        'difficulty': difficulty,
        'threatLevel': threatLevel,
        'technique': technique,
        'sender': sender,
        'timestamp': timestamp,
        'message': message,
        'isScam': isScam,
        'explanation': explanation,
        'identifyAnswerText': identifyAnswerText,
        'redFlagAnswers': redFlagAnswers,
        'userChoiceText': userChoiceText,
        'userCorrect': userCorrect,
        'userFeedback': userFeedback,
        'shieldsRemainingAtStep': shieldsRemainingAtStep,
      };

  factory ScenarioResult.fromJson(Map<String, dynamic> json) {
    final identifyAnswer = json['identifyAnswerText'] as String?;
    final rawRedFlags = json['redFlagAnswers'];
    final redFlags = rawRedFlags is List
        ? rawRedFlags.map((e) => e.toString()).toList()
        : <String>[];

    return ScenarioResult(
      id: json['id'] as int,
      type: json['type'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String? ?? 'Sederhana',
      threatLevel: json['threatLevel'] as String? ?? 'TINGGI',
      technique: json['technique'] as String? ?? 'Social Engineering',
      sender: json['sender'] as String,
      timestamp: json['timestamp'] as String? ?? 'Terkini',
      message: json['message'] as String,
      isScam: json['isScam'] as bool? ?? true,
      explanation: json['explanation'] as String? ?? '',
      identifyAnswerText: identifyAnswer,
      redFlagAnswers: redFlags,
      userChoiceText: json['userChoiceText'] as String?,
      userCorrect: json['userCorrect'] as bool? ?? false,
      userFeedback: json['userFeedback'] as String? ?? '',
      shieldsRemainingAtStep: json['shieldsRemainingAtStep'] as int? ?? 3,
    );
  }
}

class HistoryLog {
  final int id;
  final String date;
  final int score;
  final int total;
  final int shields;
  final String status; // 'TAMAT' | 'KECUNDANG'
  final List<ScenarioResult> results;

  HistoryLog({
    required this.id,
    required this.date,
    required this.score,
    required this.total,
    required this.shields,
    required this.status,
    required this.results,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'score': score,
        'total': total,
        'shields': shields,
        'status': status,
        'results': results.map((r) => r.toJson()).toList(),
      };

  factory HistoryLog.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List? ?? [];
    List<ScenarioResult> res = resultsList
        .map((e) => ScenarioResult.fromJson(e as Map<String, dynamic>))
        .toList();

    return HistoryLog(
      id: json['id'] as int,
      date: json['date'] as String,
      score: json['score'] as int,
      total: json['total'] as int,
      shields: json['shields'] as int,
      status: json['status'] as String,
      results: res,
    );
  }
}
