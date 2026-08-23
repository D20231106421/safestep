import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';

import '../providers/game_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/gradient_button.dart';
import '../widgets/metric_chip.dart';

class TrendsView extends StatelessWidget {
  const TrendsView({super.key});

  @override
  Widget build(BuildContext context) {

    final game = Provider.of<GameProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.canvasOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            DarkPageHeader(
              title: 'Panduan Penipuan',
              subtitle: null,
              onBack: () => game.setGameState('menu'),
            ).animate().fadeIn(duration: 300.ms),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                children: [
                  // Critical Threat Banner — solid fill, no BackdropFilter
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.amberBadgeBgOf(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.isDark(context)
                            ? AppColors.amber.withValues(alpha: 0.5)
                            : AppColors.amberBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppColors.amber.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            LucideIcons.alertOctagon,
                            color: AppColors.amber,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TAHAP ANCAMAN: KRITIKAL',
                                style: TextStyle(
                                  color: AppColors.textPrimaryOf(context),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'PDRM melaporkan 4,203 aduan penipuan tele-komunikasi dalam tempoh 30 hari terakhir.',
                                style: TextStyle(
                                  color: AppColors.textSecondaryOf(context),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
                  const SizedBox(height: 20),

                  // Active Warnings
                  _sectionLabel(
                    'AMARAN PENIPUAN AKTIF',
                    LucideIcons.alertTriangle,
                    AppColors.rose,
                  ),

                  const SizedBox(height: 8),
                  _buildWarningCard(
                    context,
                    icon: LucideIcons.smartphone,
                    iconColor: AppColors.rose,
                    title: 'Macau Scam — Menyamar PDRM',
                    subtitle:
                        'Laporan meningkat 340% dalam Q3 2024. Penipu mendakwa anda disyaki terlibat dalam jenayah. PDRM tidak pernah meminta wang telefon.',
                    chip: const MetricChip.rose(label: '🔴 KRITIKAL'),
                    delay: 150,
                  ),
                  const SizedBox(height: 10),
                  _buildWarningCard(
                    context,
                    icon: LucideIcons.mail,
                    iconColor: AppColors.amber,
                    title: 'Phishing — Parcel SHOPEE / LAZADA',
                    subtitle:
                        'Penipu menghantar SMS/emel palsu mendakwa bungkusan tertahan. Jangan klik pautan .shop atau .click!',
                    chip: const MetricChip.amber(label: '🟡 TINGGI'),
                    delay: 200,
                  ),
                  const SizedBox(height: 10),
                  _buildWarningCard(
                    context,
                    icon: LucideIcons.dollarSign,
                    iconColor: AppColors.indigo,
                    title: 'Pelaburan Kripto / MLM Palsu',
                    subtitle:
                        'Platform pelaburan tidak berdaftar tular di Telegram & WhatsApp. Hanya 0% pernah mendapat balik wang.',
                    chip: const MetricChip.indigo(label: '🔵 SEDERHANA'),
                    delay: 250,
                  ),
                  const SizedBox(height: 20),

                  // Campaigns
                  _sectionLabel(
                    'KEMPEN KESEDARAN TERKINI',
                    LucideIcons.megaphone,
                    AppColors.emerald,
                  ),
                  const SizedBox(height: 8),
                  _buildCampaignCard(
                    context,
                    emoji: '⛽',
                    brand: 'PETRONAS',
                    title: 'Jangan Percaya Hadiah PETRONAS Palsu',
                    body: 'Petronas TIDAK menganjurkan cabutan bertuah melalui WhatsApp atau SMS. Hubungi 1300-88-8118.',
                    accentColor: AppColors.emerald,
                    delay: 300,
                  ),
                  const SizedBox(height: 10),
                  _buildCampaignCard(
                    context,
                    emoji: '📺',
                    brand: 'ASTRO',
                    title: 'Amaran Rasmi: Pembaruan Kad Astro Palsu',
                    body: 'Astro tidak menghubungi anda melalui WhatsApp untuk mengemaskini set-top-box. Hubungi 1300-82-3838.',
                    accentColor: AppColors.cyan,
                    delay: 340,
                  ),
                  const SizedBox(height: 10),
                  _buildCampaignCard(
                    context,
                    emoji: '🏦',
                    brand: 'BANK NEGARA',
                    title: 'BNM: Laporkan Akaun Mule Melalui BNMLINK',
                    body: 'Menyediakan akaun bank kepada penipu adalah JENAYAH. Hubungi BNM di 1-300-88-5465.',
                    accentColor: AppColors.indigo,
                    delay: 380,
                  ),
                  const SizedBox(height: 20),



                  // Helpline
                  _sectionLabel(
                    'TALIAN KECEMASAN',
                    LucideIcons.phone,
                    AppColors.rose,
                  ),
                  const SizedBox(height: 8),
                  GlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.shieldAlert,
                              color: AppColors.emeraldMuted,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pusat Rujukan Penipuan Kebangsaan',
                              style: TextStyle(
                                color: AppColors.textPrimaryOf(context),
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Jika anda telah menjadi mangsa penipuan atau mempunyai maklumat lanjut, sila hubungi segera:',
                          style: TextStyle(
                            color: AppColors.textSecondaryOf(context),
                            fontSize: 10,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GradientButton(
                          label: 'Hubungi 997 — NSRC',
                          icon: LucideIcons.phone,
                          width: double.infinity,
                          gradientColors: const [Color(0xFF106452), Color(0xFF106452)],
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Dail 997 untuk NSRC (National Scam Response Centre)',
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Talian Bebas Tol  •  24 Jam  •  7 Hari Seminggu',
                            style: TextStyle(
                              color: AppColors.isDark(context)
                                  ? AppColors.emeraldMuted
                                  : AppColors.lightEmeraldMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 460.ms, duration: 350.ms),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 8.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildWarningCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget chip,
    int delay = 0,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              // Solid icon background
              color: AppColors.isDark(context)
                  ? iconColor.withValues(alpha: 0.20)
                  : iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                chip,
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 350.ms);
  }

  Widget _buildCampaignCard(
    BuildContext context, {
    required String emoji,
    required String brand,
    required String title,
    required String body,
    required Color accentColor,
    int delay = 0,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      border: Border.all(
        color: accentColor.withValues(alpha: 0.35),
        width: 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                brand,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimaryOf(context),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: TextStyle(
              color: AppColors.textSecondaryOf(context),
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 350.ms);
  }


}
