import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/game_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class EndView extends StatelessWidget {
  const EndView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);

    final total   = game.currentPool.length;
    final score   = game.score;
    final shields = game.shields;
    final status  = shields > 0 ? 'TAMAT' : 'KECUNDANG';
    final passed  = status == 'TAMAT';
    final pct     = total > 0 ? (score / total * 100).round() : 0;

    final heroColor = passed ? AppColors.emerald : AppColors.rose;
    final heroMuted = passed ? AppColors.emeraldMuted : const Color(0xFFF87171);

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keputusan Latihan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Hero result card
                    GlassCard(
                      color: heroColor.withValues(alpha: 0.06),
                      border: Border.all(color: heroColor.withValues(alpha: 0.2)),
                      shadows: [
                        BoxShadow(
                          color: heroColor.withValues(alpha: 0.15),
                          blurRadius: 32,
                          spreadRadius: -4,
                        ),
                      ],
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: heroColor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: heroColor.withValues(alpha: 0.3), width: 2),
                            ),
                            child: Icon(
                              passed
                                  ? LucideIcons.shieldCheck
                                  : LucideIcons.shieldOff,
                              color: heroMuted,
                              size: 38,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            status,
                            style: TextStyle(
                              color: heroMuted,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            passed
                                ? 'Tahniah! Anda lulus dengan selamat.'
                                : 'Perisai anda musnah. Lebih berhati-hati.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: heroColor.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 500.ms).scale(
                          begin: const Offset(0.92, 0.92),
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        ),
                    const SizedBox(height: 16),

                    // Score stats card
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Accuracy ring
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 92,
                                height: 92,
                                child: CircularProgressIndicator(
                                  value: total > 0 ? score / total : 0,
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
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    'Tepat',
                                    style: TextStyle(
                                      color: AppColors.textMutedOf(context),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            color: AppColors.surfaceBorderOf(context),
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStat(context, '$score / $total', 'Betul',
                                  LucideIcons.target, AppColors.emerald),
                              _buildStat(context, '$shields / 3', 'Perisai',
                                  LucideIcons.shield, AppColors.cyan),
                              _buildStat(context, '$total', 'Soalan',
                                  LucideIcons.fileText, AppColors.indigo),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(
                          begin: 0.05, duration: 400.ms,
                          curve: Curves.easeOut,
                        ),
                    const SizedBox(height: 16),

                    // Results list
                    if (game.sessionResults.isNotEmpty)
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RINGKASAN KES',
                              style: TextStyle(
                                color: AppColors.textMutedOf(context),
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...game.sessionResults.map((r) =>
                                _buildResultRow(context,
                                    r.type, r.sender, r.userCorrect)),
                          ],
                        ),
                      ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
                    const SizedBox(height: 20),

                    // Action buttons
                    GradientButton(
                      label: 'MENU UTAMA',
                      icon: LucideIcons.home,
                      width: double.infinity,
                      fontSize: 12,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      borderRadius: BorderRadius.circular(16),
                      gradientColors: const [Color(0xFF106452), Color(0xFF106452)],
                      onPressed: () => game.setGameState('menu'),
                    ).animate().fadeIn(delay: 450.ms, duration: 350.ms),
                    const SizedBox(height: 10),
                    GlassButton(
                      label: 'LIHAT REKOD',
                      icon: LucideIcons.history,
                      width: double.infinity,
                      fontSize: 12,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      borderRadius: BorderRadius.circular(16),
                      onPressed: () => game.setGameState('history'),
                    ).animate().fadeIn(delay: 500.ms, duration: 350.ms),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
      BuildContext context, String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMutedOf(context),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(
      BuildContext context, String type, String sender, bool correct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            correct ? LucideIcons.checkCircle : LucideIcons.xCircle,
            color: correct ? AppColors.emerald : AppColors.rose,
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(
            type.toUpperCase(),
            style: TextStyle(
              color: AppColors.textMutedOf(context),
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              sender,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecondaryOf(context),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
