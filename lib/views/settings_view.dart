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
                        // ── Simulate Notification Button ──────────────────
                        _buildSimulateButtonTile(context, settings),
                        Divider(
                          color: AppColors.surfaceBorderOf(context),
                          height: 1,
                        ),
                        // ── Frequency Selector ────────────────────────────
                        _buildFrequencySelector(context, settings),
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

  /// Clickable button tile to instantly trigger a simulated push notification.
  Widget _buildSimulateButtonTile(
      BuildContext context, SettingsProvider settings) {
    final isDark = AppColors.isDark(context);
    final isEnabled = settings.liveAlertsEnabled;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled
            ? () {
                // triggerRandomAlert is async; fire-and-forget is intentional here.
                settings.triggerRandomAlert();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: isDark
                        ? AppColors.surfaceBorder
                        : AppColors.lightSurface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    duration: const Duration(seconds: 2),
                    content: Row(
                      children: [
                        const Icon(Icons.notifications_active_rounded,
                            color: AppColors.cyan, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Notifikasi simulasi dihantar!',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textPrimaryOf(context),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppColors.cyan.withValues(alpha: 0.12)
                      : AppColors.textMuted.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isEnabled
                        ? AppColors.cyan.withValues(alpha: 0.2)
                        : AppColors.textMuted.withValues(alpha: 0.12),
                  ),
                ),
                child: Icon(
                  LucideIcons.bellRing,
                  color: isEnabled
                      ? AppColors.cyan
                      : AppColors.textMutedOf(context),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simulasi Notifikasi',
                      style: GoogleFonts.plusJakartaSans(
                        color: isEnabled
                            ? AppColors.textPrimaryOf(context)
                            : AppColors.textMutedOf(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      isEnabled
                          ? 'Ketik untuk tunjukkan demo amaran tolak sekarang'
                          : 'Aktifkan Amaran Langsung untuk gunakan ciri ini',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMutedOf(context),
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Pill button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isEnabled
                      ? const LinearGradient(
                          colors: [AppColors.cyan, AppColors.emerald],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: isEnabled
                      ? null
                      : AppColors.textMuted.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.play,
                      size: 10,
                      color: isEnabled ? Colors.white : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'CUBA',
                      style: GoogleFonts.plusJakartaSans(
                        color: isEnabled ? Colors.white : AppColors.textMuted,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Frequency option selector for automatic periodic notifications.
  Widget _buildFrequencySelector(
      BuildContext context, SettingsProvider settings) {
    final isDark = AppColors.isDark(context);
    final isEnabled = settings.liveAlertsEnabled;

    final freqLabels = {
      'Tinggi': '15s',
      'Sederhana': '45s',
      'Rendah': '90s',
      'Mati': '—',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.indigo.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.indigo.withValues(alpha: 0.2)),
                ),
                child: const Icon(LucideIcons.timer,
                    color: AppColors.indigo, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kekerapan Notifikasi Auto',
                      style: GoogleFonts.plusJakartaSans(
                        color: isEnabled
                            ? AppColors.textPrimaryOf(context)
                            : AppColors.textMutedOf(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Tetapkan selang masa notifikasi simulasi muncul',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMutedOf(context),
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Frequency segment chips
          Row(
            children: SettingsProvider.frequencyOptions.map((option) {
              final isSelected = settings.alertFrequency == option;
              final isMati = option == 'Mati';

              Color chipColor = isMati
                  ? AppColors.rose
                  : isSelected
                      ? AppColors.indigo
                      : Colors.transparent;

              return Expanded(
                child: GestureDetector(
                  onTap: isEnabled
                      ? () => settings.setAlertFrequency(option)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                        right: option ==
                                SettingsProvider.frequencyOptions.last
                            ? 0
                            : 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? chipColor.withValues(alpha: 0.18)
                          : (isDark
                              ? AppColors.surfaceBorder.withValues(alpha: 0.5)
                              : AppColors.lightSurfaceBorder),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? chipColor.withValues(alpha: 0.5)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          option,
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected
                                ? (isEnabled ? chipColor : AppColors.textMuted)
                                : AppColors.textMutedOf(context),
                            fontSize: 9.5,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          freqLabels[option] ?? '',
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected && isEnabled
                                ? chipColor
                                : AppColors.textMutedOf(context),
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          // Status indicator
          if (settings.liveAlertsEnabled &&
              settings.alertFrequency != 'Mati') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.emerald,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .fadeOut(duration: 800.ms)
                    .then()
                    .fadeIn(duration: 800.ms),
                const SizedBox(width: 6),
                Text(
                  'Notifikasi auto setiap ${settings.notificationIntervalSeconds}s',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.emerald,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
