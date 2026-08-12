import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            DarkPageHeader(
              title: 'Tetapan Aplikasi',
              subtitle: 'TETAPAN & TEMA',
              onBack: () => game.setGameState('menu'),
            ).animate().fadeIn(duration: 300.ms),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                children: [
                  // ── Theme Selector Section ──────────────────────────────
                  _sectionLabel('MOD TEMA TAMPILAN', LucideIcons.palette, AppColors.emerald),
                  const SizedBox(height: 8),

                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildThemeOptionTile(
                          context,
                          title: 'Mod Gelap (Dark Obsidian)',
                          subtitle: 'Warna Obsidian gelap dengan frosted glass indigo glow',
                          icon: LucideIcons.moon,
                          mode: ThemeMode.dark,
                          currentMode: settings.themeMode,
                          onSelect: () => settings.setThemeMode(ThemeMode.dark),
                        ),
                        const Divider(height: 20),
                        _buildThemeOptionTile(
                          context,
                          title: 'Mod Terang (Light Mode)',
                          subtitle: 'Latar belakang terang bersih dengan kad frosted glass & hijau perisai',
                          icon: LucideIcons.sun,
                          mode: ThemeMode.light,
                          currentMode: settings.themeMode,
                          onSelect: () => settings.setThemeMode(ThemeMode.light),
                        ),
                        const Divider(height: 20),
                        _buildThemeOptionTile(
                          context,
                          title: 'Ikut Sistem Peranti',
                          subtitle: 'Secara automatik mengikut tetapan tema peranti anda',
                          icon: LucideIcons.laptop,
                          mode: ThemeMode.system,
                          currentMode: settings.themeMode,
                          onSelect: () => settings.setThemeMode(ThemeMode.system),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

                  const SizedBox(height: 24),

                  // ── Notifications Settings ──────────────────────────────
                  _sectionLabel('NOTIFIKASI & AMARAN', LucideIcons.bell, AppColors.cyan),
                  const SizedBox(height: 8),

                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildToggleTile(
                          context,
                          title: 'Amaran Langsung',
                          subtitle: 'Terima notifikasi amaran scam semasa aplikasi aktif',
                          icon: LucideIcons.zap,
                          value: settings.liveAlertsEnabled,
                          onChanged: (v) => settings.setLiveAlerts(v),
                        ),
                        Divider(
                          color: AppColors.surfaceBorderOf(context),
                          height: 1,
                        ),
                        _buildToggleTile(
                          context,
                          title: 'Simulasi Notifikasi',
                          subtitle: 'Demo paparan amaran tolak ketika latihan simulasi',
                          icon: LucideIcons.bellRing,
                          value: settings.simulateNotifications,
                          onChanged: (v) => settings.setSimulateNotifications(v),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 180.ms, duration: 350.ms),

                  const SizedBox(height: 24),

                  // ── About App Info Card ─────────────────────────────────
                  _sectionLabel('MAKLUMAT APLIKASI', LucideIcons.info, AppColors.indigo),
                  const SizedBox(height: 8),

                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.emerald, AppColors.emeraldDeep],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.shield_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SafeStep AI  •  v0.1.0',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textPrimaryOf(context),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Perisai Digital & Latihan Keselamatan Siber Warga Emas Malaysia',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textSecondaryOf(context),
                                  fontSize: 10,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 240.ms, duration: 350.ms),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'INISIATIF CELIK DIGITAL WARGA EMAS',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMutedOf(context),
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            color: color,
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOptionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onSelect,
  }) {
    final isSelected = currentMode == mode;
    final isDark = AppColors.isDark(context);

    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.emeraldBadgeBg
                    : (isDark
                        ? AppColors.surfaceBorder.withValues(alpha: 0.5)
                        : AppColors.lightSurfaceBorder),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.emerald.withValues(alpha: 0.4)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.emerald
                    : AppColors.textSecondaryOf(context),
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textSecondaryOf(context),
                      fontSize: 9.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            // Custom radio indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.emerald : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emerald,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = AppColors.isDark(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.cyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
            ),
            child: const Icon(LucideIcons.zap, color: AppColors.cyan, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textMutedOf(context),
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.emerald,
            inactiveTrackColor: isDark
                ? AppColors.surfaceBorder
                : AppColors.lightSurfaceBorder,
          ),
        ],
      ),
    );
  }
}
