import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../providers/game_provider.dart';
import '../providers/history_provider.dart';
import '../providers/settings_provider.dart';
import '../models/scenario.dart';
import '../widgets/glass_card.dart';
import '../utils/medium_type_label.dart';

class SimulationView extends StatefulWidget {
  const SimulationView({super.key});

  @override
  State<SimulationView> createState() => _SimulationViewState();
}

class _SimulationViewState extends State<SimulationView> {
  bool _isReplying = false;

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    final historyProv = Provider.of<HistoryProvider>(context, listen: false);
    final settingsProv = Provider.of<SettingsProvider>(context);
    final scenario = game.currentScenario;

    if (scenario == null) {
      return Center(
        child: Text(
          'Tiada senario latihan aktif.',
          style: TextStyle(color: AppColors.textSecondaryOf(context)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar
            _buildProgressBar(game),

            // Mock Device UI Content Frame
            Expanded(child: _buildDeviceMockFrame(game, scenario)),

            // Bottom Actions Panel Tray
            _buildActionsTray(
              context,
              game,
              scenario,
              historyProv,
              settingsProv,
            ),
          ],
        ),
      ),
    );
  }

  // Visual progress bar
  Widget _buildProgressBar(GameProvider game) {
    final total = game.currentPool.length;
    final index = game.currentIndex;
    final percent = total > 0 ? (index + 1) / total : 0.0;

    return Container(
      height: 6,
      width: double.infinity,
      color: AppColors.surfaceBorderOf(context),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: percent,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.emerald,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(3),
              bottomRight: Radius.circular(3),
            ),
          ),
        ),
      ),
    );
  }

  // Device Layout Router
  Widget _buildDeviceMockFrame(GameProvider game, Scenario scen) {
    switch (scen.type) {
      case 'whatsapp':
        return _buildWhatsAppMock(game, scen);
      case 'sms':
        return _buildSMSMock(game, scen);
      case 'email':
        return _buildEmailMock(game, scen);
      case 'phone':
        return _buildCallMock(game, scen);
      default:
        return _buildUnsupportedMedium(game, scen);
    }
  }

  Widget _buildUnsupportedMedium(GameProvider game, Scenario scen) {
    return Container(
      color: AppColors.canvasOf(context),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  LucideIcons.chevronLeft,
                  color: AppColors.textSecondaryOf(context),
                  size: 20,
                ),
                onPressed: () => game.setGameState('choose_category'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Medium tidak disokong',
                  style: TextStyle(
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.amberBadgeBgOf(context),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: AppColors.amber.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(
                        LucideIcons.alertCircle,
                        color: AppColors.amberBadgeTextOf(context),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${mediumTypeLabel(scen.type)} tidak menggunakan mockup peranti.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimaryOf(context),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pilih senario WhatsApp, SMS, Emel atau Telefon.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WhatsApp Layout UI
  Widget _buildWhatsAppMock(GameProvider game, Scenario scen) {
    return Container(
      color: const Color(0xFFEFEAE2), // WhatsApp BG
      child: Column(
        children: [
          // WhatsApp Header
          Container(
            color: const Color(0xFF075E54),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        LucideIcons.chevronLeft,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => game.setGameState('choose_category'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF0C4A42),
                      child: Text(
                        scen.sender.isNotEmpty
                            ? scen.sender[0].toUpperCase()
                            : 'S',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scen.sender,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          game.isTyping ? 'sedang menaip...' : 'Atas Talian',
                          style: const TextStyle(
                            color: Color(0xFFA7F3D0),
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildShieldsHeader(game),
              ],
            ),
          ),

          // Chat area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [

                // Sender Message Bubble
                if (game.isTyping)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 6,
                            height: 6,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation(Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildInteractiveMessage(
                            game,
                            scen,
                            isWhiteText: false,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${scen.timestamp} • ✓✓',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ).animate().slideX(begin: -0.1, end: 0, duration: 200.ms),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SMS Layout UI
  Widget _buildSMSMock(GameProvider game, Scenario scen) {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: Column(
        children: [
          // Header Bar
          Container(
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        LucideIcons.chevronLeft,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => game.setGameState('choose_category'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFF334155),
                      child: Icon(
                        LucideIcons.mail,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scen.sender,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'Mesej Ringkas',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildShieldsHeader(game),
              ],
            ),
          ),

          // Message Box
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (game.isTyping)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('...'),
                  )
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInteractiveMessage(
                            game,
                            scen,
                            isWhiteText: false,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            scen.timestamp,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ).animate().slideX(begin: -0.1, end: 0, duration: 200.ms),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // E-Mail Layout UI
  Widget _buildEmailMock(GameProvider game, Scenario scen) {
    return Container(
      color: const Color(0xFFF6FCF9),
      child: Column(
        children: [
          // Mail Header bar
          Container(
            color: const Color(0xFF08519C),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        LucideIcons.chevronLeft,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => game.setGameState('choose_category'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    const Icon(LucideIcons.mail, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aplikasi E-mel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Peti Surat',
                          style: TextStyle(
                            color: Color(0xFFDEEBF7),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildShieldsHeader(game),
              ],
            ),
          ),

          // Mail Details Sheet
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE6F4F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Headers
                      _buildEmailHeaderRow('Daripada:', scen.sender),
                      _buildEmailHeaderRow('Kepada:', 'saya@safestep.my'),
                      _buildEmailHeaderRow(
                        'Subjek:',
                        scen.category,
                        isSubject: true,
                      ),
                      const Divider(color: Color(0xFFF6FCF9), height: 16),

                      if (game.isTyping)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: Text(
                              'Memuatkan e-mel yang masuk...',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6FCF9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFF6FCF9)),
                          ),
                          child: _buildInteractiveMessage(
                            game,
                            scen,
                            isWhiteText: false,
                          ),
                        ),
                      ],
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

  Widget _buildEmailHeaderRow(
    String label,
    String value, {
    bool isSubject = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSubject
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF334155),
                fontSize: 9.5,
                fontWeight: isSubject ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Incoming Call Screen Layout UI
  Widget _buildCallMock(GameProvider game, Scenario scen) {
    return Container(
      color: const Color(0xFF020617), // slate-950
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  LucideIcons.chevronLeft,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => game.setGameState('choose_category'),
              ),
              _buildShieldsHeader(game),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
                'PANGGILAN MASUK...',
                style: TextStyle(
                  color: Color(0xFFF43F5E),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .fadeIn(duration: 800.ms),
          const SizedBox(height: 16),
          // Caller avatar
          Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  LucideIcons.phoneCall,
                  color: Color(0xFFEF4444),
                  size: 28,
                ),
              )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                duration: 1.seconds,
              ),
          const SizedBox(height: 10),
          Text(
            scen.sender,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          // Transcript Display Area
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Kandungan Transkrip Panggilan:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                _buildInteractiveMessage(game, scen, isWhiteText: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Generic Shields and Session count badge
  Widget _buildShieldsHeader(
    GameProvider game, {
    bool isDark = false,
    double sizeMultiplier = 1.0,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Text(
            'KES ${game.currentIndex + 1}/${game.currentPool.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Text(
                'SHIELD: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8 * sizeMultiplier,
                  fontWeight: FontWeight.w900,
                ),
              ),
              ...List.generate(3, (i) {
                final isFull = i < game.shields;
                return Icon(
                  Icons.shield,
                  color: isFull
                      ? const Color(0xFF34D399)
                      : (isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFF0D4F46)),
                  size: 11 * sizeMultiplier,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // Clickable text segments for red flag mapping
  Widget _buildInteractiveMessage(
    GameProvider game,
    Scenario scen, {
    required bool isWhiteText,
  }) {
    if (game.playStep != 'red_flags') {
      return Text(
        scen.message,
        style: TextStyle(
          color: isWhiteText
              ? const Color(0xFFE6F4F0)
              : const Color(0xFF1E293B),
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          height: 1.4,
        ),
      );
    }

    final words = scen.message.split(RegExp(r'(\s+)'));

    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 0,
      runSpacing: 2,
      children: words.map((seg) {
        if (seg.trim().isEmpty) {
          return Text(seg, style: const TextStyle(fontSize: 11.5));
        }

        final clean = seg
            .toLowerCase()
            .replaceAll(
              RegExp(
                r'[.,\/#!$%\^&\*;:{}=\-_`~()?"'
                "'"
                r'\[\]]',
              ),
              '',
            )
            .trim();
        final isClicked = game.foundRedFlags.contains(clean);
        final isFlag = game.isWordRedFlag(seg);

        return GestureDetector(
          onTap: () => game.handleWordClick(seg, isFlag),
          child:
              Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 1.0,
                      vertical: 0.5,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isClicked
                          ? (isFlag
                                ? const Color(0xFFFCD34D)
                                : Colors.transparent) // amber-300
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: isClicked && isFlag
                          ? Border.all(color: const Color(0xFFD97706), width: 1)
                          : null,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: seg,
                            style: TextStyle(
                              color: isClicked
                                  ? (isFlag
                                        ? const Color(0xFF0F172A)
                                        : Colors.grey.withValues(alpha: 0.5))
                                  : (isWhiteText
                                        ? Colors.white
                                        : const Color(0xFF1E293B)),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              decoration: isClicked
                                  ? (isFlag
                                        ? TextDecoration.none
                                        : TextDecoration.lineThrough)
                                  : TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dotted,
                              decorationColor: isWhiteText
                                  ? Colors.grey
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          if (isClicked && isFlag)
                            const TextSpan(
                              text: ' ⚠️',
                              style: TextStyle(fontSize: 9),
                            ),
                        ],
                      ),
                    ),
                  )
                  .animate(target: isClicked && isFlag ? 1 : 0)
                  .shake(duration: 300.ms, rotation: 0.05),
        );
      }).toList(),
    );
  }

  // Interactive control board panel
  Widget _buildActionsTray(
    BuildContext context,
    GameProvider game,
    Scenario scen,
    HistoryProvider historyProv,
    SettingsProvider settingsProv,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border(
          top: BorderSide(color: AppColors.surfaceBorderOf(context), width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // STEP TRACKER BAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Langkah Latihan',
                style: TextStyle(
                  color: AppColors.textMutedOf(context),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              Row(
                children: [
                  _buildStepIndicatorBadge(
                    'Kenal Pasti',
                    active: game.playStep == 'identify',
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '➔',
                    style: TextStyle(
                      color: AppColors.textMutedOf(context),
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _buildStepIndicatorBadge(
                    'Red Flags',
                    active: game.playStep == 'red_flags',
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '➔',
                    style: TextStyle(
                      color: AppColors.textMutedOf(context),
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _buildStepIndicatorBadge(
                    'Respon',
                    active: game.playStep == 'respond',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // DYNAMIC STEP CARD VIEWER
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildActiveStepControl(context, game, scen, historyProv),
          ),

          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildStepIndicatorBadge(String text, {required bool active}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: active
            ? AppColors.emeraldBadgeBgOf(context)
            : AppColors.surfaceBorderOf(context),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active 
              ? AppColors.emeraldBadgeTextOf(context)
              : AppColors.textMutedOf(context),
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  // Renders options based on steps
  Widget _buildActiveStepControl(
    BuildContext context,
    GameProvider game,
    Scenario scen,
    HistoryProvider historyProv,
  ) {
    // STEP 1: IDENTIFY SCAM
    if (game.playStep == 'identify') {
      return Column(
        key: const ValueKey('step_identify'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Adakah anda rasa senario diatas adalah scam?',
              style: TextStyle(
                color: AppColors.textPrimaryOf(context),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 15),

          if (game.identifiedIsScam == null)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.roseBadgeBgOf(context),
                      foregroundColor: AppColors.roseBadgeTextOf(context),
                      side: BorderSide(
                        color: AppColors.roseBadgeTextOf(context).withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(LucideIcons.alertTriangle, size: 18),
                    label: const Text(
                      'Ya, Ini Scam!',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    onPressed: () => game.handleIdentifyClick(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mutedBadgeBgOf(context),
                      foregroundColor: AppColors.mutedBadgeTextOf(context),
                      side: BorderSide(
                        color: AppColors.mutedBadgeTextOf(context).withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(LucideIcons.checkCircle, size: 18),
                    label: const Text(
                      'Tidak, Ini bukan scam',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    onPressed: () => game.handleIdentifyClick(false),
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: game.isIdentifyCorrect == true
                        ? AppColors.emeraldBadgeBgOf(context)
                        : AppColors.roseBadgeBgOf(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: game.isIdentifyCorrect == true
                          ? AppColors.emeraldBadgeTextOf(context).withValues(alpha: 0.35)
                          : AppColors.roseBadgeTextOf(context).withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        game.isIdentifyCorrect == true
                            ? LucideIcons.checkCircle
                            : LucideIcons.xCircle,
                        color: game.isIdentifyCorrect == true
                            ? AppColors.emeraldBadgeTextOf(context)
                            : AppColors.roseBadgeTextOf(context),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.isIdentifyCorrect == true
                                  ? 'JAWAPAN ANDA BETUL!'
                                  : 'JAWAPAN ANDA SALAH!',
                              style: TextStyle(
                                color: game.isIdentifyCorrect == true
                                    ? AppColors.emeraldBadgeTextOf(context)
                                    : AppColors.roseBadgeTextOf(context),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              game.identifyFeedback ?? '',
                              style: TextStyle(
                                color: game.isIdentifyCorrect == true
                                    ? AppColors.emeraldBadgeTextOf(context)
                                    : AppColors.roseBadgeTextOf(context),
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF106452),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(LucideIcons.arrowRight, size: 16),
                  label: const Text(
                    'MULA CARI RED FLAGS',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
                  ),
                  onPressed: () => game.goToStep2(), // updates to red_flags
                ),
              ],
            ),
        ],
      );
    }

    // STEP 2: FIND RED FLAGS
    if (game.playStep == 'red_flags') {
      final realFlagsCount = game.foundRedFlags
          .where((w) => game.isWordRedFlag(w))
          .length;

      return Column(
        key: const ValueKey('step_redflags'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Cari & Sentuh sekurang-kurangnya 1 perkataan mencurigakan dalam senario diatas',
              style: TextStyle(
                color: AppColors.textPrimaryOf(context),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Flags badges list
          if (game.foundRedFlags.isNotEmpty)
            Container(
              height: 34,
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: game.foundRedFlags.length,
                itemBuilder: (context, idx) {
                  final word = game.foundRedFlags[idx];
                  final isFlag = game.isWordRedFlag(word);
                   return Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      // Solid fills for contrast
                      color: isFlag
                          ? AppColors.amberBadgeBgOf(context)
                          : AppColors.mutedBadgeBgOf(context),
                      border: Border.all(
                        color: isFlag
                            ? AppColors.amberBadgeTextOf(context).withValues(alpha: 0.35)
                            : AppColors.mutedBadgeTextOf(context).withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${isFlag ? '🚨' : '⚪'} $word',
                      style: TextStyle(
                        color: isFlag
                            ? AppColors.amberBadgeTextOf(context)
                            : AppColors.mutedBadgeTextOf(context),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        decoration: isFlag
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 15),

          // Educative Hint Panel
          if (game.showPlayHint)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.amberBadgeBgOf(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.amberBadgeTextOf(context).withValues(alpha: 0.35)),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      '💡 Pembayangan:\n${game.getScenarioHint(scen)}',
                      style: TextStyle(
                        color: AppColors.amberBadgeTextOf(context),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -5,
                    right: -5,
                    child: IconButton(
                      icon: const Icon(
                        LucideIcons.x,
                        size: 14,
                        color: Colors.grey,
                      ),
                      onPressed: () => game.setShowPlayHint(false),
                    ),
                  ),
                ],
              ),
            )
          else
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.amberBadgeTextOf(context).withValues(alpha: 0.35)),
                padding: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '💡 Perlukan Pembayangan? (Klik Sini)',
                style: TextStyle(
                  color: AppColors.amberBadgeTextOf(context),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onPressed: () => game.setShowPlayHint(true),
            ),

          const SizedBox(height: 8),

          if (game.redFlagMessage.isNotEmpty) ...[
            Text(
              game.redFlagMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryOf(context),
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
          ],

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimaryOf(context),
                    side: BorderSide(color: AppColors.surfaceBorderOf(context)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'LANGKAU',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 10.5,
                    ),
                  ),
                  onPressed: () =>
                      game.skipToStep3(), // update step state to respond
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: realFlagsCount >= 1
                        ? const Color(0xFF106452)
                        : (AppColors.isDark(context)
                            ? AppColors.surfaceBorder
                            : const Color(0xFFE6F4F0)),
                    foregroundColor: realFlagsCount >= 1
                        ? Colors.white
                        : AppColors.textMutedOf(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: realFlagsCount >= 1
                      ? () => game.skipToStep3()
                      : null,
                  child: const Text(
                    'LANGKAH SETERUSNYA',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 10.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // STEP 3: RESPOND AND SECURE ACTIONS
    if (game.playStep == 'respond') {
      return Column(
        key: const ValueKey('step_respond'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isReplying) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilih Maklum Balas Keselamatan',
                  style: TextStyle(
                    color: AppColors.textMutedOf(context),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _isReplying = false),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Color(0xFFF43F5E),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              constraints: const BoxConstraints(maxHeight: 140),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: scen.replyOptions.length,
                itemBuilder: (context, i) {
                  final opt = scen.replyOptions[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardFillOf(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.surfaceBorderOf(context),
                          width: 1.5,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: game.isAnalyzing
                            ? null
                            : () async {
                                await game.analyzeUserReply(opt.text);
                                setState(() => _isReplying = false);
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '"${opt.text}"',
                                  style: TextStyle(
                                    color: AppColors.textPrimaryOf(context),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                LucideIcons.send,
                                color: AppColors.textMutedOf(context),
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (game.isAnalyzing)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation(Color(0xFF106452)),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'SISTEM AI MENGANALISIS KEBOCORAN SIBER...',
                      style: TextStyle(
                        color: Color(0xFF106452),
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
          ] else ...[
            Center(
              child: Text(
                'Apakah respon anda sekiranya menghadapi senario diatas?',
                style: TextStyle(
                  color: AppColors.textPrimaryOf(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Balas Option
                _buildActionCircle(
                  title: 'Balas',
                  icon: LucideIcons.messageSquare,
                  color: AppColors.emeraldBadgeTextOf(context),
                  bg: AppColors.emeraldBadgeBgOf(context),
                  onTap: () => setState(() => _isReplying = true),
                ),
                // Abai Option
                _buildActionCircle(
                  title: 'Abai',
                  icon: LucideIcons.trash2,
                  color: AppColors.mutedBadgeTextOf(context),
                  bg: AppColors.mutedBadgeBgOf(context),
                  onTap: () => game.analyzeUserReply(
                    'Saya abaikan dan padam mesej ini tanpa klik pautan.',
                  ),
                ),
                // Sekat Option
                _buildActionCircle(
                  title: 'Sekat',
                  icon: LucideIcons.ban,
                  color: AppColors.roseBadgeTextOf(context),
                  bg: AppColors.roseBadgeBgOf(context),
                  onTap: () => game.analyzeUserReply(
                    'Saya terus sekat (block) nombor pengirim ini di telefon saya.',
                  ),
                  isPulse: true,
                ),
              ],
            ),
          ],
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActionCircle({
    required String title,
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
    bool isPulse = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: Center(child: Icon(icon, color: color, size: 24)),
                ),
              ),
            )
            .animate(
              target: isPulse ? 1 : 0,
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.05, 1.05),
              duration: 800.ms,
            ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textSecondaryOf(context),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }


}
