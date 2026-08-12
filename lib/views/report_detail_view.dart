import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../models/history_log.dart';
import '../models/scenario.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/metric_chip.dart';
import '../utils/medium_type_label.dart';
import '../providers/scenario_provider.dart';

class ReportDetailView extends StatelessWidget {
  final HistoryLog log;

  const ReportDetailView({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final scenProv = Provider.of<ScenarioProvider>(context, listen: false);
    final pct = log.total > 0 ? (log.score / log.total * 100).round() : 0;
    final passed = log.status == 'TAMAT';

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DarkPageHeader(
              title: 'Laporan Terperinci',
              subtitle: 'SEMAKAN JAWAPAN ANDA',
              onBack: () => Navigator.pop(context),
            ).animate().fadeIn(duration: 300.ms),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.square(
                                dimension: 72,
                                child: CircularProgressIndicator(
                                  value:
                                      log.total > 0 ? log.score / log.total : 0,
                                  strokeWidth: 7,
                                  backgroundColor: AppColors.surfaceBorderOf(context),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    passed ? AppColors.emerald : AppColors.rose,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$pct%',
                                    style: TextStyle(
                                      color: AppColors.textPrimaryOf(context),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    'tepat',
                                    style: TextStyle(
                                      color: AppColors.textMutedOf(context),
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              passed
                                  ? const MetricChip.emerald(label: 'TAMAT')
                                  : const MetricChip.rose(label: 'KECUNDANG'),
                              const SizedBox(height: 6),
                              Text(
                                '${log.score} / ${log.total} betul',
                                style: TextStyle(
                                  color: AppColors.textPrimaryOf(context),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.shield,
                                    size: 11,
                                    color: log.shields > 0
                                        ? AppColors.cyan
                                        : AppColors.rose,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${log.shields}/3 perisai  |  ${log.date}',
                                      style: TextStyle(
                                        color: AppColors.textMutedOf(context),
                                        fontSize: 9.5,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 10),
                    child: Text(
                      'SEMAKAN JAWAPAN',
                      style: TextStyle(
                        color: AppColors.textMutedOf(context),
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  ...log.results.asMap().entries.map(
                        (entry) => _buildQuestionCard(
                          context,
                          entry.key + 1,
                          entry.value,
                          _findScenario(scenProv, entry.value.id),
                        ),
                      ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'INISIATIF CELIK DIGITAL WARGA EMAS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMutedOf(context),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    int num,
    ScenarioResult r,
    Scenario? scenario,
  ) {
    final recommendedActions = scenario?.recommendedActions ?? const [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: EdgeInsets.zero,
        border: Border.all(
          color: r.userCorrect
              ? AppColors.emerald.withValues(alpha: 0.3)
              : AppColors.rose.withValues(alpha: 0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: r.userCorrect
                    ? AppColors.emeraldBadgeBg
                    : AppColors.roseBadgeBg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    r.userCorrect
                        ? LucideIcons.checkCircle
                        : LucideIcons.xCircle,
                    color: r.userCorrect
                        ? AppColors.emeraldMuted
                        : AppColors.rose,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Soalan $num  |  ${mediumTypeLabel(r.type)}',
                    style: TextStyle(
                      color: AppColors.textMutedOf(context),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.user,
                        color: AppColors.textMutedOf(context),
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        r.sender,
                        style: TextStyle(
                          color: AppColors.textSecondaryOf(context),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        LucideIcons.tag,
                        color: AppColors.textMutedOf(context),
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Kategori Penipuan: ${normalizeCategoryLabel(r.category)}',
                          style: TextStyle(
                            color: AppColors.textSecondaryOf(context),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildThreatBadge(r.threatLevel),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDifficultyBadge(r.difficulty),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOf(context),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.surfaceBorderOf(context)),
                    ),
                    child: Text(
                      r.message,
                      style: TextStyle(
                        color: AppColors.textPrimaryOf(context),
                        fontSize: 10.5,
                        height: 1.4,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JAWAPAN ANDA:',
                    style: TextStyle(
                      color: AppColors.textMutedOf(context),
                      fontSize: 7.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAnswerStep(
                    context: context,
                    title: '1. KENAL PASTI',
                    answer: r.identifyAnswerText ?? 'Tidak direkodkan',
                    highlight: (r.identifyAnswerText ?? '').isNotEmpty,
                  ),
                  const SizedBox(height: 10),
                  _buildRedFlagStep(
                    context: context,
                    answers: r.redFlagAnswers,
                  ),
                  const SizedBox(height: 10),
                  _buildAnswerStep(
                    context: context,
                    title: '3. RESPON',
                    answer: r.userChoiceText ?? 'Tidak direkodkan',
                    highlight: (r.userChoiceText ?? '').isNotEmpty,
                    correct: r.userCorrect,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'PENJELASAN',
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.emerald,
                          fontSize: 14,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          r.explanation,
                          style: TextStyle(
                            color: AppColors.textPrimaryOf(context),
                            fontSize: 10.5,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'TINDAKAN YANG DISYORKAN',
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (recommendedActions.isEmpty)
                    Text(
                      'Tiada tindakan yang disyorkan direkodkan untuk senario ini.',
                      style: TextStyle(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    ...recommendedActions.asMap().entries.map(
                          (entry) => Padding(
                            padding: EdgeInsets.only(
                              bottom: entry.key == recommendedActions.length - 1
                                  ? 0
                                  : 6,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '•',
                                  style: TextStyle(
                                    color: AppColors.emerald,
                                    fontSize: 14,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(
                                      color: AppColors.textPrimaryOf(context),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreatBadge(String level) {
    final isHigh = level.toUpperCase() == 'TINGGI';
    return isHigh
        ? MetricChip.rose(
            label: 'Tahap Ancaman: ${_threatLevelLabel(level)}',
            fontSize: 8.5,
          )
        : MetricChip.amber(
            label: 'Tahap Ancaman: ${_threatLevelLabel(level)}',
            fontSize: 8.5,
          );
  }

  Widget _buildDifficultyBadge(String level) {
    return MetricChip.indigo(
      label: 'Tahap Kesukaran: ${_difficultyLevelLabel(level)}',
      fontSize: 8.5,
    );
  }

  Widget _buildAnswerStep({
    required BuildContext context,
    required String title,
    required String answer,
    required bool highlight,
    bool? correct,
  }) {
    final Color chipColor = correct == null
        ? AppColors.textSecondaryOf(context)
        : (correct ? AppColors.emeraldMuted : AppColors.rose);
    final Color bgColor = correct == null
        ? AppColors.surfaceBorderOf(context).withValues(alpha: 0.35)
        : (correct
            ? AppColors.emeraldBadgeBg
            : AppColors.roseBadgeBg);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textMutedOf(context),
            fontSize: 7.8,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: highlight ? bgColor : AppColors.surfaceOf(context).withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: highlight
                  ? (correct == null
                      ? AppColors.surfaceBorderOf(context)
                      : (correct
                          ? AppColors.emerald.withValues(alpha: 0.25)
                          : AppColors.rose.withValues(alpha: 0.25)))
                  : AppColors.surfaceBorderOf(context),
            ),
          ),
          child: Text(
            answer,
            style: TextStyle(
              color: chipColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRedFlagStep({
    required BuildContext context,
    List<String>? answers,
  }) {
    final safeAnswers = answers ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. RED FLAGS',
          style: TextStyle(
            color: AppColors.textMutedOf(context),
            fontSize: 7.8,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        if (safeAnswers.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context).withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.surfaceBorderOf(context)),
            ),
            child: Text(
              'Tiada red flags direkodkan.',
              style: TextStyle(
                color: AppColors.textSecondaryOf(context),
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          )
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: safeAnswers
                .map(
                  (word) => MetricChip.muted(
                    label: word.toUpperCase(),
                    fontSize: 8,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  String _threatLevelLabel(String level) {
    switch (level.toLowerCase()) {
      case 'tinggi':
        return 'Tinggi';
      case 'sederhana':
        return 'Sederhana';
      case 'rendah':
        return 'Rendah';
      default:
        if (level.isEmpty) return '';
        return level[0].toUpperCase() + level.substring(1).toLowerCase();
    }
  }

  String _difficultyLevelLabel(String level) {
    switch (level.toLowerCase()) {
      case 'mudah':
        return 'Mudah';
      case 'sederhana':
        return 'Sederhana';
      case 'sukar':
        return 'Sukar';
      default:
        if (level.isEmpty) return '';
        return level[0].toUpperCase() + level.substring(1).toLowerCase();
    }
  }

  Scenario? _findScenario(ScenarioProvider scenProv, int id) {
    final index = scenProv.masterScenarios.indexWhere((s) => s.id == id);
    if (index == -1) return null;
    return scenProv.masterScenarios[index];
  }
}
