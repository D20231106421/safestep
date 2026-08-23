import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/game_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    final historyProv = Provider.of<HistoryProvider>(context, listen: false);
    final scenario = game.currentScenario;
    final isCorrect = game.lastChoiceCorrect == true;

    if (scenario == null) return const SizedBox.shrink();

    final heroColor = isCorrect ? AppColors.emerald : AppColors.rose;

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Result header banner ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: heroColor.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(color: heroColor.withValues(alpha: 0.2), width: 1),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: heroColor.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(color: heroColor.withValues(alpha: 0.3), width: 2),
                    ),
                    child: Icon(
                      isCorrect ? LucideIcons.check : LucideIcons.x,
                      color: isCorrect ? AppColors.emeraldMuted : AppColors.rose,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isCorrect ? 'PILIHAN BIJAK!' : 'BAHAYA!',
                    style: TextStyle(
                      color: isCorrect ? AppColors.emeraldMuted : AppColors.rose,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCorrect
                        ? 'Anda membuat keputusan yang tepat.'
                        : 'Tindakan ini berisiko tinggi!',
                    style: TextStyle(
                      color: AppColors.textSecondaryOf(context),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            // ── Content ───────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // PDRM risk analysis card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.bot, color: AppColors.emerald, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'ANALISIS:',
                              style: TextStyle(
                                color: AppColors.textMutedOf(context),
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: heroColor,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            game.outcomeFeedback,
                            style: TextStyle(
                              color: AppColors.textPrimaryOf(context),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
                  const SizedBox(height: 16),

                  // Recommended actions
                  if (scenario.recommendedActions.isNotEmpty) ...[
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                LucideIcons.checkSquare,
                                color: AppColors.emerald,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'TINDAKAN YANG DISYORKAN:',
                                style: TextStyle(
                                  color: AppColors.textMutedOf(context),
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...scenario.recommendedActions.map(
                            (action) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    LucideIcons.chevronRight,
                                    color: AppColors.emerald,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      action,
                                      style: TextStyle(
                                        color: AppColors.textSecondaryOf(context),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 250.ms, duration: 350.ms),
                  ],
                ],
              ),
            ),

            // ── Action button ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: GradientButton(
                label: game.currentIndex < game.currentPool.length - 1 && game.shields > 0
                    ? 'SOALAN SETERUSNYA'
                    : 'LIHAT KEPUTUSAN KES',
                icon: LucideIcons.chevronRight,
                width: double.infinity,
                fontSize: 12,
                padding: const EdgeInsets.symmetric(vertical: 15),
                borderRadius: BorderRadius.circular(16),
                gradientColors: const [Color(0xFF106452), Color(0xFF106452)],
                onPressed: () => game.nextScenario(historyProv),
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 350.ms),
          ],
        ),
      ),
    );
  }
}
