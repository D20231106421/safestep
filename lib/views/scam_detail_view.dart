import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_card.dart';
import 'trends_view.dart';

class ScamDetailView extends StatefulWidget {
  final ScamDetail scamDetail;

  const ScamDetailView({super.key, required this.scamDetail});

  @override
  State<ScamDetailView> createState() => _ScamDetailViewState();
}

class _ScamDetailViewState extends State<ScamDetailView> {
  int _selectedTabIndex = 0;
  final ScrollController _tabScrollController = ScrollController();

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

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        final fallbackLaunched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
        if (!fallbackLaunched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka pautan YouTube.')),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka pautan YouTube.')),
        );
      }
    }
  }

  void _showImageZoomDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    padding: const EdgeInsets.all(24),
                    color: AppColors.canvasOf(context),
                    child: Text(
                      'Imej tidak dapat dimuatkan.',
                      style: TextStyle(color: AppColors.textPrimaryOf(context)),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.x, color: Colors.white, size: 24),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  List<_TabConfig> _buildTabs(BuildContext context) {
    final scam = widget.scamDetail;
    final tabs = <_TabConfig>[];

    // 1. YouTube Video Tab (if video is available)
    if (scam.youtubeVideoId != null && scam.youtubeVideoId!.isNotEmpty) {
      tabs.add(
        _TabConfig(
          label: 'Video',
          icon: LucideIcons.playCircle,
          color: AppColors.emerald,
          builder: (ctx) => _buildVideoContent(ctx),
        ),
      );
    }

    // 2. Example Situation Image Tab (if example situation or image is available)
    if ((scam.exampleMessage != null && scam.exampleMessage!.isNotEmpty) ||
        (scam.exampleImagePath != null && scam.exampleImagePath!.isNotEmpty)) {
      tabs.add(
        _TabConfig(
          label: 'Contoh Situasi',
          icon: LucideIcons.image,
          color: AppColors.emerald,
          builder: (ctx) => _buildExampleImageContent(ctx),
        ),
      );
    }

    // 3. Cara Ia Berlaku (Original)
    tabs.add(
      _TabConfig(
        label: 'Cara Berlaku',
        icon: LucideIcons.workflow,
        color: AppColors.emerald,
        builder: (ctx) => _buildDetailSection(
          ctx,
          title: 'CARA IA BERLAKU',
          icon: LucideIcons.workflow,
          color: AppColors.emerald,
          items: scam.howItWorks,
          bulletIcon: LucideIcons.chevronRight,
          bulletColor: AppColors.emerald,
        ),
      ),
    );

    // 4. Tanda Amaran (Original)
    tabs.add(
      _TabConfig(
        label: 'Tanda Amaran',
        icon: LucideIcons.alertTriangle,
        color: AppColors.emerald,
        builder: (ctx) => _buildDetailSection(
          ctx,
          title: 'TANDA AMARAN',
          icon: LucideIcons.alertTriangle,
          color: AppColors.emerald,
          items: scam.warningSigns,
          bulletIcon: LucideIcons.alertCircle,
          bulletColor: AppColors.emerald,
        ),
      ),
    );

    // 5. Langkah Pencegahan (Original)
    tabs.add(
      _TabConfig(
        label: 'Pencegahan',
        icon: LucideIcons.shieldCheck,
        color: AppColors.emerald,
        builder: (ctx) => _buildDetailSection(
          ctx,
          title: 'LANGKAH PENCEGAHAN',
          icon: LucideIcons.shieldCheck,
          color: AppColors.emerald,
          items: scam.whatToDo,
          bulletIcon: LucideIcons.checkCircle,
          bulletColor: AppColors.emerald,
        ),
      ),
    );

    // 6. Jika Sudah Terkena (Original)
    tabs.add(
      _TabConfig(
        label: 'Jika Terkena',
        icon: LucideIcons.alertOctagon,
        color: AppColors.emerald,
        builder: (ctx) => _buildDetailSection(
          ctx,
          title: 'JIKA SUDAH TERKENA',
          icon: LucideIcons.alertOctagon,
          color: AppColors.emerald,
          items: scam.ifAlreadyScammed,
          bulletIcon: LucideIcons.xCircle,
          bulletColor: AppColors.emerald,
        ),
      ),
    );

    // 7. Saluran Bantuan / Laporan (Original)
    tabs.add(
      _TabConfig(
        label: 'Saluran Bantuan',
        icon: LucideIcons.phoneCall,
        color: AppColors.emerald,
        builder: (ctx) => _buildDetailSection(
          ctx,
          title: 'SALURAN BANTUAN / LAPORAN',
          icon: LucideIcons.phoneCall,
          color: AppColors.emerald,
          items: scam.reportingContacts,
          bulletIcon: LucideIcons.helpCircle,
          bulletColor: AppColors.emerald,
        ),
      ),
    );

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    final (badgeBg, badgeText) = _getThemeBadgeColors(context, widget.scamDetail.themeColor);
    final tabs = _buildTabs(context);

    // Ensure selected tab is within bounds
    final currentIndex = _selectedTabIndex.clamp(0, tabs.length - 1);
    final activeTab = tabs[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Original Header with back button
            DarkPageHeader(
              title: 'Penjelasan Terperinci',
              subtitle: null,
              onBack: () => Navigator.pop(context),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // Icon and Title Header Card (Original)
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
                              ),
                              child: Icon(
                                widget.scamDetail.icon,
                                color: badgeText,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                widget.scamDetail.title,
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
                          widget.scamDetail.definition,
                          style: TextStyle(
                            color: AppColors.textPrimaryOf(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Horizontal Scrollable Tab Bar (Option B)
                  SingleChildScrollView(
                    controller: _tabScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final tab = tabs[index];
                        final isSelected = index == currentIndex;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedTabIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.emerald.withValues(alpha: 0.2)
                                    : AppColors.cardFillOf(context).withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.emerald
                                      : AppColors.surfaceBorderOf(context),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    tab.icon,
                                    size: 14,
                                    color: isSelected
                                        ? AppColors.emerald
                                        : AppColors.textMutedOf(context),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    tab.label,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.emerald
                                          : AppColors.textMutedOf(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Active Tab Content Display Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        activeTab.builder(context),

                        // Next Tab Button
                        if (currentIndex < tabs.length - 1) ...[
                          const SizedBox(height: 18),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedTabIndex = currentIndex + 1;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: AppColors.emerald.withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                              icon: Text(
                                'Seterusnya: ${tabs[currentIndex + 1].label}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emerald,
                                ),
                              ),
                              label: const Icon(
                                LucideIcons.arrowRight,
                                size: 14,
                                color: AppColors.emerald,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // YouTube Video Card Content
  Widget _buildVideoContent(BuildContext context) {
    final videoId = widget.scamDetail.youtubeVideoId!;
    final videoTitle = widget.scamDetail.youtubeVideoTitle ?? 'Video Penerangan Scammer';
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    final videoUrl = 'https://www.youtube.com/watch?v=$videoId';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(LucideIcons.video, color: AppColors.emerald, size: 14),
            SizedBox(width: 6),
            Text(
              'VIDEO PENERANGAN RINGKAS',
              style: TextStyle(
                color: AppColors.emerald,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _launchExternalUrl(videoUrl),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
              color: AppColors.cardFillOf(context),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.cardFillOf(context),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.playCircle,
                                  size: 40,
                                  color: AppColors.rose,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tekan untuk tonton di YouTube',
                                  style: TextStyle(
                                    color: AppColors.textMutedOf(context),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.play,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              videoTitle,
                              style: TextStyle(
                                color: AppColors.textPrimaryOf(context),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sentuh untuk tonton di YouTube',
                              style: TextStyle(
                                color: AppColors.textMutedOf(context),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        LucideIcons.externalLink,
                        size: 16,
                        color: AppColors.rose,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Example Situation Image Content
  Widget _buildExampleImageContent(BuildContext context) {
    final scam = widget.scamDetail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(LucideIcons.image, color: AppColors.emerald, size: 14),
            SizedBox(width: 6),
            Text(
              'CONTOH GAMBAR SITUASI SEBENAR',
              style: TextStyle(
                color: AppColors.emerald,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // If local image asset is provided
        if (scam.exampleImagePath != null && scam.exampleImagePath!.isNotEmpty) ...[
          GestureDetector(
            onTap: () => _showImageZoomDialog(context, scam.exampleImagePath!),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image.asset(
                    scam.exampleImagePath!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.zoomIn, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Tekan untuk zoom',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Simulated Fake Message / Screenshot Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardFillOf(context).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.rose.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.messageSquare, size: 14, color: AppColors.rose),
                      const SizedBox(width: 6),
                      Text(
                        scam.exampleSender ?? 'Mesej Dari Nombor Tidak Dikenali',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.roseBadgeBgOf(context),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'CONTOH PALSU',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.roseBadgeTextOf(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.canvasOf(context),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.surfaceBorderOf(context)),
                ),
                child: Text(
                  scam.exampleMessage ?? 'Tiada contoh mesej disediakan.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: AppColors.textPrimaryOf(context),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              if (scam.exampleWarningNotes != null && scam.exampleWarningNotes!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(LucideIcons.alertCircle, size: 13, color: AppColors.amber),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        scam.exampleWarningNotes!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.amber,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Original Detail Section Generator (preserves all original texts and structures)
  Widget _buildDetailSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    Color color = AppColors.emerald,
    required List<String> items,
    IconData bulletIcon = LucideIcons.playCircle,
    Color? bulletColor,
  }) {
    const activeColor = AppColors.emerald;
    final activeBulletColor = bulletColor ?? AppColors.emerald;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: activeColor, size: 14),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: activeColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(
                      bulletIcon,
                      color: activeBulletColor,
                      size: 11,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: AppColors.textPrimaryOf(context),
                        fontSize: 12,
                        height: 1.45,
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

class _TabConfig {
  final String label;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;

  const _TabConfig({
    required this.label,
    required this.icon,
    required this.color,
    required this.builder,
  });
}
