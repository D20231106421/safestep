import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../app_theme.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';
import 'trends_view.dart';

class ScamDetailView extends StatelessWidget {
  final ScamDetail scamDetail;

  const ScamDetailView({super.key, required this.scamDetail});

  (Color, Color) _getThemeBadgeColors(BuildContext context, Color themeColor) {
    if (themeColor == AppColors.rose) {
      return (AppColors.roseBadgeBgOf(context), AppColors.roseBadgeTextOf(context));
    } else if (themeColor == AppColors.amber) {
      return (AppColors.amberBadgeBgOf(context), AppColors.amberBadgeTextOf(context));
    } else if (themeColor == AppColors.indigo) {
      return (AppColors.indigoBadgeBgOf(context), AppColors.indigoBadgeTextOf(context));
    } else if (themeColor == AppColors.cyan) {
      return (AppColors.cyanBadgeBgOf(context), AppColors.cyanBadgeTextOf(context));
    } else if (themeColor == AppColors.emerald) {
      return (AppColors.emeraldBadgeBgOf(context), AppColors.emeraldBadgeTextOf(context));
    }
    return (AppColors.mutedBadgeBgOf(context), AppColors.mutedBadgeTextOf(context));
  }

  @override
  Widget build(BuildContext context) {
    final (badgeBg, badgeText) = _getThemeBadgeColors(context, scamDetail.themeColor);

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with back button
            DarkPageHeader(
              title: 'Penjelasan Terperinci',
              subtitle: null,
              onBack: () => Navigator.pop(context),
            ).animate().fadeIn(duration: 300.ms),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // Icon and Title Header Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: badgeText.withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                scamDetail.icon,
                                color: badgeText,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                scamDetail.title,
                                style: TextStyle(
                                  color: AppColors.textPrimaryOf(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          scamDetail.definition,
                          style: TextStyle(
                            color: AppColors.textPrimaryOf(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
                  const SizedBox(height: 16),

                  // Structured Details Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cara Scam Berlaku
                        _buildDetailSection(
                          context,
                          title: 'CARA IA BERLAKU',
                          icon: LucideIcons.workflow,
                          color: AppColors.cyan,
                          items: scamDetail.howItWorks,
                          bulletIcon: LucideIcons.chevronRight,
                          bulletColor: AppColors.cyan,
                        ),
                        const SizedBox(height: 20),

                        // Tanda Amaran
                        _buildDetailSection(
                          context,
                          title: 'TANDA AMARAN',
                          icon: LucideIcons.alertTriangle,
                          color: AppColors.amber,
                          items: scamDetail.warningSigns,
                          bulletIcon: LucideIcons.alertCircle,
                          bulletColor: AppColors.amber,
                        ),
                        const SizedBox(height: 20),

                        // Langkah Pencegahan
                        _buildDetailSection(
                          context,
                          title: 'LANGKAH PENCEGAHAN',
                          icon: LucideIcons.shieldCheck,
                          color: AppColors.emerald,
                          items: scamDetail.whatToDo,
                          bulletIcon: LucideIcons.checkCircle,
                          bulletColor: AppColors.emerald,
                        ),
                        const SizedBox(height: 20),

                        // Jika Sudah Terkena
                        _buildDetailSection(
                          context,
                          title: 'JIKA SUDAH TERKENA',
                          icon: LucideIcons.alertOctagon,
                          color: AppColors.rose,
                          items: scamDetail.ifAlreadyScammed,
                          bulletIcon: LucideIcons.xCircle,
                          bulletColor: AppColors.rose,
                        ),
                        const SizedBox(height: 20),

                        // Saluran Bantuan/Laporan
                        _buildDetailSection(
                          context,
                          title: 'SALURAN BANTUAN / LAPORAN',
                          icon: LucideIcons.phoneCall,
                          color: AppColors.indigo,
                          items: scamDetail.reportingContacts,
                          bulletIcon: LucideIcons.helpCircle,
                          bulletColor: AppColors.indigo,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
    IconData bulletIcon = LucideIcons.playCircle,
    Color? bulletColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 8.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      bulletIcon,
                      color: bulletColor ?? AppColors.textMutedOf(context),
                      size: 10,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 12,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
