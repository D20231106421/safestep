import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';

import '../providers/game_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/gradient_button.dart';
import 'scam_detail_view.dart';

class ScamDetail {
  final String title;
  final String definition;
  final List<String> howItWorks;
  final List<String> warningSigns;
  final List<String> whatToDo;
  final List<String> ifAlreadyScammed;
  final List<String> reportingContacts;
  final IconData icon;
  final Color themeColor;

  const ScamDetail({
    required this.title,
    required this.definition,
    required this.howItWorks,
    required this.warningSigns,
    required this.whatToDo,
    required this.ifAlreadyScammed,
    required this.reportingContacts,
    required this.icon,
    required this.themeColor,
  });
}

class TrendsView extends StatelessWidget {
  const TrendsView({super.key});

  static const List<ScamDetail> scamDetails = [
    ScamDetail(
      title: 'Phishing & Smishing',
      icon: LucideIcons.mail,
      themeColor: AppColors.rose,
      definition: 'Penipuan melalui e-mel, SMS, WhatsApp, atau mesej lain yang menyamar sebagai organisasi sah seperti bank, agensi kerajaan, syarikat penghantaran, atau jenama terkenal dengan tujuan mencuri maklumat peribadi dan kewangan.',
      howItWorks: [
        'Penipu menghantar mesej yang mendakwa akaun anda dikunci atau bungkusan tertahan.',
        'Mesej mengandungi pautan ke laman web palsu yang kelihatan hampir sama dengan laman web rasmi.',
        'Apabila anda memasukkan maklumat peribadi atau perbankan, penipu akan mencurinya secara langsung.'
      ],
      warningSigns: [
        'Mesej mengatakan akaun anda dikunci secara tiba-tiba.',
        'Diminta mengesahkan maklumat akaun melalui pautan yang diberikan.',
        'Alamat pengirim kelihatan pelik atau ada perbezaan kecil daripada organisasi sebenar.',
        'Menggunakan bahasa mendesak seperti "bertindak sekarang" atau "akaun digantung".',
        'Lampiran fail atau invois yang mencurigakan.',
        'Ucapan am seperti "Dear customer" dan kesalahan ejaan/tatabahasa.'
      ],
      whatToDo: [
        'Jangan sekali-kali klik pada pautan atau muat turun lampiran yang mencurigakan.',
        'Jangan balas mesej tersebut, padamkannya segera.',
        'Tandakan mesej atau e-mel tersebut sebagai spam/junk.',
        'Imbas peranti anda dengan antivirus jika anda telah terklik pautan.'
      ],
      ifAlreadyScammed: [
        'Tukar kata laluan perbankan dan akaun penting anda dengan segera.',
        'Hubungi bank anda dengan kadar segera sekiranya maklumat perbankan telah didedahkan.'
      ],
      reportingContacts: [
        'Hubungi National Scam Response Centre (NSRC) di talian 997.',
        'Laporkan kepada MCMC di aduan.skmm.gov.my, PDRM CCID, atau bank anda.'
      ],
    ),
    ScamDetail(
      title: 'Penyamaran Pihak Berkuasa & Agensi Kerajaan',
      icon: LucideIcons.userCheck,
      themeColor: AppColors.amber,
      definition: 'Penipuan di mana penipu menyamar sebagai ahli keluarga, rakan, pegawai kerajaan (PDRM, LHDN), pekerja bank, jenama terkenal, atau selebriti untuk memperdayakan anda.',
      howItWorks: [
        'Penipu mencipta akaun media sosial atau WhatsApp palsu menggunakan nama dan gambar orang sebenar.',
        'Mereka menghantar mesej mendakwa ada kecemasan dan memerlukan bantuan kewangan segera.',
        'Mereka menggunakan Caller ID palsu (spoofing), logo rasmi palsu, atau teknologi deepfake/suara AI untuk meyakinkan mangsa.'
      ],
      warningSigns: [
        'Permintaan wang secara tiba-tiba atas alasan kecemasan.',
        'Akaun baru yang mencurigakan dengan sejarah aktiviti yang sangat sedikit.',
        'Penggunaan e-mel peribadi (seperti Gmail) untuk urusan rasmi agensi kerajaan.',
        'Video atau rakaman suara yang kelihatan/kedengaran tidak semula jadi.',
        'Peluang pelaburan atau promosi hadiah yang disokong oleh "selebriti" tanpa pengesahan.'
      ],
      whatToDo: [
        'Hubungi terus individu tersebut melalui nombor telefon yang anda memang ketahui sah.',
        'Sahkan identiti pegawai atau agensi melalui saluran/laman web rasmi mereka.',
        'Semak umur akaun media sosial, bilangan rakan bersama, dan sejarah hantarannya.',
        'Jangan sesekali klik pautan atau memindahkan wang secara tergesa-gesa.'
      ],
      ifAlreadyScammed: [
        'Laporkan akaun palsu tersebut kepada platform media sosial berkenaan.',
        'Tukar kata laluan dan aktifkan Pengesahan 2-Faktor (2FA) pada akaun anda.',
        'Beritahu rakan-rakan dan keluarga anda mengenai penyamaran tersebut.',
        'Hubungi bank segera jika wang telah dipindahkan dan buat laporan polis.'
      ],
      reportingContacts: [
        'Hubungi National Scam Response Centre (NSRC) di talian 997.',
        'Laporkan kepada PDRM CCID di talian 03-2610 1559 atau Balai Polis berhampiran.'
      ],
    ),
    ScamDetail(
      title: 'Penipuan Sokongan Teknikal & Bank',
      icon: LucideIcons.monitorPlay,
      themeColor: AppColors.indigo,
      definition: 'Penipu menyamar sebagai kakitangan sokongan teknikal atau pegawai bank untuk mendapatkan akses ke peranti atau akaun kewangan anda bagi mencuri wang dan data peribadi.',
      howItWorks: [
        'Pop-up amaran virus palsu muncul pada pelayar web meminta anda hubungi nombor sokongan.',
        'Penipu mendesak anda pasang perisian kawalan jauh (TeamViewer, AnyDesk) untuk akses peranti.',
        'Penipu menyamar sebagai pegawai bank dan mendakwa akaun anda terlibat dalam aktiviti haram.',
        'Mereka meminta OTP/TAC, PIN, atau maklumat kad melalui telefon atau pautan.',
        'Ada yang menggunakan Caller ID Spoofing supaya nombor mereka kelihatan seperti nombor bank rasmi.',
        'Mangsa diarahkan pindahkan wang ke "akaun selamat" yang sebenarnya dikawali penipu.'
      ],
      warningSigns: [
        'Syarikat teknologi atau bank menghubungi anda secara tiba-tiba tanpa sebarang permintaan.',
        'Dakwaan komputer anda dijangkiti virus atau akaun bank anda disekat.',
        'Didesak memasang aplikasi kawalan peranti jarak jauh.',
        'Bank tidak pernah meminta OTP, TAC, PIN, atau kata laluan melalui telefon atau WhatsApp.',
        'Diminta pindahkan wang ke akaun lain atas sebab "keselamatan" atau "siasatan".',
        'Nombor telefon kelihatan seperti nombor bank rasmi tetapi meminta tindakan luar biasa.'
      ],
      whatToDo: [
        'Letak telefon segera jika menerima panggilan sokongan teknikal atau bank yang mencurigakan.',
        'Jangan sesekali pasang aplikasi kawalan jauh atau kongsi OTP/TAC kepada sesiapa.',
        'Tutup pop-up palsu dengan selamat (guna Task Manager jika pelayar terkunci).',
        'Sahkan dengan bank menggunakan nombor rasmi di belakang kad atau laman web bank.',
        'Jangan ikut arahan pindah wang walaupun kononnya "pegawai bank" yang minta.'
      ],
      ifAlreadyScammed: [
        'Putuskan sambungan internet peranti anda dengan kadar segera.',
        'Nyahpasang semua perisian akses jauh yang dipasang oleh penipu.',
        'Hubungi bank dengan segera untuk bekukan akaun dan hentikan sebarang transaksi.',
        'Tukar semua kata laluan akaun penting dan imbas peranti daripada malware.',
        'Minta chargeback jika bayaran dibuat menggunakan kad kredit.',
        'Buat laporan polis dan laporkan kepada Bank Negara Malaysia.'
      ],
      reportingContacts: [
        'National Scam Response Centre (NSRC): 997.',
        'Cyber999: 1-300-88-2999.',
        'Bank Negara Malaysia: 1-300-88-5465.',
        'PDRM CCID: 03-2610 1559.'
      ],
    ),
    ScamDetail(
      title: 'Cabutan Bertuah & Hadiah Palsu',
      icon: LucideIcons.gift,
      themeColor: AppColors.emerald,
      definition: 'Penipuan di mana mangsa diberitahu mereka telah memenangi hadiah lumayan, loteri, atau pertandingan walaupun mereka tidak pernah menyertainya, sebagai umpan untuk memeras wang.',
      howItWorks: [
        'Mangsa menerima SMS, e-mel, atau mesej media sosial yang mendakwa mereka memenangi hadiah eksklusif.',
        'Penipu meminta mangsa membuat bayaran awal (cukai, duti kastam, yuran proses) sebelum hadiah boleh dihantar.',
        'Mangsa diarahkan ke laman web palsu untuk mengisi maklumat kad kredit/perbankan.'
      ],
      warningSigns: [
        'Hadiah yang ditawarkan terlalu tidak realistik atau terlalu bagus untuk dipercayai.',
        'Pengumuman kemenangan untuk pertandingan yang tidak pernah anda sertai.',
        'Diminta membuat bayaran awal bagi menuntut hadiah (syarikat sah tidak akan berbuat demikian).',
        'Tekanan psikologi seperti "tawaran tamat hari ini" atau "peluang terakhir anda".',
        'E-mel atau mesej rasmi yang dihantar daripada domain e-mel yang mencurigakan.'
      ],
      whatToDo: [
        'Jangan balas mesej tersebut, jangan klik pautan, dan sekat penghantar segera.',
        'Lakukan carian Google menggunakan nama pertandingan ditambah dengan perkataan "scam".',
        'Hubungi terus syarikat rasmi yang kononnya menganjurkan pertandingan melalui saluran rasmi.'
      ],
      ifAlreadyScammed: [
        'Hubungi bank anda dengan kadar segera untuk membekukan akaun atau kad bank anda.',
        'Minta pengembalian caj (chargeback) sekiranya anda membayar menggunakan kad kredit.',
        'Lakukan tetapan semula kilang (factory reset) pada telefon jika anda telah memuat turun aplikasi yang mencurigakan.',
        'Buat laporan polis rasmi dengan segera.'
      ],
      reportingContacts: [
        'Hubungi National Scam Response Centre di 997.',
        'Laporkan kepada MCMC dan PDRM CCID.'
      ],
    ),
    ScamDetail(
      title: 'Penipuan Penyamar Keluarga',
      icon: LucideIcons.users,
      themeColor: AppColors.amber,
      definition: 'Penipuan di mana penipu menyamar sebagai ahli keluarga atau rakan rapat untuk meminta wang atau maklumat peribadi sensitif atas alasan kecemasan.',
      howItWorks: [
        'Penipu mengklon akaun media sosial atau WhatsApp menggunakan gambar dan nama orang yang anda kenali.',
        'Mereka menggunakan nombor telefon baru dengan alasan telefon lama telah hilang, rosak, atau bertukar nombor.',
        'Mengirim mesej mendesak meminta pinjaman wang kecemasan untuk membayar bil, hutang, atau urusan kecemasan lain.',
        'Menggunakan teknologi klon suara AI atau deepfake video untuk meniru wajah dan suara ahli keluarga.'
      ],
      warningSigns: [
        'Permintaan wang secara tiba-tiba ke akaun bank pihak ketiga (akaun keldai) atas nama orang lain.',
        'Menghubungi menggunakan nombor baru dan meminta anda memadam atau mengabaikan nombor telefon lama mereka.',
        'Bahasa, panggilan manja, atau gaya mesej yang janggal dan berbeza daripada kebiasaan.',
        'Mengelak daripada menjawab panggilan suara atau video langsung dengan pelbagai alasan teknikal.'
      ],
      whatToDo: [
        'Tamatkan perbualan dan terus hubungi nombor telefon lama/rasmi orang tersebut untuk pengesahan.',
        'Tanya soalan peribadi (soalan ujian) yang hanya diketahui oleh anda berdua untuk menguji identiti mereka.',
        'Semak nama pemilik akaun bank penerima terlebih dahulu (jangan pindah jika nama berbeza daripada nama ahli keluarga).',
        'Jangan sesekali memindahkan wang secara tergesa-gesa tanpa pengesahan lisan.'
      ],
      ifAlreadyScammed: [
        'Hubungi bank anda dengan kadar segera untuk membekukan akaun dan transaksi.',
        'Laporkan akaun palsu atau WhatsApp tersebut kepada platform media sosial berkaitan.',
        'Beritahu ahli keluarga dan rakan-rakan lain mengenai penyamaran tersebut agar mereka tidak turut terkena.',
        'Buat laporan polis rasmi dengan membawa bukti tangkapan skrin dan transaksi bank.'
      ],
      reportingContacts: [
        'Hubungi National Scam Response Centre (NSRC) di talian 997.',
        'Laporkan kepada PDRM CCID atau balai polis berhampiran.'
      ],
    ),
  ];

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
                              color: AppColors.amberBadgeBgOf(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.amberBadgeTextOf(context).withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              LucideIcons.alertOctagon,
                              color: AppColors.amberBadgeTextOf(context),
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

                  // Section Title
                  _sectionLabel(
                    'JENIS SCAM YANG KERAP BERLAKU',
                    LucideIcons.alertTriangle,
                    AppColors.rose,
                  ),
                  const SizedBox(height: 10),

                    // Vertical list of 4 cards/buttons that navigate to ScamDetailView
                    Column(
                      children: List.generate(scamDetails.length, (index) {
                        final detail = scamDetails[index];
                        return _buildScamTypeCard(context, detail, delay: 150 + (index * 40));
                      }),
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
                    delay: 350,
                  ),
                  const SizedBox(height: 10),
                  _buildCampaignCard(
                    context,
                    emoji: '📺',
                    brand: 'ASTRO',
                    title: 'Amaran Rasmi: Pembaruan Kad Astro Palsu',
                    body: 'Astro tidak menghubungi anda melalui WhatsApp untuk mengemaskini set-top-box. Hubungi 1300-82-3838.',
                    accentColor: AppColors.cyan,
                    delay: 390,
                  ),
                  const SizedBox(height: 10),
                  _buildCampaignCard(
                    context,
                    emoji: '🏦',
                    brand: 'BANK NEGARA',
                    title: 'BNM: Laporkan Akaun Mule Melalui BNMLINK',
                    body: 'Menyediakan akaun bank kepada penipu adalah JENAYAH. Hubungi BNM di 1-300-88-5465.',
                    accentColor: AppColors.indigo,
                    delay: 430,
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
                              color: AppColors.emerald,
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
                          gradientColors: const [
                            Color(0xFF106452),
                            Color(0xFF106452),
                          ],
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
                  ).animate().fadeIn(delay: 470.ms, duration: 350.ms),
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

  Widget _buildScamTypeCard(BuildContext context, ScamDetail detail, {required int delay}) {
    final (badgeBg, badgeText) = _getThemeBadgeColors(context, detail.themeColor);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScamDetailView(scamDetail: detail),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: badgeText.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Icon(detail.icon, color: badgeText, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.title,
                      style: TextStyle(
                        color: AppColors.textPrimaryOf(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMutedOf(context),
                size: 20,
              ),
            ],
          ),
        ),
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
