import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/history_log.dart';
import '../providers/game_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';
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
              subtitle: null,
              onBack: () => game.setGameState('menu'),
              trailing: [
                if (histProv.historyLogs.isNotEmpty)
                  HeaderActionButton(
                    icon: LucideIcons.trash2,
                    label: 'Padam',
                    color: AppColors.roseBadgeTextOf(context),
                    backgroundColor: AppColors.roseBadgeBgOf(context),
                    onPressed: () => _confirmClear(context, histProv),
                  ),
              ],
            ),

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
            SizedBox.square(
              dimension: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: log.total > 0 ? log.score / log.total : 0,
                      strokeWidth: 4.5,
                      backgroundColor: AppColors.surfaceBorderOf(context),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        passed ? AppColors.emerald : AppColors.rose,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$pct%',
                        style: TextStyle(
                          color: AppColors.textPrimaryOf(context),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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
                  Transform.translate(
                    offset: const Offset(-2, 0),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.shield,
                          color: log.shields > 0
                              ? AppColors.emerald
                              : AppColors.rose,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${log.shields}/3 perisai  |  ${log.date}',
                            style: TextStyle(
                              color: AppColors.textMutedOf(context),
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
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
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.textMutedOf(context),
                  size: 18,
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => _confirmDeleteLog(context, histProv, log.id),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.roseBadgeBgOf(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      LucideIcons.trash2,
                      color: AppColors.roseBadgeTextOf(context),
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.mutedBadgeBgOf(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              LucideIcons.history,
              color: AppColors.mutedBadgeTextOf(context),
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
              backgroundColor: AppColors.roseBadgeBgOf(context),
              foregroundColor: AppColors.roseBadgeTextOf(context),
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

  void _confirmDeleteLog(BuildContext context, HistoryProvider histProv, int logId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Padam Rekod?',
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        content: Text(
          'Adakah anda pasti mahu memadam rekod latihan ini?',
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
              backgroundColor: AppColors.roseBadgeBgOf(context),
              foregroundColor: AppColors.roseBadgeTextOf(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              histProv.deleteLog(logId);
              Navigator.pop(context);
            },
            child: const Text(
              'Padam',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
