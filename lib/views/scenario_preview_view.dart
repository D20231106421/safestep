import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../app_theme.dart';
import '../models/scenario.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';
import 'scenario_editor_view.dart';

class ScenarioPreviewView extends StatelessWidget {
  final Scenario scenario;

  const ScenarioPreviewView({
    super.key,
    required this.scenario,
  });

  String _formatMediumName(String type) {
    switch (type.toLowerCase()) {
      case 'whatsapp':
        return 'WhatsApp';
      case 'sms':
        return 'SMS';
      case 'email':
        return 'Emel';
      case 'phone':
        return 'Telefon';
      default:
        if (type.isEmpty) return type;
        return type[0].toUpperCase() + type.substring(1).toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top App Bar
            DarkPageHeader(
              title: 'Butiran Senario',
              onBack: () => Navigator.pop(context),
              trailing: [
                HeaderActionButton(
                  icon: LucideIcons.edit2,
                  label: 'Edit',
                  color: AppColors.textSecondaryOf(context),
                  labelColor: AppColors.textSecondaryOf(context),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScenarioEditorView(scenario: scenario),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  // Phone Device Mockup Container
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? AppColors.surfaceBorderOf(context)
                            : const Color(0xFFCBD5E1),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _buildMediumMockup(context),
                  ),

                  const SizedBox(height: 20),

                  // Scenario Educational Breakdown (Medium.com Editorial Style)
                  _buildScenarioDetails(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Router for different medium templates
  Widget _buildMediumMockup(BuildContext context) {
    switch (scenario.type.toLowerCase()) {
      case 'whatsapp':
        return _buildWhatsAppTemplate(context);
      case 'sms':
        return _buildSmsTemplate(context);
      case 'email':
        return _buildEmailTemplate(context);
      case 'phone':
        return _buildPhoneTemplate(context);
      default:
        return _buildGenericTemplate(context);
    }
  }

  // 1. WhatsApp Template
  Widget _buildWhatsAppTemplate(BuildContext context) {
    return Container(
      color: const Color(0xFFEFEAE2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // WhatsApp Top App Bar
          Container(
            color: const Color(0xFF075E54),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: const Color(0xFF128C7E),
                  child: Text(
                    scenario.sender.isNotEmpty ? scenario.sender[0].toUpperCase() : 'S',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scenario.sender,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Atas Talian',
                        style: TextStyle(
                          color: Color(0xFFA7F3D0),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.video, color: Colors.white, size: 17),
                const SizedBox(width: 14),
                const Icon(LucideIcons.phone, color: Colors.white, size: 16),
                const SizedBox(width: 10),
                const Icon(LucideIcons.moreVertical, color: Colors.white, size: 16),
              ],
            ),
          ),

          // Chat Canvas
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Date stamp pill
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: const Text(
                    'HARI INI',
                    style: TextStyle(
                      color: Color(0xFF54656F),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Message Bubble
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scenario.message,
                        style: const TextStyle(
                          color: Color(0xFF111B21),
                          fontSize: 12,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Spacer(),
                          Text(
                            scenario.timestamp.isNotEmpty ? scenario.timestamp : '10:45 PG',
                            style: const TextStyle(
                              color: Color(0xFF667781),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            LucideIcons.checkCheck,
                            size: 13,
                            color: Color(0xFF53BDEB),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ],
    ),
  );
  }

  // 2. SMS Template
  Widget _buildSmsTemplate(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SMS Header
          Container(
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF334155),
                  child: Icon(LucideIcons.messageSquare, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scenario.sender,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Mesej Teks Ringkas (SMS)',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.phone, color: Colors.white70, size: 16),
              ],
            ),
          ),

          // Message Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    scenario.timestamp.isNotEmpty ? scenario.timestamp : 'Hari ini',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario.message,
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 12,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Dihantar melalui SMS • ${scenario.sender}',
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Email Template
  Widget _buildEmailTemplate(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email App Header
          Container(
            color: const Color(0xFF08519C),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: const Row(
              children: [
                Icon(LucideIcons.mail, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Aplikasi E-mel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Spacer(),
                Text(
                  'Peti Masuk',
                  style: TextStyle(
                    color: Color(0xFFDEEBF7),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Email Content Area
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildEmailMetaRow('Daripada:', scenario.sender),
                      _buildEmailMetaRow('Kepada:', 'pengguna@safestep.my'),
                      _buildEmailMetaRow('Subjek:', scenario.category, isSubject: true),
                      _buildEmailMetaRow('Tarikh:', scenario.timestamp.isNotEmpty ? scenario.timestamp : 'Hari ini, 10:15 PG'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(color: Color(0xFFE2E8F0), height: 1),
                      ),
                      Text(
                        scenario.message,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 12,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailMetaRow(String label, String value, {bool isSubject = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isSubject ? const Color(0xFF0F172A) : const Color(0xFF334155),
                fontSize: 9.5,
                fontWeight: isSubject ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Phone Call Template
  Widget _buildPhoneTemplate(BuildContext context) {
    return Container(
      color: const Color(0xFF020617), // Deep slate black
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          const Text(
            'PANGGILAN SUARA MASUK...',
            style: TextStyle(
              color: Color(0xFFF43F5E),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),

          // Caller avatar
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626).withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: const Icon(
              LucideIcons.phoneCall,
              color: Color(0xFFEF4444),
              size: 26,
            ),
          ),
          const SizedBox(height: 10),

          // Caller Name
          Text(
            scenario.sender,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            scenario.timestamp.isNotEmpty ? scenario.timestamp : 'Panggilan Suara',
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Call Transcript
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.mic, color: Color(0xFFF43F5E), size: 12),
                    SizedBox(width: 5),
                    Text(
                      'TRANSKRIP PERBUALAN:',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  scenario.message,
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 11.5,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Mock Action Buttons (Decline / Accept)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC2626),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.phoneOff, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 4),
                  const Text('Tolak', style: TextStyle(color: Colors.white70, fontSize: 9)),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF16A34A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.phone, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 4),
                  const Text('Jawab', style: TextStyle(color: Colors.white70, fontSize: 9)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. Generic Template fallback
  Widget _buildGenericTemplate(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Text(
        scenario.message,
        style: const TextStyle(color: Colors.black87, fontSize: 12),
      ),
    );
  }

  // Scenario Breakdown / Medium-style Case Study
  Widget _buildScenarioDetails(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Jenis Medium
          Text(
            'JENIS MEDIUM',
            style: TextStyle(
              color: AppColors.textSecondaryOf(context),
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceBorderOf(context).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatMediumName(scenario.type),
              style: TextStyle(
                color: AppColors.textPrimaryOf(context),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Kategori Penipuan
          if (scenario.category.isNotEmpty) ...[
            Text(
              'KATEGORI PENIPUAN',
              style: TextStyle(
                color: AppColors.textSecondaryOf(context),
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceBorderOf(context).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                scenario.category,
                style: TextStyle(
                  color: AppColors.textPrimaryOf(context),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Status Penipuan
          Text(
            'STATUS PENIPUAN',
            style: TextStyle(
              color: AppColors.textSecondaryOf(context),
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceBorderOf(context).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              scenario.isScam ? 'Penipuan (Scam)' : 'Tulen (Bukan Scam)',
              style: TextStyle(
                color: AppColors.textPrimaryOf(context),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Separator between Status Penipuan and Penjelasan
          if (scenario.explanation.isNotEmpty)
            Divider(
              color: AppColors.textSecondaryOf(context).withValues(alpha: 0.2),
              thickness: 1,
              height: 24,
            ),

          // Penjelasan
          if (scenario.explanation.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              'PENJELASAN',
              style: TextStyle(
                color: AppColors.textSecondaryOf(context),
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            ...scenario.explanation.split('\n').where((line) => line.trim().isNotEmpty).map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        LucideIcons.checkCircle2,
                        size: 13,
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        line.trim(),
                        style: TextStyle(
                          color: AppColors.textPrimaryOf(context),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Recommended Actions Checklist
          if (scenario.recommendedActions.isNotEmpty) ...[
            Text(
              'TINDAKAN YANG DISYORKAN',
              style: TextStyle(
                color: AppColors.textSecondaryOf(context),
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            ...scenario.recommendedActions.map(
              (action) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        LucideIcons.checkCircle2,
                        size: 13,
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        action,
                        style: TextStyle(
                          color: AppColors.textPrimaryOf(context),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
