import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/scenario.dart';
import '../providers/game_provider.dart';
import '../providers/scenario_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';
import 'scenario_editor_view.dart';

class CurriculumView extends StatefulWidget {
  const CurriculumView({super.key});

  @override
  State<CurriculumView> createState() => _CurriculumViewState();
}

class _CurriculumViewState extends State<CurriculumView> {
  String _searchQuery = '';

  (Color, Color) _getTypeBadgeColors(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'whatsapp':
        return (AppColors.mutedBadgeBgOf(context), AppColors.mutedBadgeTextOf(context));
      case 'sms':
        return (AppColors.mutedBadgeBgOf(context), AppColors.mutedBadgeTextOf(context));
      case 'email':
        return (AppColors.mutedBadgeBgOf(context), AppColors.mutedBadgeTextOf(context));
      case 'phone':
        return (AppColors.mutedBadgeBgOf(context), AppColors.mutedBadgeTextOf(context));
      default:
        return (AppColors.mutedBadgeBgOf(context), AppColors.mutedBadgeTextOf(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scenProv = Provider.of<ScenarioProvider>(context);
    final game = Provider.of<GameProvider>(context, listen: false);

    final filtered = scenProv.masterScenarios.where((s) {
      final matchSearch = _searchQuery.isEmpty ||
          s.sender.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.message.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchSearch;
    }).toList();

    final activeCount = scenProv.masterScenarios.where((s) => s.isActive).length;

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            DarkPageHeader(
              title: 'Katalog Senario',
              subtitle: null,
              onBack: () => game.setGameState('menu'),
              trailing: [
                HeaderActionButton(
                  icon: LucideIcons.listRestart,
                  onPressed: () => _confirmReset(context, scenProv),
                ),
                const SizedBox(width: 8),
                HeaderActionButton(
                  icon: LucideIcons.plus,
                  label: 'Tambah',
                  color: AppColors.emeraldBadgeTextOf(context),
                  backgroundColor: AppColors.emeraldBadgeBgOf(context),
                  labelColor: AppColors.emeraldBadgeTextOf(context),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScenarioEditorView(),
                    ),
                  ),
                ),
              ],
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                hintText: 'Cari senario...',
                prefixIcon: Icon(
                  LucideIcons.search,
                  color: AppColors.textMutedOf(context),
                  size: 16,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
            const SizedBox(height: 8),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${filtered.length} Senario',
                    style: TextStyle(
                      color: AppColors.textSecondaryOf(context),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 12,
                    color: AppColors.surfaceBorderOf(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$activeCount Aktif',
                    style: const TextStyle(
                      color: AppColors.emerald,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: scenProv.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.emerald,
                        strokeWidth: 3,
                      ),
                    )
                  : filtered.isEmpty
                      ? _buildEmpty(context)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (ctx, i) =>
                              _buildTile(ctx, filtered[i], scenProv, i),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    Scenario s,
    ScenarioProvider scenProv,
    int index,
  ) {
    final (typeBg, typeText) = _getTypeBadgeColors(context, s.type);
    final isDark = AppColors.isDark(context);

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(14, 8, 8, 4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: typeBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_typeIcon(s.type), color: typeText, size: 18),
            ),
            title: Text(
              s.sender,
              style: TextStyle(
                color: s.isActive
                    ? AppColors.textPrimaryOf(context)
                    : AppColors.textMutedOf(context),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              s.category,
              style: TextStyle(
                color: AppColors.textMutedOf(context),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Switch(
              value: s.isActive,
              onChanged: (_) => scenProv.toggleScenarioActive(s.id),
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.emerald,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScenarioEditorView(scenario: s),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceBorder.withValues(alpha: 0.6)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.surfaceBorderOf(context),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.edit2,
                            color: AppColors.textSecondaryOf(context), size: 11),
                        const SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: AppColors.textSecondaryOf(context),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _confirmDelete(context, s, scenProv),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.roseBadgeBgOf(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(LucideIcons.trash2,
                        color: AppColors.roseBadgeTextOf(context), size: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
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
              LucideIcons.bookOpen,
              color: AppColors.mutedBadgeTextOf(context),
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tiada senario ditemui.',
            style: TextStyle(
              color: AppColors.textSecondaryOf(context),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (_searchQuery.isNotEmpty)
            Text(
              'Cuba carian lain atau tukar penapis.',
              style: TextStyle(
                color: AppColors.textMutedOf(context),
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'whatsapp': return LucideIcons.messageCircle;
      case 'sms':      return LucideIcons.messageSquare;
      case 'email':    return LucideIcons.mail;
      case 'phone':    return LucideIcons.phone;
      default:         return LucideIcons.file;
    }
  }

  void _confirmDelete(BuildContext context, Scenario s, ScenarioProvider scenProv) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Padam Senario?',
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        content: Text(
          '"${s.sender}" akan dipadam secara kekal.',
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
              scenProv.deleteScenario(s.id);
              Navigator.pop(context);
            },
            child: const Text('Padam',
                style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, ScenarioProvider scenProv) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Reset ke Senario Asal?',
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        content: Text(
          'Semua senario tersuai akan dipadam dan senarai dikembalikan kepada 24 senario lalai.',
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
              backgroundColor: AppColors.emeraldBadgeBgOf(context),
              foregroundColor: AppColors.emeraldBadgeTextOf(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              scenProv.resetToDefault();
              Navigator.pop(context);
            },
            child: const Text('Reset',
                style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}
