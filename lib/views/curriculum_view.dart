import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/scenario.dart';
import '../providers/game_provider.dart';
import '../providers/scenario_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/metric_chip.dart';
import 'scenario_editor_view.dart';

class CurriculumView extends StatefulWidget {
  const CurriculumView({super.key});

  @override
  State<CurriculumView> createState() => _CurriculumViewState();
}

class _CurriculumViewState extends State<CurriculumView> {
  String _searchQuery = '';
  String _filterType = 'all';
  String _filterCategory = 'all';

  static const _typeColors = {
    'whatsapp': Color(0xFF25D366),
    'sms': AppColors.cyan,
    'email': AppColors.amber,
    'phone': AppColors.rose,
    'web': AppColors.indigo,
  };

  @override
  Widget build(BuildContext context) {
    final scenProv = Provider.of<ScenarioProvider>(context);
    final game = Provider.of<GameProvider>(context, listen: false);

    final filtered = scenProv.masterScenarios.where((s) {
      final matchType = _filterType == 'all' || s.type == _filterType;
      final matchCategory = _filterCategory == 'all' ||
          normalizeCategoryLabel(s.category) == _filterCategory;
      final matchSearch = _searchQuery.isEmpty ||
          s.sender.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.message.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchType && matchCategory && matchSearch;
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
                  icon: LucideIcons.rotateCcw,
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
            ).animate().fadeIn(duration: 300.ms),

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
            ).animate().fadeIn(delay: 80.ms, duration: 300.ms),
            const SizedBox(height: 8),

            // Type filter chips
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildChip('all', 'Semua'),
                  _buildChip('whatsapp', 'WhatsApp'),
                  _buildChip('sms', 'SMS'),
                  _buildChip('email', 'Emel'),
                  _buildChip('phone', 'Telefon'),
                ],
              ),
            ).animate().fadeIn(delay: 120.ms, duration: 300.ms),
            const SizedBox(height: 6),

            // Category filter chips
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip('all', 'Semua Penipuan'),
                  _buildCategoryChip(kCategoryTechSupport, 'Sokongan Teknikal & Bank'),
                  _buildCategoryChip(kCategoryAuthority, 'Penyamaran Pihak Berkuasa'),
                  _buildCategoryChip(kCategoryGiveaway, 'Cabutan Bertuah & Hadiah Palsu'),
                  _buildCategoryChip(kCategoryPhishing, 'Phishing & Smishing'),
                  _buildCategoryChip(kCategoryFamily, 'Penipuan Penyamar Keluarga'),
                  _buildCategoryChip(kCategoryOthers, 'Lain-lain'),
                ],
              ),
            ).animate().fadeIn(delay: 140.ms, duration: 300.ms),
            const SizedBox(height: 6),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${filtered.length} senario',
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
                    '$activeCount aktif',
                    style: const TextStyle(
                      color: AppColors.emerald,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 300.ms),

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

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'INISIATIF CELIK DIGITAL WARGA EMAS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMutedOf(context),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String type, String label) {
    final active = _filterType == type;
    final isDark = AppColors.isDark(context);

    return GestureDetector(
      onTap: () => setState(() => _filterType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? AppColors.emeraldBadgeBgOf(context)
              : (isDark
                  ? AppColors.surfaceBorder.withValues(alpha: 0.5)
                  : Colors.white),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: active
                ? AppColors.emerald.withValues(alpha: 0.4)
                : AppColors.surfaceBorderOf(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active
                  ? AppColors.emeraldBadgeTextOf(context)
                  : AppColors.textMutedOf(context),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category, String label) {
    final active = _filterCategory == category;
    final isDark = AppColors.isDark(context);

    return GestureDetector(
      onTap: () => setState(() => _filterCategory = category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? AppColors.amberBadgeBgOf(context)
              : (isDark
                  ? AppColors.surfaceBorder.withValues(alpha: 0.5)
                  : Colors.white),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: active
                ? AppColors.amber.withValues(alpha: 0.5)
                : AppColors.surfaceBorderOf(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active
                  ? AppColors.amberBadgeTextOf(context)
                  : AppColors.textMutedOf(context),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
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
    final color = _typeColors[s.type] ?? AppColors.textMutedOf(context);
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
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Icon(_typeIcon(s.type), color: color, size: 18),
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.category,
                  style: TextStyle(
                    color: AppColors.textMutedOf(context),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  s.message,
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 9.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
                _miniTag(s.type.toUpperCase(), color),
                const SizedBox(width: 5),
                _miniTag(s.difficulty, AppColors.indigo),
                const SizedBox(width: 5),
                _miniTag(s.threatLevel, AppColors.rose),
                const Spacer(),
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
    ).animate().fadeIn(
          delay: Duration(milliseconds: 160 + index * 40),
          duration: 300.ms,
        );
  }

  Widget _miniTag(String text, Color color) {
    return MetricChip(
      label: text,
      backgroundColor: color.withValues(alpha: 0.12),
      textColor: color,
      fontSize: 7.5,
    );
  }

  Widget _buildEmpty(BuildContext context) {
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
                color: AppColors.surfaceBorderOf(context),
              ),
            ),
            child: Icon(
              LucideIcons.bookOpen,
              color: AppColors.textMutedOf(context),
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
      ).animate().fadeIn(duration: 350.ms),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'whatsapp': return LucideIcons.messageCircle;
      case 'sms':      return LucideIcons.messageSquare;
      case 'email':    return LucideIcons.mail;
      case 'phone':    return LucideIcons.phone;
      case 'web':      return LucideIcons.globe;
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
              backgroundColor: AppColors.rose,
              foregroundColor: Colors.white,
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
              backgroundColor: AppColors.emerald,
              foregroundColor: Colors.white,
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
