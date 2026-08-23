import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/game_provider.dart';
import '../providers/scenario_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/metric_chip.dart';

class ModuleSelectionView extends StatelessWidget {
  const ModuleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context, listen: false);
    final scenarioProv = Provider.of<ScenarioProvider>(context);

    final modules = [
      {
        'id': 'tech_support',
        'title': 'Tech Support Scams',
        'malay': 'Penipuan Sokongan Teknikal & Bank',
        'desc': 'Mesej kononnya daripada pusat khidmat sokongan sistem, atau sekatan akaun bank.',
        'icon': LucideIcons.smartphone,
        'iconColor': const Color(0xFF60A5FA), // blue-400
      },
      {
        'id': 'authority',
        'title': 'Authority & Government Impersonators',
        'malay': 'Penyamaran Pihak Berkuasa & Agensi Kerajaan',
        'desc': 'Penyamaran sebagai polis (Macau Scam), LHDN, atau badan berkuasa dengan ugutan waran.',
        'icon': LucideIcons.shieldAlert,
        'iconColor': AppColors.rose,
      },
      {
        'id': 'giveaway',
        'title': 'Fake Giveaways & Sweepstakes',
        'malay': 'Cabutan Bertuah & Hadiah Palsu',
        'desc': 'Umpan ganjaran wang tunai, cabutan bertuah Petronas/Shell, atau bantuan rahmah.',
        'icon': LucideIcons.award,
        'iconColor': AppColors.amber,
      },
      {
        'id': 'phishing',
        'title': 'Phishing (Email & SMS Smishing)',
        'malay': 'Phishing & Smishing',
        'desc': 'Pautan keselamatan palsu yang cuba mencuri ID pengguna, kata laluan, dan kod TAC.',
        'icon': LucideIcons.mail,
        'iconColor': AppColors.indigo,
      },
      {
        'id': 'family',
        'title': 'Emergency Family Impersonation',
        'malay': 'Penipuan Penyamar Keluarga',
        'desc': 'Taktik meniru identiti anak atau ahli keluarga terdekat meminta wang pembiayaan segera.',
        'icon': LucideIcons.phone,
        'iconColor': AppColors.emerald,
      },
      {
        'id': 'others',
        'title': 'Others & Miscellaneous Scams',
        'malay': 'Lain-lain Jenis Modus Operandi',
        'desc': 'Penipuan pelbagai seperti e-dagang, pelaburan palsu, tawaran pekerjaan, atau pinjaman tak wujud.',
        'icon': LucideIcons.helpCircle,
        'iconColor': AppColors.cyan,
      },
      {
        'id': 'all',
        'title': 'Semua Kategori (Rawak)',
        'malay': 'Semua Kategori (Ujian Rawak)',
        'desc': 'Gabungan rawak semua jenis taktik manipulasi sosial siber untuk latihan menyeluruh.',
        'icon': LucideIcons.shield,
        'iconColor': AppColors.textSecondaryOf(context),
      }
    ];

    int getCategoryCount(String catId) {
      final active = scenarioProv.masterScenarios.where((s) => s.isActive).toList();
      if (catId == 'all') return active.length;
      return active.where((s) => game.isScenarioInId(s, catId)).length;
    }

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            DarkPageHeader(
              title: 'Pilih Modul Latihan',
              subtitle: null,
              onBack: () => game.setGameState('menu'),
            ).animate().fadeIn(duration: 300.ms),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Sila pilih kategori penipuan di bawah untuk mulakan simulasi keselamatan siber:',
                style: TextStyle(
                  color: AppColors.textSecondaryOf(context),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final item = modules[index];
                  final count = getCategoryCount(item['id'] as String);
                  final iconColor = item['iconColor'] as Color;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      padding: EdgeInsets.zero,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          splashColor: iconColor.withValues(alpha: 0.08),
                          onTap: () {
                            if (count == 0) {
                              _showEmptyDialog(context);
                              return;
                            }
                            game.startNewGameWithCategory(
                              item['id'] as String,
                              scenarioProv.masterScenarios,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    // Solid icon background
                                    color: AppColors.isDark(context)
                                        ? iconColor.withValues(alpha: 0.18)
                                        : iconColor.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(
                                      color: iconColor.withValues(alpha: 0.35),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: iconColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item['malay'] as String,
                                              style: TextStyle(
                                                color: AppColors.textPrimaryOf(context),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          MetricChip(
                                            label: '$count Kes',
                                            backgroundColor: count > 0
                                                ? AppColors.emeraldBadgeBgOf(context)
                                                : AppColors.roseBadgeBgOf(context),
                                            textColor: count > 0
                                                ? AppColors.emeraldBadgeTextOf(context)
                                                : AppColors.roseBadgeTextOf(context),
                                            fontSize: 8.5,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['desc'] as String,
                                        style: TextStyle(
                                          color: AppColors.textSecondaryOf(context),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                        delay: Duration(milliseconds: 150 + index * 50),
                        duration: 300.ms,
                      ).slideY(
                        begin: 0.05,
                        duration: 300.ms,
                        curve: Curves.easeOut,
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmptyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Katalog Kosong',
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        content: Text(
          'Tiada senario latihan aktif dalam kategori ini. Sila tambah senario baharu di Katalog.',
          style: TextStyle(
            color: AppColors.textSecondaryOf(context),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Faham',
              style: TextStyle(
                color: AppColors.emerald,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
