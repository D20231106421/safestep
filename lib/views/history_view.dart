import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/history_log.dart';
import '../providers/game_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/metric_chip.dart';
import 'report_detail_view.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final histProv = Provider.of<HistoryProvider>(context);
    final game = Provider.of<GameProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            DarkPageHeader(
              title: 'Rekod Latihan',
              subtitle: 'SEJARAH PRESTASI ANDA',
              onBack: () => game.setGameState('menu'),
              trailing: [
                if (histProv.historyLogs.isNotEmpty)
                  HeaderActionButton(
                    icon: LucideIcons.trash2,
                    label: 'Padam',
                    color: AppColors.rose,
                    backgroundColor: AppColors.roseBadgeBg,
                    onPressed: () => _confirmClear(context, histProv),
                  ),
              ],
            ).animate().fadeIn(duration: 300.ms),

            // Content
            Expanded(
              child: histProv.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.emerald,
                        strokeWidth: 3,
                      ),
                    )
                  : histProv.historyLogs.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          itemCount: histProv.historyLogs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final log = histProv.historyLogs[index];
                            return _buildHistoryCard(context, log, histProv, index);
                          },
                        ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'INISIATIF CELIK DIGITAL WARGA EMAS',
                textAlign: TextAlign.center,
                style: TextStyle(
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

  Widget _buildHistoryCard(
    BuildContext context,
    HistoryLog log,
    HistoryProvider histProv,
    int index,
  ) {
    final pct = log.total > 0 ? (log.score / log.total * 100).round() : 0;
    final passed = log.status == 'TAMAT';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReportDetailView(log: log)),
        );
      },
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Circular accuracy ring
            SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: log.total > 0 ? log.score / log.total : 0,
                    strokeWidth: 5,
                    backgroundColor: AppColors.surfaceBorderOf(context),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      passed ? AppColors.emerald : AppColors.rose,
                    ),
                  ),
                  Text(
                    '$pct%',
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      passed
                          ? const MetricChip.emerald(label: 'TAMAT')
                          : const MetricChip.rose(label: 'KECUNDANG'),
                      const SizedBox(width: 8),
                      Icon(
                        LucideIcons.shield,
                        color: log.shields > 0
                            ? AppColors.cyan
                            : AppColors.rose,
                        size: 11,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${log.shields}/3',
                        style: TextStyle(
                          color: AppColors.textSecondaryOf(context),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${log.score}/${log.total} betul  •  ${log.results.length} senario',
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    log.date,
                    style: TextStyle(
                      color: AppColors.textMutedOf(context),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.textMutedOf(context),
                  size: 16,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => histProv.deleteLog(log.id),
                  child: const Icon(
                    LucideIcons.trash2,
                    color: AppColors.rose,
                    size: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          delay: Duration(milliseconds: index * 60),
          duration: 350.ms,
        );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceBorder.withValues(alpha: 0.5)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? AppColors.glassBorder
                    : AppColors.lightSurfaceBorder,
              ),
            ),
            child: Icon(
              LucideIcons.history,
              color: AppColors.textMutedOf(context),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tiada rekod latihan lagi.',
            style: TextStyle(
              color: AppColors.textSecondaryOf(context),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mulakan latihan pertama anda!',
            style: TextStyle(
              color: AppColors.textMutedOf(context),
              fontSize: 11,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).scale(
            begin: const Offset(0.9, 0.9),
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  void _confirmClear(BuildContext context, HistoryProvider histProv) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Padam Semua Rekod?',
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        content: Text(
          'Tindakan ini tidak boleh dibatalkan. Semua data rekod latihan akan dipadam.',
          style: TextStyle(
            color: AppColors.textSecondaryOf(context),
            fontSize: 12,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: AppColors.textMutedOf(context)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rose,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              histProv.clearAllLogs();
              Navigator.pop(context);
            },
            child: const Text(
              'Padam Semua',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
