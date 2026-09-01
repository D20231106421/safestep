import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/game_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/phishing_logo.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context, listen: false);
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // ── Branding Block ───────────────────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PhishingLogo(size: 84)
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .scale(
                          begin: const Offset(0.85, 0.85),
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        ),
                    const SizedBox(height: 14),
                    Text(
                      'SafeStep',
                      style: AppTextStyles.displayLarge.copyWith(
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                    const SizedBox(height: 8),
                    // Solid emerald badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldBadgeBgOf(context),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'SIBER ANTI-SCAM MALAYSIA',
                        style: TextStyle(
                          color: AppColors.emeraldBadgeTextOf(context),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Navigation Cards ─────────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Primary CTA — gradient card with emerald glow
                    _buildPrimaryCard(
                      title: 'MULA LATIHAN',
                      subtitle: 'Uji & latih Street Smarts siber',
                      icon: LucideIcons.play,
                      onTap: () => game.setGameState('choose_category'),
                      delay: 300,
                    ),
                    const SizedBox(height: 10),
                    _buildNavCard(
                      context,
                      title: 'PANDUAN PENIPUAN',
                      subtitle: 'Kes terkini Malaysia & push alert',
                      icon: LucideIcons.bell,
                      iconColor: AppColors.indigoBadgeTextOf(context),
                      iconBgColor: AppColors.indigoBadgeBgOf(context),
                      onTap: () => game.setGameState('trends'),
                      delay: 380,
                    ),
                    const SizedBox(height: 10),
                    _buildNavCard(
                      context,
                      title: 'SEJARAH LATIHAN',
                      subtitle: 'Semak laporan prestasi lama',
                      icon: LucideIcons.history,
                      iconColor: AppColors.emeraldBadgeTextOf(context),
                      iconBgColor: AppColors.emeraldBadgeBgOf(context),
                      onTap: () => game.setGameState('history'),
                      delay: 420,
                    ),
                    const SizedBox(height: 10),
                    _buildNavCard(
                      context,
                      title: 'KATALOG SENARIO',
                      subtitle: 'Tambah & selia taktik baharu',
                      icon: LucideIcons.fileText,
                      iconColor: AppColors.mutedBadgeTextOf(context),
                      iconBgColor: AppColors.mutedBadgeBgOf(context),
                      onTap: () => game.setGameState('manage_sim'),
                      delay: 460,
                    ),
                  ],
                ),
              ),

              // ── Bottom Bar Row (Settings button on Bottom-Left) ──────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    // Settings icon button — 48×48 solid touch target
                    InkWell(
                      onTap: () => game.setGameState('settings'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.mutedBadgeBgOf(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.surfaceBorderOf(context),
                            width: 1.5,
                          ),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Icon(
                          LucideIcons.settings,
                          color: AppColors.mutedBadgeTextOf(context),
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'INISIATIF CELIK DIGITAL WARGA EMAS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMutedOf(context),
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Visual balance spacer
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Primary gradient card (first action) — keeps emerald gradient in both themes
  Widget _buildPrimaryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    int delay = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: const Color(0xFF106452),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF106452).withValues(alpha: 0.40),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.chevronRight,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms).slideY(
          begin: 0.08,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }

  /// Secondary solid card (navigation items) — opaque solid fill in both themes
  Widget _buildNavCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
    int delay = 0,
  }) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.emerald.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    // Solid icon background
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.textPrimaryOf(context),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondaryOf(context),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.textMutedOf(context),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms).slideY(
          begin: 0.08,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}
