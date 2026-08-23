import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/scenario.dart';
import '../providers/scenario_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';
import '../utils/medium_type_label.dart';

class ScenarioEditorView extends StatefulWidget {
  final Scenario? scenario;
  const ScenarioEditorView({super.key, this.scenario});

  @override
  State<ScenarioEditorView> createState() => _ScenarioEditorViewState();
}

class _ScenarioEditorViewState extends State<ScenarioEditorView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _senderCtrl;
  late TextEditingController _timestampCtrl;
  late TextEditingController _messageCtrl;
  late TextEditingController _techniqueCtrl;
  late TextEditingController _explanationCtrl;

  String _type = 'whatsapp';
  String _difficulty = 'Sederhana';
  String _threatLevel = 'TINGGI';
  bool _isScam = true;
  bool _isActive = true;

  final List<String> _categories = [
    kCategoryTechSupport,
    kCategoryAuthority,
    kCategoryGiveaway,
    kCategoryPhishing,
    kCategoryFamily,
    'Lain-lain Jenis Modus Operandi',
  ];
  late String _category;

  final List<_ReplyEntry> _replies = [];
  final List<TextEditingController> _actionControllers = [];

  static const _typeColors = {
    'whatsapp': Color(0xFF25D366),
    'sms': AppColors.cyan,
    'email': AppColors.amber,
    'phone': AppColors.rose,
  };

  static const _supportedTypes = ['whatsapp', 'sms', 'email', 'phone'];

  @override
  void initState() {
    super.initState();
    final s = widget.scenario;
    _senderCtrl = TextEditingController(text: s?.sender ?? '');
    _timestampCtrl = TextEditingController(text: s?.timestamp ?? 'Baru-baru ini');
    _messageCtrl = TextEditingController(text: s?.message ?? '');
    _techniqueCtrl = TextEditingController(text: s?.technique ?? '');
    _explanationCtrl = TextEditingController(text: s?.explanation ?? '');

    _category = s?.category ?? _categories[0];
    if (!_categories.contains(_category)) {
      _categories.add(_category);
    }

    if (s != null) {
      _type = _supportedTypes.contains(s.type) ? s.type : 'whatsapp';
      _difficulty = s.difficulty;
      _threatLevel = s.threatLevel;
      _isScam = s.isScam;
      _isActive = s.isActive;
      for (final r in s.replyOptions) {
        _replies.add(_ReplyEntry(
            textCtrl: TextEditingController(text: r.text), safety: r.safety));
      }
      for (final a in s.recommendedActions) {
        _actionControllers.add(TextEditingController(text: a));
      }
    } else {
      _replies.add(_ReplyEntry(
          textCtrl: TextEditingController(), safety: 'safe'));
      _actionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _senderCtrl.dispose();
    _timestampCtrl.dispose();
    _messageCtrl.dispose();
    _techniqueCtrl.dispose();
    _explanationCtrl.dispose();
    for (final r in _replies) {
      r.textCtrl.dispose();
    }
    for (final a in _actionControllers) {
      a.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.scenario != null;

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            DarkPageHeader(
              title: isEdit ? 'Edit Senario' : 'Tambah Senario',
              subtitle: isEdit ? null : null,
              onBack: () => Navigator.pop(context),
              trailing: [
                HeaderActionButton(
                  icon: LucideIcons.save,
                  label: 'SIMPAN',
                  color: AppColors.emeraldBadgeTextOf(context),
                  backgroundColor: AppColors.emeraldBadgeBgOf(context),
                  labelColor: AppColors.emeraldBadgeTextOf(context),
                  onPressed: _submit,
                ),
              ],
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  children: [
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.emeraldBadgeBgOf(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.emerald.withValues(alpha: 0.18)),
                            ),
                            child: Icon(
                              LucideIcons.edit3,
                              color: AppColors.emeraldBadgeTextOf(context),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bina senario dengan langkah yang jelas',
                                  style: TextStyle(
                                    color: AppColors.textPrimaryOf(context),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Pilih medium, isi kandungan, tetapkan klasifikasi, kemudian tambah balasan dan tindakan.',
                                  style: TextStyle(
                                    color: AppColors.textMutedOf(context),
                                    fontSize: 10.5,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _sectionCard(
                      title: 'JENIS MEDIUM',
                      subtitle: 'Pilih saluran yang digunakan oleh senario ini.',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _supportedTypes.map(_buildTypeChip).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionCard(
                      title: 'KATEGORI PENIPUAN',
                      subtitle: 'Pilih kumpulan modus operandi yang paling sesuai.',
                      child: _dropdown(
                        _category,
                        _categories,
                        (v) => setState(() => _category = v!),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionCard(
                      title: 'MAKLUMAT ASAS',
                      subtitle: 'Isi butiran utama sebelum masuk ke kandungan mesej.',
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: 'Penghantar / Nombor / Nama',
                            controller: _senderCtrl,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Ruang ini wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            hintText: 'Cap masa, contohnya semalam atau 10:30 PM',
                            controller: _timestampCtrl,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionCard(
                      title: 'MESEJ / KANDUNGAN',
                      subtitle: 'Masukkan teks penuh yang akan dipaparkan kepada pengguna.',
                      child: CustomTextField(
                        hintText: 'Teks mesej penuh...',
                        controller: _messageCtrl,
                        maxLines: 5,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ruang ini wajib diisi'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionCard(
                      title: 'KLASIFIKASI',
                      subtitle: 'Tetapkan tahap kesukaran dan tahap ancaman.',
                      child: Column(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final stack = constraints.maxWidth < 420;
                              if (stack) {
                                return Column(
                                  children: [
                                    _classificationGroup(
                                      title: 'KESUKARAN',
                                      children: [
                                        _buildClassificationChip(
                                          label: 'Mudah',
                                          value: 'Mudah',
                                          groupValue: _difficulty,
                                          activeColor: AppColors.emerald,
                                          onTap: () => setState(() => _difficulty = 'Mudah'),
                                        ),
                                        _buildClassificationChip(
                                          label: 'Sederhana',
                                          value: 'Sederhana',
                                          groupValue: _difficulty,
                                          activeColor: AppColors.emerald,
                                          onTap: () => setState(() => _difficulty = 'Sederhana'),
                                        ),
                                        _buildClassificationChip(
                                          label: 'Sukar',
                                          value: 'Sukar',
                                          groupValue: _difficulty,
                                          activeColor: AppColors.emerald,
                                          onTap: () => setState(() => _difficulty = 'Sukar'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    _classificationGroup(
                                      title: 'TAHAP ANCAMAN',
                                      children: [
                                        _buildClassificationChip(
                                          label: 'TINGGI',
                                          value: 'TINGGI',
                                          groupValue: _threatLevel,
                                          activeColor: AppColors.rose,
                                          onTap: () => setState(() => _threatLevel = 'TINGGI'),
                                        ),
                                        _buildClassificationChip(
                                          label: 'SEDERHANA',
                                          value: 'SEDERHANA',
                                          groupValue: _threatLevel,
                                          activeColor: AppColors.rose,
                                          onTap: () => setState(() => _threatLevel = 'SEDERHANA'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _classificationGroup(
                                      title: 'KESUKARAN',
                                      children: [
                                        _buildClassificationChip(
                                          label: 'Mudah',
                                          value: 'Mudah',
                                          groupValue: _difficulty,
                                          activeColor: AppColors.emerald,
                                          onTap: () => setState(() => _difficulty = 'Mudah'),
                                        ),
                                        _buildClassificationChip(
                                          label: 'Sederhana',
                                          value: 'Sederhana',
                                          groupValue: _difficulty,
                                          activeColor: AppColors.emerald,
                                          onTap: () => setState(() => _difficulty = 'Sederhana'),
                                        ),
                                        _buildClassificationChip(
                                          label: 'Sukar',
                                          value: 'Sukar',
                                          groupValue: _difficulty,
                                          activeColor: AppColors.emerald,
                                          onTap: () => setState(() => _difficulty = 'Sukar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: _classificationGroup(
                                      title: 'TAHAP ANCAMAN',
                                      children: [
                                        _buildClassificationChip(
                                          label: 'TINGGI',
                                          value: 'TINGGI',
                                          groupValue: _threatLevel,
                                          activeColor: AppColors.rose,
                                          onTap: () => setState(() => _threatLevel = 'TINGGI'),
                                        ),
                                        _buildClassificationChip(
                                          label: 'SEDERHANA',
                                          value: 'SEDERHANA',
                                          groupValue: _threatLevel,
                                          activeColor: AppColors.rose,
                                          onTap: () => setState(() => _threatLevel = 'SEDERHANA'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceOf(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.surfaceBorderOf(context)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: AppColors.amberBadgeBgOf(context),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    LucideIcons.alertTriangle,
                                    color: AppColors.amberBadgeTextOf(context),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ini adalah penipuan',
                                        style: TextStyle(
                                          color: AppColors.textPrimaryOf(context),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Aktifkan untuk kandungan yang perlu ditanda sebagai contoh penipuan.',
                                        style: TextStyle(
                                          color: AppColors.textMutedOf(context),
                                          fontSize: 9.5,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _isScam,
                                  onChanged: (v) => setState(() => _isScam = v),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionCard(
                      title: 'PENJELASAN',
                      child: CustomTextField(
                        hintText: 'Penjelasan pakar tentang kenapa ini penipuan...',
                        controller: _explanationCtrl,
                        maxLines: 3,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ruang ini wajib diisi'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionCard(
                      title: 'TINDAKAN YANG DISYORKAN',
                      trailing: GestureDetector(
                        onTap: () {
                          setState(() {
                            _actionControllers.add(TextEditingController());
                          });
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.plus,
                                color: AppColors.emerald, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Tambah',
                              style: TextStyle(
                                color: AppColors.emerald,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          ..._actionControllers.asMap().entries.map((e) {
                            final i = e.key;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceOf(context),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.surfaceBorderOf(context)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        hintText: 'Tindakan ${i + 1}',
                                        controller: _actionControllers[i],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _actionControllers[i].dispose();
                                        _actionControllers.removeAt(i);
                                      }),
                                      child: const Icon(LucideIcons.trash2,
                                          color: AppColors.rose, size: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionCard(
                      title: 'PILIHAN BALAS',
                      subtitle: 'Sediakan pilihan respons yang selamat dan berbeza tahap risiko.',
                      trailing: GestureDetector(
                        onTap: () {
                          setState(() {
                            _replies.add(
                              _ReplyEntry(
                                textCtrl: TextEditingController(),
                                safety: 'safe',
                              ),
                            );
                          });
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.plus,
                                color: AppColors.indigo, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Tambah',
                              style: TextStyle(
                                color: AppColors.indigo,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          ..._replies.asMap().entries.map((e) {
                            final i = e.key;
                            final entry = e.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceOf(context),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.surfaceBorderOf(context)),
                                ),
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      hintText: 'Teks pilihan balas ${i + 1}',
                                      controller: entry.textCtrl,
                                      validator: (v) => (v == null || v.trim().isEmpty)
                                          ? 'Ruang ini wajib diisi'
                                          : null,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: _classificationGroup(
                                            title: 'KESELAMATAN',
                                            children: [
                                              _buildSafetyChip(
                                                label: 'SELAMAT',
                                                value: 'selamat',
                                                groupValue: entry.safety,
                                                activeColor: AppColors.emerald,
                                                onTap: () => setState(() => entry.safety = 'selamat'),
                                              ),
                                              _buildSafetyChip(
                                                label: 'BERISIKO',
                                                value: 'berisiko',
                                                groupValue: entry.safety,
                                                activeColor: AppColors.amber,
                                                onTap: () => setState(() => entry.safety = 'berisiko'),
                                              ),
                                              _buildSafetyChip(
                                                label: 'BAHAYA',
                                                value: 'bahaya',
                                                groupValue: entry.safety,
                                                activeColor: AppColors.rose,
                                                onTap: () => setState(() => entry.safety = 'bahaya'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 26),
                                          child: GestureDetector(
                                            onTap: () => setState(() {
                                              entry.textCtrl.dispose();
                                              _replies.removeAt(i);
                                            }),
                                            child: const Icon(LucideIcons.trash2,
                                                color: AppColors.rose, size: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    String? subtitle,
    required Widget child,
    Widget? trailing,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimaryOf(context),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textMutedOf(context),
                          fontSize: 10.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    final active = _type == type;
    final color = _typeColors[type] ?? AppColors.textMutedOf(context);
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.12) : AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: active ? color : AppColors.surfaceBorderOf(context),
            width: 1.5,
          ),
        ),
        child: Text(
          mediumTypeLabel(type),
          style: TextStyle(
            color: active ? color : AppColors.textMutedOf(context),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildClassificationChip({
    required String label,
    required String value,
    required String groupValue,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final active = groupValue == value;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? activeColor.withValues(alpha: 0.12) : AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: active ? activeColor : AppColors.surfaceBorderOf(context),
            width: 1.5,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: active ? activeColor : AppColors.textMutedOf(context),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyChip({
    required String label,
    required String value,
    required String groupValue,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final active = groupValue == value;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? activeColor.withValues(alpha: 0.12) : AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: active ? activeColor : AppColors.surfaceBorderOf(context),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? activeColor : AppColors.textMutedOf(context),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _classificationGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textMutedOf(context),
            fontSize: 8.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: children,
        ),
      ],
    );
  }

  Widget _dropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      onChanged: onChanged,
      menuMaxHeight: 320,
      dropdownColor: AppColors.cardFillOf(context),
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.textPrimaryOf(context),
        fontSize: 12,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceOf(context),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.surfaceBorderOf(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      selectedItemBuilder: (context) => items
          .map(
            (item) => Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimaryOf(context),
                  fontSize: 12,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final scenProv = Provider.of<ScenarioProvider>(context, listen: false);
    final isEdit = widget.scenario != null;
    final newScenario = Scenario(
      id: isEdit ? widget.scenario!.id : DateTime.now().millisecondsSinceEpoch,
      isActive: _isActive,
      type: _type,
      category: _category,
      difficulty: _difficulty,
      threatLevel: _threatLevel,
      technique: _techniqueCtrl.text.trim().isEmpty
          ? _category
          : _techniqueCtrl.text.trim(),
      sender: _senderCtrl.text.trim(),
      timestamp: _timestampCtrl.text.trim(),
      message: _messageCtrl.text.trim(),
      isScam: _isScam,
      explanation: _explanationCtrl.text.trim(),
      recommendedActions: _actionControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
      replyOptions: _replies
          .where((r) => r.textCtrl.text.trim().isNotEmpty)
          .map((r) => ReplyOption(text: r.textCtrl.text.trim(), safety: r.safety))
          .toList(),
    );
    scenProv.saveScenario(newScenario, isEdit: isEdit);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceOf(context),
        content: Text(
          isEdit
              ? 'Senario dikemaskini berjaya.'
              : 'Senario baru ditambah berjaya.',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ReplyEntry {
  TextEditingController textCtrl;
  String safety;
  _ReplyEntry({required this.textCtrl, required this.safety});
}
