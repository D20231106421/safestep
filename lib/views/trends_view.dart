import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';

import '../providers/game_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_app_bar.dart';
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
      themeColor: AppColors.mutedBadgeBgDark,
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
      themeColor: AppColors.mutedBadgeBgDark,
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
      themeColor: AppColors.mutedBadgeBgDark,
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
      themeColor: AppColors.mutedBadgeBgDark,
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
      themeColor: AppColors.mutedBadgeBgDark,
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

  static const List<ScamDetail> communicationGuides = [
    ScamDetail(
      title: 'Perlindungan Penipuan WhatsApp',
      icon: LucideIcons.messageSquare,
      themeColor: AppColors.mutedBadgeBgDark,
      definition: 'Lindungi Diri Anda di WhatsApp: Ketahui cara mengenal pasti dan mengelakkan penipuan WhatsApp yang menyasarkan rakyat Malaysia. Daripada mesej palsu hinggalah penipuan penyamaran. Lebih 30% penipuan dalam talian di Malaysia bermula di WhatsApp.',
      howItWorks: [
        'Pemberitahuan Penghantaran Palsu: Scammer menghantar mesej menyamar sebagai syarikat kurier dan meminta anda mengklik pautan atau membayar yuran. (Contoh: Bungkusan anda ditahan di kastam. Klik di sini untuk membayar yuran kastam RM15: [pautan berniat jahat])',
        'Penipuan Penyamaran: Penipu menyamar sebagai rakan atau ahli keluarga anda untuk meminta pemindahan wang dengan segera. (Contoh: Hi, ini anak mak. Telefon saya rosak, boleh tak transfer wang sikit dengan segera?)',
        'Penipuan Tawaran Pekerjaan: Perekrut palsu menawarkan kerja dari rumah berpendapatan tinggi yang memerlukan pembayaran pendahuluan. (Contoh: Jana RM5000/sebulan bekerja dari rumah! Hanya bayar yuran pendaftaran RM300 untuk bermula.)',
        'Skim Pelaburan: Skim cepat kaya yang menjanjikan pulangan tidak masuk akal untuk mata wang kripto, forex, atau pelaburan lain. (Contoh: Sertai kumpulan pelaburan eksklusif kami! Jaminan pulangan 300% dalam masa 30 hari!)',
        'Khidmat Pelanggan Palsu: Penipu menyamar sebagai kakitangan sokongan rasmi syarikat untuk meminta maklumat peribadi atau pembayaran. (Contoh: Akaun anda telah digantung. Hubungi pasukan sokongan kami di [nombor palsu] untuk mengaktifkannya semula.)',
      ],
      warningSigns: [
        'Mesej daripada nombor tidak dikenali yang mendakwa mereka adalah seseorang yang anda kenali',
        'Permintaan mendesak untuk wang atau maklumat peribadi',
        'Pautan yang dipendekkan (bit.ly, tinyurl, dll.)',
        'Kesilapan ejaan dan tatabahasa dalam mesej rasmi',
        'Tawaran yang kelihatan terlalu bagus untuk menjadi kenyataan',
        'Tekanan untuk bertindak segera tanpa masa untuk membuat pengesahan',
        'Permintaan untuk beralih ke platform perbualan yang lain',
        'Mesej yang tidak diminta mengenai hadiah, bayaran balik, atau bungkusan',
      ],
      whatToDo: [
        'Aktifkan pengesahan dua langkah di tetapan WhatsApp',
        'Jangan sesekali berkongsi kod OTP atau TAC dengan sesiapa melalui WhatsApp',
        'Sahkan identiti dengan menelefon individu tersebut menggunakan nombor mereka yang anda ketahui',
        'Jangan klik pautan yang mencurigakan - taip URL secara manual',
        'Gunakan ciri Lihat Kod Keselamatan WhatsApp untuk kenalan penting',
        'Berhati-hati dengan mesej daripada nombor menggunakan kod negara asing',
        'Sekat dan laporkan akaun yang mencurigakan dengan segera',
        'Jangan muat turun fail daripada penghantar yang tidak dikenali',
        'Sahkan nombor telefon syarikat melalui laman web rasmi mereka',
        'Aktifkan tetapan privasi untuk mengehadkan siapa yang boleh memasukkan anda ke dalam kumpulan WhatsApp',
      ],
      ifAlreadyScammed: [
        'Tangkap layar perbualan tersebut sebagai bukti',
        'Sekat nombor penipu tersebut di WhatsApp',
        'Laporkan akaun kepada WhatsApp (Tekan lama pada mesej > Lapor)',
        'Jika wang telah dipindahkan, hubungi bank anda dengan segera',
        'Buat laporan polis di CCID PDRM (03-2610-1559)',
        'Lapor kepada talian hotline Cyber999 SKMM (1-300-88-2999)',
        'Kongsi nombor penipu di ScamChecker untuk memberi amaran kepada orang lain',
      ],
      reportingContacts: [
        'Talian Hotline PDRM CCID: 03-2610-1559',
        'Talian Hotline Cyber999: 1-300-88-2999',
        'Bank Negara (BNMTELELINK): 1-300-88-5465',
      ],
    ),
    ScamDetail(
      title: 'Perlindungan Penipuan E-mel',
      icon: LucideIcons.mail,
      themeColor: AppColors.mutedBadgeBgDark,
      definition: 'Perlindungan Phishing E-mel: Ketahui cara mengenal pasti dan mengelakkan penipuan e-mel termasuk pemancingan data, penyamaran e-mel, dan kompromi e-mel perniagaan. E-mel kekal sebagai vektor #1 untuk serangan siber di Malaysia.',
      howItWorks: [
        'E-mel Phishing Bank: E-mel palsu yang menyamar sebagai bank anda untuk meminta anda mengesahkan butiran akaun atau mengklik pautan berniat jahat. (Contoh: Subjek: SEGERA - Akaun Digantung. Klik di sini dalam masa 24 jam untuk mengaktifkan semula akaun anda.)',
        'Penipuan Penghantaran Bungkusan: E-mel yang mendakwa dari syarikat kurier tentang kegagalan penghantaran atau yuran kastam. (Contoh: Penghantaran bungkusan anda gagal. Bayar yuran penghantaran semula RM20 di sini: [pautan phishing])',
        'Penipuan Bayaran Balik Cukai: E-mel palsu daripada LHDN atau pihak berkuasa cukai yang menjanjikan bayaran balik atau mengancam dengan penalti. (Contoh: Anda layak menerima bayaran balik cukai sebanyak RM2,350. Klik di sini untuk menuntut dalam masa 7 hari.)',
        'Kompromi E-mel Perniagaan: Penipu menyamar sebagai eksekutif syarikat dan meminta pekerja memindahkan wang atau berkongsi data sensitif. (Contoh: Daripada: CEO ceo@syarikat-palsu.com - SEGERA: Pindahkan RM50,000 ke akaun ini segera untuk urusan pengambilalihan.)',
        'Penipuan Invois: Invois palsu atau permintaan pembayaran yang kelihatan sah tetapi mengubah hala pembayaran ke akaun penipu. (Contoh: Invois tertunggak. Akaun bank kami telah bertukar. Sila kemas kini butiran pembayaran dan masukkan wang ke akaun baharu.)',
      ],
      warningSigns: [
        'Sapaan umum (Pelanggan Dihormati, Pengguna Dihormati)',
        'Kesilapan ejaan dan tatabahasa',
        'Mewujudkan rasa terdesak atau ancaman (akaun akan ditutup, tindakan undang-undang)',
        'E-mel penghantar tidak sepadan dengan domain rasmi',
        'Lampiran yang mencurigakan (fail .exe, .zip daripada penghantar tidak dikenali)',
        'Pautan dengan URL yang salah eja atau domain pelik',
        'Permintaan untuk maklumat sensitif melalui e-mel',
        'Invois atau permintaan pembayaran yang tidak dijangka',
        'Tawaran yang terlalu bagus (hadiah, bayaran balik, harta pusaka)',
      ],
      whatToDo: [
        'Halakan kursor pada pautan untuk menyemak URL sebenar sebelum klik',
        'Sahkan alamat e-mel penghantar dengan teliti (semak alamat penuh, bukan nama paparan sahaja)',
        'Jangan sesekali memuat turun lampiran daripada penghantar tidak dikenali',
        'Taip URL bank atau laman web rasmi secara manual dan elakkan mengklik pautan e-mel',
        'Aktifkan penapis spam dan pastikan ia sentiasa dikemas kini',
        'Gunakan pengesahan e-mel (SPF, DKIM) untuk e-mel perniagaan',
        'Latih pekerja untuk mengenal pasti cubaan phishing',
        'Sentiasa sahkan permintaan pembayaran melalui saluran sekunder (panggilan telefon)',
        'Pastikan perisian dan pelanggan e-mel dikemas kini',
        'Laporkan e-mel mencurigakan kepada jabatan IT atau pembekal e-mel anda',
      ],
      ifAlreadyScammed: [
        'Jangan klik sebarang pautan atau memuat turun lampiran',
        'Tandakan e-mel sebagai spam atau phishing dalam pelanggan e-mel anda',
        'Majukan e-mel phishing kepada pasukan penyalahgunaan pembekal e-mel anda',
        'Jika mereka menyamar sebagai sebuah syarikat, laporkan kepada e-mel rasmi syarikat tersebut',
        'Padamkan e-mel dari peti masuk dan tong sampah anda',
        'Jika anda telah klik pautan, tukar kata laluan anda dengan segera',
        'Jalankan imbasan antivirus jika anda telah memuat turun apa-apa',
        'Lapor kepada CyberSecurity Malaysia (cyber999@cybersecurity.my)',
      ],
      reportingContacts: [
        'Talian Hotline PDRM CCID: 03-2610-1559',
        'Talian Hotline Cyber999: 1-300-88-2999',
        'Bank Negara (BNMTELELINK): 1-300-88-5465',
      ],
    ),
    ScamDetail(
      title: 'Perlindungan Penipuan SMS',
      icon: LucideIcons.smartphone,
      themeColor: AppColors.mutedBadgeBgDark,
      definition: 'Pencegahan Penipuan SMS: Lindungi diri anda daripada penipuan SMS termasuk pemberitahuan penghantaran palsu, amaran bank, dan penyamaran kerajaan. Jutaan mesej SMS penipuan dihantar kepada rakyat Malaysia setiap bulan.',
      howItWorks: [
        'SMS Penghantaran Palsu: Mesej yang mendakwa daripada perkhidmatan kurier (PosLaju, J&T, dll.) yang mengandungi pautan berniat jahat. (Contoh: PosLaju: Bungkusan anda gagal dihantar. Dijadualkan semula ke [tarikh]. Jejaki di sini: http://poslaju-my.com)',
        'Penipuan SMS Bank: Mesej palsu yang menyamar sebagai bank mengenai isu akaun, transaksi mencurigakan, atau sekatan kad. (Contoh: Maybank: Akaun anda digantung sementara kerana aktiviti mencurigakan. Sahkan sekarang: [pautan])',
        'Penyamaran Kerajaan: SMS yang mendakwa daripada LHDN, PDRM, JPJ, atau agensi lain mengenai saman, bayaran balik, atau isu undang-undang. (Contoh: LHDN: Anda mempunyai bayaran balik cukai yang belum dituntut sebanyak RM3,200. Klik untuk tuntut: [pautan phishing])',
        'Kecurian OTP/TAC: Penipu menelefon dan menyamar sebagai bank/syarikat meminta anda berkongsi OTP/TAC yang baru anda terima. (Contoh: Terima OTP: 123456. Kemudian pemanggil: Saya dari bank anda, tolong beritahu kod yang baru anda terima untuk pengesahan.)',
        'Penipuan Hadiah & Cabutan Bertuah: SMS mendakwa anda memenangi hadiah dari peraduan yang anda tidak pernah sertai. (Contoh: Tahniah! Anda memenangi RM50,000 dalam Cabutan Bertuah Shopee! Klik untuk tebus: [pautan scam])',
      ],
      warningSigns: [
        'Nombor penghantar tidak dikenali (terutamanya nombor antarabangsa)',
        'Kesilapan ejaan nama syarikat atau domain pelik pada pautan',
        'Taktik mendesak (bertindak dalam 24 jam, akaun akan ditutup)',
        'Permintaan untuk mengklik pautan atau memuat turun aplikasi',
        'Kesilapan ejaan dan tatabahasa',
        'Permintaan untuk maklumat peribadi atau kata laluan melalui SMS',
        'Hadiah dari peraduan yang anda tidak pernah sertai',
        'URL dipendekkan yang mencurigakan (bit.ly, dll.)',
        'Mesej tentang bungkusan yang tidak anda pesan',
      ],
      whatToDo: [
        'Jangan sesekali klik pautan dalam SMS yang tidak dijangka',
        'Buat pengesahan dengan menghubungi nombor rasmi (dari laman web/kad bank, bukan dari SMS)',
        'Semak nombor penghantar - syarikat rasmi menggunakan kod pendek atau nombor yang disahkan',
        'Jangan sesekali berkongsi kod OTP/TAC dengan sesiapa, walaupun mereka mendakwa dari bank anda',
        'Taip URL laman web rasmi secara manual dan elakkan klik pautan SMS',
        'Aktifkan penapis SMS pada telefon anda',
        'Simpan nombor rasmi syarikat untuk mengenali mesej yang sah',
        'Lebih berhati-hati dengan mesej yang mendesak atau berbaur ancaman',
        'Laporkan SMS penipuan kepada penyedia syarikat telekomunikasi anda',
        'Didik ahli keluarga, terutamanya warga emas, tentang penipuan SMS',
      ],
      ifAlreadyScammed: [
        'Jangan klik sebarang pautan dalam SMS',
        'Tangkap layar mesej sebagai bukti',
        'Majukan SMS penipuan kepada SKMM di 15888 (untuk Malaysia)',
        'Sekat nombor penghantar pada telefon anda',
        'Lapor kepada penyedia perkhidmatan mudah alih anda (Maxis, Celcom, Digi, dll.)',
        'Jika anda klik pautan dan memasukkan butiran, hubungi bank anda dengan segera',
        'Tukar kata laluan yang terjejas dan aktifkan 2FA',
        'Buat laporan polis di CCID PDRM jika anda kehilangan wang',
        'Kongsi nombor penipu di ScamChecker untuk memberi amaran kepada orang lain',
      ],
      reportingContacts: [
        'Talian Hotline PDRM CCID: 03-2610-1559',
        'Talian Hotline Cyber999: 1-300-88-2999',
        'Bank Negara (BNMTELELINK): 1-300-88-5465',
      ],
    ),
    ScamDetail(
      title: 'Perlindungan Penipuan Panggilan Telefon',
      icon: LucideIcons.phoneCall,
      themeColor: AppColors.mutedBadgeBgDark,
      definition: 'Pencegahan Penipuan Panggilan Telefon: Ketahui cara mengenal pasti dan melindungi diri anda daripada penipuan panggilan suara termasuk penipuan Macau Scam, penyamaran pegawai bank, ugutan penguat kuasa, dan panggilan robotik automatik. Panggilan suara merupakan taktik manipulasi psikologi yang paling agresif dan mengakibatkan kerugian kewangan terbesar di Malaysia.',
      howItWorks: [
        'Penyamaran Agensi Penguatkuasa dan Mahkamah: Penipu menyamar sebagai pegawai polis, pegawai mahkamah, SPRM, atau LHDN yang mendakwa anda terlibat dalam jenayah penggubahan wang haram atau tunggakan cukai dan mengugut untuk menangkap anda. (Contoh: Panggilan mendakwa daripada Ibu Pejabat Polis Bukit Aman menyatakan akaun anda digunakan untuk transaksi dadah bernilai RM2.5 juta dan waran tangkap telah dikeluarkan atas nama anda.)',
        'Penipuan Pegawai Bank dan Kad Kredit: Pemanggil mendakwa daripada jabatan keselamatan bank menyatakan kad kredit anda telah digunakan di lokasi lain atau pinjaman peribadi telah diluluskan atas nama anda. (Contoh: Selamat pagi, saya dari Bahagian Pencegahan Penipuan Bank. Kami mengesan transaksi kad kredit sebanyak RM4,800 di KLIA. Sila sahkan atau batalkan transaksi ini segera.)',
        'Penipuan Pakej Kurier dan Kastam: Pemanggil mendakwa dari syarikat penghantaran bungkusan atau Jabatan Kastam menyatakan ada bungkusan haram yang dihantar atas nama anda dan memerlukan pembayaran rasmi untuk diselesaikan. (Contoh: Bungkusan anda mengandungi barang terlarang seperti kad pengenalan palsu dan ditahan di pejabat pos. Panggilan anda akan disambungkan terus ke balai polis untuk siasatan.)',
        'Kecurian Kod OTP dan Pengesahan Transaksi: Penipu mendakwa telah tersalah memasukkan nombor telefon anda untuk urusan bank dan memohon anda membaca kod pengesahan yang baru dihantar ke telefon anda. (Contoh: Maaf encik, saya tersilap letak nombor telefon semasa daftar akaun online. Boleh tolong beritahu nombor enam digit yang baru masuk ke SMS encik?)',
        'Panggilan Robotik Automatik Interaktif: Panggilan suara rakaman berkomputer yang menyamar sebagai kementerian, syarikat telekomunikasi, atau bank yang mengarahkan anda menekan butang nombor untuk bercakap dengan pegawai. (Contoh: Rakaman suara: Ini adalah amaran terakhir daripada Mahkamah Tinggi. Talian anda akan dipotong dalam tempoh dua jam. Tekan nombor sembilan untuk berhubung dengan pegawai bertugas.)',
        'Penipuan Penyamaran Suara Keluarga: Penipu menggunakan teknik tiruan suara atau penyamaran rakan lama atau ahli keluarga yang menangis atau terdesak meminta wang ikat jamin atau bayaran hospital kecemasan. (Contoh: Pemanggil menangis: Tolong saya, saya ditahan polis sebab kemalangan jalan raya. Tolong jangan beritahu sesiapa dan pindahkan wang jaminan RM10,000 ke akaun peguam ini segera.)',
      ],
      warningSigns: [
        'Pemanggil mendakwa dari agensi kerajaan tetapi menyambungkan panggilan anda terus ke balai polis atau mahkamah dalam satu talian',
        'Meminta anda memindahkan wang ke akaun peribadi pihak ketiga atau akaun audit keselamatan',
        'Menggunakan ugutan waran tangkap, akaun dibekukan, atau tindakan mahkamah segera',
        'Melarang anda memutuskan panggilan, berbincang dengan ahli keluarga, atau memberitahu pihak ketiga',
        'Meminta nombor kad pengenalan, nombor kad bank, nombor CVV di belakang kad, kata laluan, atau kod OTP',
        'Panggilan menggunakan nombor telefon bimbit peribadi atau nombor antarabangsa yang menyerupai nombor rasmi',
        'Menggunakan nada suara yang menengking, mendesak, atau cuba menimbulkan rasa panik dan takut',
        'Nada suara rakaman automatik yang meminta anda menekan nombor telefon tertentu',
        'Mendakwa wang dalam akaun bank anda perlu disiasat atau diaudit oleh Bank Negara Malaysia',
      ],
      whatToDo: [
        'Letakkan panggilan telefon dengan serta-merta jika pemanggil mula bercakap mengenai kes polis, cukai, mahkamah, atau pemindahan wang',
        'Sahkan sebarang dakwaan dengan menghubungi nombor rasmi agensi tersebut melalui carian sendiri di portal rasmi',
        'Ingat bahawa agensi kerajaan dan pihak polis tidak pernah menyelesaikan kes jenayah atau waran tangkap melalui telefon',
        'Bank Negara Malaysia dan pihak bank tidak pernah meminta pengguna memindahkan wang ke akaun audit keselamatan',
        'Jangan sesekali membacakan atau berkongsi kod OTP, TAC, nombor PIN, atau kata laluan kepada mana-mana pemanggil',
        'Pasang aplikasi pengesanan nombor telefon yang sah pada peranti anda untuk mengenal pasti panggilan penipuan',
        'Hubungi ahli keluarga secara terus melalui nombor yang anda simpan jika menerima panggilan kecemasan mengenai mereka',
        'Bertenang dan jangan panik apabila pemanggil cuba mengugut atau menggunakan bahasa yang mendesak',
        'Jangan tekan sebarang nombor pada papan kekunci telefon semasa menerima panggilan robotik automatik',
        'Jangan percayai paparan nombor pemanggil kerana penipu boleh memalsukan identiti nombor menggunakan teknologi pengklonan',
      ],
      ifAlreadyScammed: [
        'Hentikan perbualan dan jangan buat sebarang pemindahan wang tambahan',
        'Hubungi Pusat Tindak Balas Penipuan Kebangsaan di talian 997 dengan kadar segera jika transaksi baru sahaja berlaku',
        'Hubungi bahagian khidmat pelanggan bank anda serta-merta untuk membekukan akaun dan menyekat kad perbankan',
        'Tangkap layar rekod panggilan telefon, nombor pemanggil, dan bukti transaksi pemindahan wang',
        'Buat laporan polis di Balai Polis berhampiran atau hubungi Jabatan Siasatan Jenayah Komersil PDRM',
        'Laporkan nombor pemanggil penipu tersebut kepada penyedia perkhidmatan telekomunikasi anda',
        'Sekat nombor telefon tersebut pada peranti mudah alih anda',
        'Kongsi nombor telefon penipu di portal SemakMule PDRM dan platform ScamChecker untuk memberi amaran kepada orang ramai',
      ],
      reportingContacts: [
        'Pusat Tindak Balas Penipuan Kebangsaan (NSRC): 997',
        'Talian Hotline PDRM CCID: 03-2610-1559',
        'Talian Hotline Cyber999: 1-300-88-2999',
        'Bank Negara (BNMTELELINK): 1-300-88-5465',
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
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                children: [
                  // Section Title
                  _sectionLabel(
                    'JENIS SCAM YANG KERAP BERLAKU',
                    LucideIcons.alertTriangle,
                    AppColors.emerald,
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

                  // Communication Safety Guides
                  _sectionLabel(
                    'PANDUAN KESELAMATAN MEDIUM KOMUNIKASI',
                    LucideIcons.messageSquare,
                    AppColors.emerald,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: List.generate(communicationGuides.length, (index) {
                      final guide = communicationGuides[index];
                      return _buildScamTypeCard(context, guide, delay: 350 + (index * 40));
                    }),
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

  Widget _sectionLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w900,
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
    );
  }
}
