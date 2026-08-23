class ReplyOption {
  final String text;
  final String safety; // 'safe' | 'berisiko' | 'bahaya'

  ReplyOption({
    required this.text,
    required this.safety,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'safety': safety,
      };

  factory ReplyOption.fromJson(Map<String, dynamic> json) {
    return ReplyOption(
      text: json['text'] as String,
      safety: json['safety'] as String,
    );
  }
}

const String kCategoryTechSupport = 'Penipuan Sokongan Teknikal & Bank';
const String kCategoryAuthority = 'Penyamaran Pihak Berkuasa & Agensi Kerajaan';
const String kCategoryGiveaway = 'Cabutan Bertuah & Hadiah Palsu';
const String kCategoryPhishing = 'Phishing & Smishing';
const String kCategoryFamily = 'Penipuan Penyamar Keluarga';
const String kCategoryOthers = 'Lain-lain Jenis Modus Operandi';

String normalizeCategoryLabel(String category) {
  switch (category.trim()) {
    case 'Tech Support Scams (Penipuan Sokongan Teknikal & Bank)':
    case kCategoryTechSupport:
      return kCategoryTechSupport;
    case 'Authority & Government Impersonator Scams (Penyamaran Agensi Kerajaan & Kuasa)':
    case 'Authority & Government impersonator Scams':
    case kCategoryAuthority:
      return kCategoryAuthority;
    case 'Fake Giveaways and Sweepstakes (Cabutan Bertuah & Hadiah Palsu)':
    case 'Fake Giveaways and Sweeptakes':
    case kCategoryGiveaway:
      return kCategoryGiveaway;
    case 'Phishing (Email & SMS "Smishing") (Phishing & Smishing)':
    case 'Phishing (Email & SMS Smishing)':
    case 'Phishing':
    case kCategoryPhishing:
      return kCategoryPhishing;
    case 'Emergency Family Impersonation Scams (Penyamaran Keluarga & Kecemasan)':
    case 'Emergency Family Impersonation Scams':
    case kCategoryFamily:
      return kCategoryFamily;
    default:
      return category;
  }
}

class Scenario {
  final int id;
  final bool isActive;
  final String type; // 'whatsapp' | 'sms' | 'email' | 'phone'
  final String category;
  final String difficulty; // 'Mudah' | 'Sederhana' | 'Sukar'
  final String threatLevel; // 'TINGGI' | 'SEDERHANA'
  final String technique;
  final String sender;
  final String timestamp;
  final String message;
  final bool isScam;
  final String explanation;
  final List<String> recommendedActions;
  final List<ReplyOption> replyOptions;

  Scenario({
    required this.id,
    required this.isActive,
    required this.type,
    required this.category,
    required this.difficulty,
    required this.threatLevel,
    required this.technique,
    required this.sender,
    required this.timestamp,
    required this.message,
    required this.isScam,
    required this.explanation,
    required this.recommendedActions,
    required this.replyOptions,
  });

  Scenario copyWith({
    int? id,
    bool? isActive,
    String? type,
    String? category,
    String? difficulty,
    String? threatLevel,
    String? technique,
    String? sender,
    String? timestamp,
    String? message,
    bool? isScam,
    String? explanation,
    List<String>? recommendedActions,
    List<ReplyOption>? replyOptions,
  }) {
    return Scenario(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      threatLevel: threatLevel ?? this.threatLevel,
      technique: technique ?? this.technique,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      message: message ?? this.message,
      isScam: isScam ?? this.isScam,
      explanation: explanation ?? this.explanation,
      recommendedActions: recommendedActions ?? this.recommendedActions,
      replyOptions: replyOptions ?? this.replyOptions,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'isActive': isActive,
        'type': type,
        'category': category,
        'difficulty': difficulty,
        'threatLevel': threatLevel,
        'technique': technique,
        'sender': sender,
        'timestamp': timestamp,
        'message': message,
        'isScam': isScam,
        'explanation': explanation,
        'recommendedActions': recommendedActions,
        'replyOptions': replyOptions.map((o) => o.toJson()).toList(),
      };

  factory Scenario.fromJson(Map<String, dynamic> json) {
    var recActionsList = json['recommendedActions'] as List? ?? [];
    List<String> recActions = recActionsList.map((e) => e.toString()).toList();

    var optionsList = json['replyOptions'] as List? ?? [];
    List<ReplyOption> options = optionsList
        .map((e) => ReplyOption.fromJson(e as Map<String, dynamic>))
        .toList();

    return Scenario(
      id: json['id'] as int,
      isActive: json['isActive'] as bool? ?? true,
      type: json['type'] as String,
      category: normalizeCategoryLabel(json['category']?.toString() ?? ''),
      difficulty: json['difficulty'] as String? ?? 'Sederhana',
      threatLevel: json['threatLevel'] as String? ?? 'TINGGI',
      technique: json['technique'] as String? ?? 'Social Engineering',
      sender: json['sender'] as String,
      timestamp: json['timestamp'] as String? ?? 'Terkini',
      message: json['message'] as String,
      isScam: json['isScam'] as bool? ?? true,
      explanation: json['explanation'] as String? ?? '',
      recommendedActions: recActions,
      replyOptions: options,
    );
  }
}

// Curated scenarios from React implementation
final List<Scenario> curatedScenarios = [
  Scenario(
    id: 1,
    isActive: true,
    type: 'whatsapp',
    category: 'Penipuan Sokongan Teknikal & Bank',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Social Engineering, Penyalahgunaan Jenama',
    sender: 'Maybank Customer Alert',
    timestamp: '10:15 AM',
    message: "AMARAN MAYBANK: Kami mengesan cubaan pemindahan wang mencurigakan RM1,500 ke akaun 'Lazada Malaysia'. Sila balas mesej WhatsApp ini dengan kod 'BATAL' atau hubungi kami segera melalui chat ini untuk membatalkan transaksi.",
    isScam: true,
    explanation: "Pihak bank tidak pernah menghubungi pelanggan melalui chat WhatsApp biasa untuk meminta pengesahan transaksi atau mengarahkan pembatalan melalui pemesejan.",
    recommendedActions: [
      "Abaikan chat WhatsApp ini serta-merta",
      "Semak sejarah transaksi sebenar di portal rasmi Maybank2u",
      "Jangan sesekali menghantar maklumat peribadi menerusi WhatsApp"
    ],
    replyOptions: [
      ReplyOption(text: "Batal! Sila batalkan transaksi itu sekarang, saya tidak meluluskannya.", safety: "bahaya"),
      ReplyOption(text: "Betul ke ini pihak Maybank? Kenapa tak hubungi telefon?", safety: "berisiko"),
      ReplyOption(text: "Saya letak telefon, abaikan chat ini, dan periksa terus di Maybank2u.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 2,
    isActive: true,
    type: 'sms',
    category: 'Penipuan Sokongan Teknikal & Bank',
    difficulty: 'Sukar',
    threatLevel: 'TINGGI',
    technique: 'Phishing Link (Laman Web Bank Palsu)',
    sender: 'CIMB-SECURE',
    timestamp: 'Baru Sahaja',
    message: "Akaun CIMB Clicks anda telah dinyahaktifkan kerana isu keselamatan. Sila layari https://clicks-verify-mobile.com untuk pengesahan identiti dan memulihkan akses serta-merta.",
    isScam: true,
    explanation: "SMS yang mendakwa akaun bank dinyahaktifkan berserta pautan luar (.com) adalah taktik pancingan (phishing) untuk mencuri ID pengguna dan kata laluan perbankan anda.",
    recommendedActions: [
      "Jangan sesekali menekan pautan di dalam SMS",
      "Hubungi talian di belakang kad ATM/Debit untuk pengesahan akaun",
      "Padamkan SMS tersebut demi keselamatan diri"
    ],
    replyOptions: [
      ReplyOption(text: "Saya klik pautan untuk mengaktifkan semula akaun saya secepat mungkin.", safety: "bahaya"),
      ReplyOption(text: "Saya balas SMS bertanya kenapa akaun saya dinyahaktifkan.", safety: "berisiko"),
      ReplyOption(text: "Saya abaikan SMS ini and terus ke cawangan bank atau portal rasmi CIMB.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 3,
    isActive: true,
    type: 'email',
    category: 'Penipuan Sokongan Teknikal & Bank',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Phishing (Penyamaran E-mel Keselamatan Bank)',
    sender: 'Bank Islam Security <support@bankislam-alert-my.com>',
    timestamp: '8:45 AM',
    message: "AMARAN PINDAHAN: Penukaran nombor telefon TAC/OTP untuk akaun Bank Islam anda sedang diproses. Jika anda tidak meminta perubahan ini, sila batalkan transaksi serta-merta dengan mengesahkan ID anda di: https://bankislam-cancel-phone.com",
    isScam: true,
    explanation: "Alamat e-mel pengirim bukan daripada domain rasmi Bank Islam. Pihak bank tidak pernah menghantar e-mel dengan pautan luar untuk membatalkan sesuatu transaksi.",
    recommendedActions: [
      "Abaikan e-mel palsu ini dan tandakan ia sebagai Spam",
      "Gunakan aplikasi perbankan rasmi untuk menyemak profil peranti anda",
      "Laporkan e-mel tersebut kepada khidmat pelanggan Bank Islam"
    ],
    replyOptions: [
      ReplyOption(text: "Tekan pautan untuk membatalkan pertukaran nombor TAC tersebut dengan cemas.", safety: "bahaya"),
      ReplyOption(text: "Balas e-mel untuk menafikan sebarang pertukaran nombor telefon.", safety: "berisiko"),
      ReplyOption(text: "Padam e-mel ini dan log masuk ke portal perbankan rasmi secara asing.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 4,
    isActive: true,
    type: 'phone',
    category: 'Penipuan Sokongan Teknikal & Bank',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Phone Spoofing, Vishing (Social Engineering)',
    sender: 'Maybank Customer Support',
    timestamp: 'Sedang Berlangsung',
    message: "PANGGILAN MASUK: Encik, kami mengesan transaksi kad kredit anda sebanyak RM5,500 di KLIA. Jika anda tidak melakukan pembelian ini, sila berikan nombor kad kredit dan kod CVV anda sekarang untuk kami lakukan sekatan kecemasan.",
    isScam: true,
    explanation: "Pegawai bank tidak akan meminta butiran kad kredit sensitif seperti tarikh luput atau kod CVV 3-digit menerusi panggilan telefon untuk sebarang pembatalan.",
    recommendedActions: [
      "Letakkan panggilan telefon serta-merta",
      "Hubungi talian hotline khidmat pelanggan bank yang tertera di belakang kad bank",
      "Jangan kongsi nombor kad atau kod OTP/TAC kepada pemanggil"
    ],
    replyOptions: [
      ReplyOption(text: "Sebutkan butiran kad kredit kepada pegawai untuk keselamatan akaun.", safety: "bahaya"),
      ReplyOption(text: "Tanya pegawai tersebut di kedai mana kad tersebut digunakan.", safety: "berisiko"),
      ReplyOption(text: "Letakkan panggilan telefon dan hubungi talian rasmi di belakang kad saya.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 5,
    isActive: true,
    type: 'whatsapp',
    category: 'Penyamaran Pihak Berkuasa & Agensi Kerajaan',
    difficulty: 'Sukar',
    threatLevel: 'TINGGI',
    technique: 'Social Engineering, Pemasangan APK Palsu',
    sender: 'Inspektor Firdaus (PDRM)',
    timestamp: '9:30 AM',
    message: "TUNTUTAN MAHKAMAH: Saya Inspektor Firdaus dari JSJK Bukit Aman. Kad pengenalan anda terlibat kes jenayah dadah. Sila muat turun fail apk ini [Sistem_Semakan_PDRM.apk] untuk melakukan pengesahan cap jari digital bagi membersihkan nama anda.",
    isScam: true,
    explanation: "Polis Diraja Malaysia (PDRM) tidak pernah menjalankan siasatan atau menghantar dokumen waran menerusi WhatsApp, apatah lagi meminta anda memasang aplikasi (.apk) luaran.",
    recommendedActions: [
      "Jangan sesekali memasang fail .apk yang dihantar di WhatsApp",
      "Sahkan identiti pegawai dengan merujuk balai polis yang berhampiran",
      "Laporkan nombor WhatsApp tersebut kepada pihak berkuasa"
    ],
    replyOptions: [
      ReplyOption(text: "Pasang fail APK tersebut supaya nama saya dibersihkan daripada kes jenayah.", safety: "bahaya"),
      ReplyOption(text: "Tanya Inspektor tersebut jika saya boleh hadir sendiri ke balai polis.", safety: "berisiko"),
      ReplyOption(text: "Abaikan mesej, sekat nombor, and tidak sesekali memuat turun fail apk tersebut.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 6,
    isActive: true,
    type: 'sms',
    category: 'Penyamaran Pihak Berkuasa & Agensi Kerajaan',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Phishing Link (Portal LHDN Palsu)',
    sender: 'LHDN-INFO',
    timestamp: 'Baru Sahaja',
    message: "NOTIS LHDN: Pengesahan tunggakan cukai pendapatan taksiran 2025 berjumlah RM2,850. Sila buat pembayaran dalam masa 24 jam di portal https://lhdn-online-pay.info bagi mengelakkan waran sita dikeluarkan.",
    isScam: true,
    explanation: "Urusan rasmi Lembaga Hasil Dalam Negeri (LHDN) menggunakan domain rasmi '.gov.my' bukan '.info'. Urusan tunggakan cukai rasmi akan diuruskan menerusi surat berdaftar atau portal MyTax rasmi sahaja.",
    recommendedActions: [
      "Abaikan pautan asing .info yang mendakwa dari agensi kerajaan",
      "Log masuk ke portal MyTax rasmi (mytax.hasil.gov.my) untuk menyemak status cukai sebenar",
      "Jangan terpedaya dengan ugutan sita harta atau denda dalam masa 24 jam"
    ],
    replyOptions: [
      ReplyOption(text: "Buka pautan tersebut dan terus buat pembayaran cukai untuk elak waran sivil.", safety: "bahaya"),
      ReplyOption(text: "Balas SMS ini untuk merayu denda atau denda pengampunan.", safety: "berisiko"),
      ReplyOption(text: "Padam SMS dan buat semakan tunggakan secara terus di portal rasmi MyTax.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 7,
    isActive: true,
    type: 'email',
    category: 'Penyamaran Pihak Berkuasa & Agensi Kerajaan',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Phishing (Penyamaran Portal Mahkamah)',
    sender: 'Pendaftar Mahkamah Tinggi <summons-notice@mahkamah-gov-portal.org>',
    timestamp: '11:00 AM',
    message: "TUNTUTAN SIVIL: Satu tuntutan saman sivil telah difailkan terhadap anda atas kesalahan penipuan dokumen. Sila muat turun salinan saman sivil ini untuk memfailkan bantuhan dalam talian sebelum akaun bank anda dibekukan: https://mahkamah-e-filing.com",
    isScam: true,
    explanation: "Segala urusan pertuduhan atau saman mahkamah di Malaysia dihantar secara surat fizikal berdaftar (serahan tangan/pos berdaftar) ke alamat kediaman rasmi, bukannya menggunakan e-mel dengan pautan portal siber asing.",
    recommendedActions: [
      "Jangan menekan pautan di dalam e-mel yang mendakwa dari mahkamah",
      "Sahkan status saman anda dengan merujuk terus ke Kaunter Pendaftaran Mahkamah rasmi",
      "Gunakan portal e-Filing rasmi kerajaan Malaysia (efiling.kehakiman.gov.my) untuk semakan"
    ],
    replyOptions: [
      ReplyOption(text: "Klik pautan tersebut untuk mengisi maklumat bank bagi menafikan tuntutan.", safety: "bahaya"),
      ReplyOption(text: "Balas e-mel untuk menerangkan bahawa ini adalah kesilapan identiti.", safety: "berisiko"),
      ReplyOption(text: "Padam e-mel ini dan tidak membalas sebarang maklumat peribadi.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 8,
    isActive: true,
    type: 'phone',
    category: 'Penyamaran Pihak Berkuasa & Agensi Kerajaan',
    difficulty: 'Sukar',
    threatLevel: 'TINGGI',
    technique: 'Macau Scam (Panggilan Palsu PDRM / SPRM)',
    sender: 'Sarjan Rosli (Ibu Pejabat Polis Bukit Aman)',
    timestamp: 'Sedang Berlangsung',
    message: "PANGGILAN KECEMASAN: Anda dikesan terlibat dalam sindiket haram pengubahan wang haram bernilai RM1.2 Juta. Waran tangkap mahkamah telah dikeluarkan atas nama anda. Untuk mengelakkan tangkapan serta-merta, anda wajib memindahkan semua dana anda ke Akaun Transit Selamat Negara (CIMB Bank: 7062491024) semasa siasatan rahsia ini berjalan.",
    isScam: true,
    explanation: "Pihak polis tidak pernah meminta mangsa melakukan pindahan wang ke mana-mana akaun pihak ketiga (keldai akaun) bagi tujuan 'auditing' atau membersihkan rekod jenayah.",
    recommendedActions: [
      "Letakkan panggilan telefon dengan serta-merta tanpa ragu-ragu",
      "Jangan sesekali mendedahkan maklumat kewangan atau perbankan anda kepada pemanggil",
      "Hubungi talian NSRC 997 untuk melaporkan cubaan Macau Scam ini"
    ],
    replyOptions: [
      ReplyOption(text: "Saya pindahkan semua wang simpanan saya ke akaun transit tersebut sekarang.", safety: "bahaya"),
      ReplyOption(text: "Saya minta pegawai tersebut memberikan nombor rujukan kes dan nama ketuanya.", safety: "berisiko"),
      ReplyOption(text: "Saya letakkan telefon sekarang juga dan laporkan kes ini ke talian NSRC 997.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 9,
    isActive: true,
    type: 'whatsapp',
    category: 'Cabutan Bertuah & Hadiah Palsu',
    difficulty: 'Sederhana',
    threatLevel: 'SEDERHANA',
    technique: 'Social Engineering, Umpan Ganjaran Wang',
    sender: 'Urusetia Hadiah Petronas',
    timestamp: '11:15 AM',
    message: "TAHNIAH! Nombor telefon anda terpilih memenangi wang tunai bernilai RM8,000 sempena Hari Kebangsaan Petronas. Sila kemukakan nama penuh, nombor kad pengenalan, serta nombor kad bank anda untuk kemasukan wang kemenangan serta-merta.",
    isScam: true,
    explanation: "Syarikat besar seperti Petronas tidak menggunakan nombor WhatsApp individu atau meminta butiran kewangan sensitif untuk menyalurkan hadiah cabutan bertuah.",
    recommendedActions: [
      "Abaikan mesej promosi hadiah ini",
      "Semak berita kemenangan rasmi melalui media sosial Petronas yang disahkan (blue tick)",
      "Jangan sesekali berkongsi butiran kad bank kepada orang asing"
    ],
    replyOptions: [
      ReplyOption(text: "Hantar butiran kad bank dan gambar kad pengenalan demi menuntut hadiah wang tersebut.", safety: "bahaya"),
      ReplyOption(text: "Adakah ini betul? Saya mahu bercakap dengan pengurus Petronas terlebih dahulu.", safety: "berisiko"),
      ReplyOption(text: "Saya tahu ini scam. Abaikan mesej ini dan sekat nombor pengirim serta-merta.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 10,
    isActive: true,
    type: 'sms',
    category: 'Cabutan Bertuah & Hadiah Palsu',
    difficulty: 'Sederhana',
    threatLevel: 'SEDERHANA',
    technique: 'Phishing Link (Tebus Hadiah Shopee)',
    sender: 'WINNER-INFO',
    timestamp: 'Baru Sahaja',
    message: "TAHNIAH! Anda memenangi cabutan bertuah Bonanza Shopee bernilai RM5,000. Untuk menuntut ganjaran tunai anda, sila layari pautan pengesahan ini sebelum luput: https://shopee-bonanza-rewards.click",
    isScam: true,
    explanation: "Platform Shopee hanya akan memaklumkan sebarang ganjaran rasmi melalui sistem aplikasi mereka sendiri, bukan menerusi SMS rawak daripada penghantar tidak dikenali dengan pautan bukan rasmi (.click).",
    recommendedActions: [
      "Jangan klik pautan ganjil di dalam SMS",
      "Sahkan sebarang promosi secara terus di dalam aplikasi Shopee rasmi",
      "Laporkan nombor pengirim tersebut kepada SKMM"
    ],
    replyOptions: [
      ReplyOption(text: "Klik pautan ganjil tersebut untuk mengisi maklumat perbankan.", safety: "bahaya"),
      ReplyOption(text: "Tanya kawan-kawan sama ada mereka mendapat SMS yang serupa.", safety: "berisiko"),
      ReplyOption(text: "Abaikan SMS ini dan padamkannya serta-merta.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 11,
    isActive: true,
    type: 'email',
    category: 'Cabutan Bertuah & Hadiah Palsu',
    difficulty: 'Sederhana',
    threatLevel: 'SEDERHANA',
    technique: 'Phishing (Umpan Loteri Antarabangsa)',
    sender: 'Google Promo Team <rewards@google-sweepstakes-2026.net>',
    timestamp: 'Yesterday',
    message: "CONGRATULATIONS! Your active email has won a cash prize of USD 50,000 in our global internet promotion. To claim your prize, please fill out the claims form and pay a processing fee of RM250 via bank transfer to our Malaysian local agent.",
    isScam: true,
    explanation: "Penganjur cabutan bertuah atau loteri yang sah tidak akan sesekali meminta pemenang membuat sebarang bayaran yuran pemprosesan, denda, atau deposit terlebih dahulu sebelum boleh menerima hadiah.",
    recommendedActions: [
      "Padamkan e-mel ini dengan segera kerana ia adalah taktik penipuan bayaran pendahuluan",
      "Jangan sekali-kali menghantar wang ke akaun individu asing atas nama ejen rasmi",
      "Abaikan segala ancaman kehilangan hadiah jika tidak membuat bayaran dalam tempoh singkat"
    ],
    replyOptions: [
      ReplyOption(text: "Buat pemindahan RM250 ke akaun ejen tersebut demi mendapatkan hadiah lumayan.", safety: "bahaya"),
      ReplyOption(text: "Balas e-mel untuk meminta mereka memotong yuran RM250 dari jumlah hadiah utama.", safety: "berisiko"),
      ReplyOption(text: "Abaikan dan padam e-mel ini kerana ia merupakan penipuan loteri.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 12,
    isActive: true,
    type: 'phone',
    category: 'Cabutan Bertuah & Hadiah Palsu',
    difficulty: 'Sederhana',
    threatLevel: 'SEDERHANA',
    technique: 'Vishing (Social Engineering, Umpan Wang)',
    sender: 'Pegawai Program Astro',
    timestamp: 'Sedang Berlangsung',
    message: "PANGGILAN MASUK: Helo Encik! Kami dari Astro ingin mengucapkan tahniah kerana bil bulanan anda terpilih untuk menerima rebat wang tunai RM3,000. Saya baru sahaja hantar kod pengesahan TAC ke telefon anda, sila bacakan kod 6-digit tersebut sekarang untuk kemasukan wang segera.",
    isScam: true,
    explanation: "Pihak Astro tidak akan meminta kod TAC/OTP perbankan anda untuk sebarang pembayaran rebat. Scammer menggunakan kod TAC tersebut untuk mendaftarkan akaun bank anda di peranti mereka.",
    recommendedActions: [
      "Jangan sekali-kali berkongsi atau membacakan kod TAC/OTP kepada sesiapa sahaja",
      "Segera letakkan panggilan telefon tanpa melayan pemanggil",
      "Letakkan panggilan telefon dan hubungi talian khidmat pelanggan Astro rasmi jika musykil"
    ],
    replyOptions: [
      ReplyOption(text: "Sebutkan 6-digit kod TAC yang diterima di SMS kepada pegawai tersebut.", safety: "bahaya"),
      ReplyOption(text: "Tanya kenapa mereka memerlukan kod TAC jika mereka mahu memberi wang.", safety: "berisiko"),
      ReplyOption(text: "Jangan berikan kod TAC, letakkan telefon, dan terus sekat nombor tersebut.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 13,
    isActive: true,
    type: 'whatsapp',
    category: 'Phishing & Smishing',
    difficulty: 'Sukar',
    threatLevel: 'TINGGI',
    technique: 'Phishing (Pencerobohan Akaun Rakan)',
    sender: '019-2458 1192 (Akaun Kenalan Digodam)',
    timestamp: '2:15 PM',
    message: "Eh, kau ada dalam gambar video viral ni ke? Terkejut aku tengok tadi! Cuba kau tengok dekat pautan video-viral-melayu.com ni sekarang sebelum kena padam oleh admin!",
    isScam: true,
    explanation: "Penggodam kerap menceroboh akaun WhatsApp seseorang untuk menghantar pautan palsu kepada kenalan mereka bagi memperdaya pengguna supaya memasukkan kata laluan atau memasang perisian hasad.",
    recommendedActions: [
      "Jangan tekan pautan tidak dikenali walaupun dihantar oleh rakan atau keluarga",
      "Hubungi rakan anda menerusi talian telefon biasa (suara) untuk mengesahkan jika dia yang menghantar mesej tersebut",
      "Amaran kepada rakan anda bahawa akaun WhatsApp beliau berkemungkinan besar telah digodam"
    ],
    replyOptions: [
      ReplyOption(text: "Tekan pautan video viral itu dengan rasa ingin tahu dan masukkan maklumat log masuk jika diminta.", safety: "bahaya"),
      ReplyOption(text: "Balas mesej bertanya video apa tu dan adakah ia benar-benar saya.", safety: "berisiko"),
      ReplyOption(text: "Saya abaikan pautan itu dan hubungi rakan tersebut secara terus menerusi panggilan suara biasa.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 14,
    isActive: true,
    type: 'sms',
    category: 'Phishing & Smishing',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Smishing (Umpan Caj Penghantaran Parcel)',
    sender: 'POS-INFO',
    timestamp: 'Baru Sahaja',
    message: "RM0.00 Pos Laju: Penghantaran bungkusan anda (PL940182) ditangguhkan kerana maklumat alamat tidak lengkap. Sila kemaskini alamat penghantaran dan jelaskan baki caj tambahan RM1.50 di: https://pos-laju-redelivery.info",
    isScam: true,
    explanation: "Pos Laju tidak pernah menghantar SMS meminta bayaran tambahan kecil menerusi pautan laman web luar. Ini merupakan taktik mencuri data kad debit/kredit perbankan anda.",
    recommendedActions: [
      "Abaikan SMS ini dan padamkannya",
      "Gunakan kod penjejakan (tracking number) di aplikasi atau laman web rasmi Pos Malaysia untuk semakan",
      "Jangan sekali-kali memasukkan butiran kad perbankan menerusi pautan tidak rasmi"
    ],
    replyOptions: [
      ReplyOption(text: "Buka pautan tersebut, kemaskini alamat, and bayar caj RM1.50 guna kad perbankan saya.", safety: "bahaya"),
      ReplyOption(text: "Adakah bungkusan ini betul? Saya balas SMS untuk minta alamat pejabat pos mereka.", safety: "berisiko"),
      ReplyOption(text: "Abaikan SMS tersebut dan periksa terus no tracking di laman rasmi Pos Malaysia.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 15,
    isActive: true,
    type: 'email',
    category: 'Phishing & Smishing',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Phishing (Palsu Langganan Akaun)',
    sender: 'Sokongan Netflix <billing@netflix-update-my.com>',
    timestamp: '10:00 AM',
    message: "KEMASKINI SEGERA: Langganan bulanan Netflix anda telah digantung kerana kegagalan transaksi kad bank. Sila kemaskini maklumat kad debit/kredit anda menerusi pautan di bawah dalam tempoh 48 jam sebelum akaun anda ditutup sepenuhnya: https://netflix-billing-renew.com",
    isScam: true,
    explanation: "Pengirim menggunakan alamat e-mel tidak rasmi (netflix-update-my.com). Pihak Netflix yang sah tidak pernah menghantar e-mel dengan pautan luaran untuk menuntut maklumat kad kredit penuh.",
    recommendedActions: [
      "Tandakan e-mel sebagai spam and padamkannya",
      "Buka aplikasi Netflix secara terus atau layari laman web rasmi Netflix sendiri untuk menyemak pengebilan",
      "Jangan klik pautan di dalam e-mel pengebilan yang mencurigakan"
    ],
    replyOptions: [
      ReplyOption(text: "Klik pautan tersebut and segera masukkan butiran kad bank baharu saya.", safety: "bahaya"),
      ReplyOption(text: "Balas e-mel untuk menanyakan mengapa caj bulanan saya gagal diselesaikan.", safety: "berisiko"),
      ReplyOption(text: "Saya abaikan e-mel palsu ini and periksa pengebilan saya terus di aplikasi Netflix.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 16,
    isActive: true,
    type: 'phone',
    category: 'Phishing & Smishing',
    difficulty: 'Sederhana',
    threatLevel: 'SEDERHANA',
    technique: 'Vishing (Social Engineering, Umpan Penghantaran)',
    sender: 'Penghantar Kurier J&T',
    timestamp: 'Sedang Berlangsung',
    message: "PANGGILAN MASUK: Helo encik, saya dari J&T. Ada barang atas nama encik tapi alamatnya kabur. Saya baru sahaja hantar SMS yang ada pautan, encik klik pautan itu sekarang dan muat turun aplikasi pengesan untuk kemaskini alamat ya.",
    isScam: true,
    explanation: "Penghantar barangan (kurier) tidak akan mengarahkan pelanggan memuat turun aplikasi (.apk atau aplikasi luar) menerusi panggilan telefon atau SMS untuk menyelesaikan masalah alamat.",
    recommendedActions: [
      "Jangan menekan sebarang pautan SMS yang diarahkan oleh penghantar barang di telefon",
      "Jangan sesekali memasang fail aplikasi luar (.apk) yang tidak berasal dari Google Play Store",
      "Letakkan panggilan telefon dan rujuk nombor tracking barang anda secara berasingan"
    ],
    replyOptions: [
      ReplyOption(text: "Tekan pautan SMS tersebut dan pasang aplikasi tersebut seperti yang diarahkan.", safety: "bahaya"),
      ReplyOption(text: "Tanya pemanggil jenis barang yang dihantar dan nama pengirimnya.", safety: "berisiko"),
      ReplyOption(text: "Letakkan panggilan telefon, abaikan SMS tersebut, and periksa terus di laman web rasmi J&T.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 17,
    isActive: true,
    type: 'whatsapp',
    category: 'Penipuan Penyamar Keluarga',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Social Engineering, Penyamaran Identiti Anak',
    sender: '011-3921 4482',
    timestamp: '10:24 AM',
    message: "Mak, adik ni. Sumpah telefon adik pecah tadi, ini guna nombor kawan sekejap. Tolong mak, adik ada dekat balai polis sekarang kena denda kes trafik, polis minta bayar RM500 segera atau kena masuk lokap. Tolong transfer ke akaun Maybank kawan adik ni dulu: 1628394050. Tolong sangat mak, jangan bagitahu ayah ya!",
    isScam: true,
    explanation: "Penipu menyamar sebagai anak atau ahli keluarga dalam kecemasan palsu untuk mencetuskan panik. Mereka mendesak pindahan wang segera ke akaun pihak ketiga (keldai akaun) dan melarang anda memberitahu ahli keluarga lain.",
    recommendedActions: [
      "Hubungi terus nombor biasa anak anda untuk pengesahan",
      "Hubungi ahli keluarga lain (cth: ayah) untuk memeriksa status anak",
      "Jangan sesekali memindahkan wang ke akaun individu asing"
    ],
    replyOptions: [
      ReplyOption(text: "Mak hantar sekarang, tolong jangan masuk lokap!", safety: "bahaya"),
      ReplyOption(text: "Adik kat balai mana? Mak hantar peguam ke sana.", safety: "berisiko"),
      ReplyOption(text: "Saya letak telefon dan hubungi nombor asal adik untuk pengesahan.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 18,
    isActive: true,
    type: 'sms',
    category: 'Penipuan Penyamar Keluarga',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Social Engineering (Menyamar Ahli Keluarga)',
    sender: '014-9901 2341',
    timestamp: 'Baru Sahaja',
    message: "Ibu, telefon saya hilang kena ragut tadi. Saya sekarang terkandas dekat stesen bas KL Sentral tak ada wang nak beli tiket pulang. Tolong bank in RM150 ke akaun Maybank pemandu teksi baik hati ini: 1642938102, tolong cepat ibu!",
    isScam: true,
    explanation: "Mesej kecemasan dari nombor tidak dikenali yang mengaku sebagai ahli keluarga dan meminta pindahan wang ke akaun bank pihak ketiga yang tidak dikenali adalah taktik penyamaran keluarga.",
    recommendedActions: [
      "Dapatkan pengesahan dahulu dengan menelefon terus nombor asal ahli keluarga tersebut",
      "Jangan sesekali memindahkan wang ke akaun bank yang tidak dikenali",
      "Hubungi ahli keluarga yang lain untuk memeriksa status mangsa kecemasan"
    ],
    replyOptions: [
      ReplyOption(text: "Terus pindahkan RM150 ke akaun Maybank pemandu teksi tersebut tanpa usul periksa.", safety: "bahaya"),
      ReplyOption(text: "Hantar mesej balasan bertanya adakah dia cedera atau sudah melaporkan kepada polis.", safety: "berisiko"),
      ReplyOption(text: "Abaikan SMS tersebut, dan segera hubungi nombor asal anak saya untuk pengesahan.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 19,
    isActive: true,
    type: 'email',
    category: 'Penipuan Penyamar Keluarga',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Social Engineering, Penyamaran E-mel Saudara',
    sender: 'Zulkifli (Abang Sepupu) <zulkifli-travel@gmail-secure.com>',
    timestamp: 'Yesterday',
    message: "SALAM KELUARGA: Saya sekarang berada di London atas urusan kerja, tetapi malangnya dompet dan beg pasport saya telah hilang dicuri semalam. Saya memerlukan bantuan wang kecemasan RM2,000 untuk bayar hotel dan tiket pulang segera. Tolong transfer ke akaun Maybank pengurus agensi pelancongan tempatan saya: 1560938102.",
    isScam: true,
    explanation: "E-mel ini menggunakan domain tidak rasmi dan memanipulasi emosi bimbang mangsa dengan cerita kecemasan luar negara palsu bagi mengarah pemindahan wang segera ke akaun pihak ketiga (keldai akaun).",
    recommendedActions: [
      "Hubungi ibu bapa atau adik-beradik terdekat abang sepupu tersebut untuk mengesahkan keberadaannya",
      "Jangan sesekali menghantar wang ke akaun individu lain atas nama ejen pelancongan atau pihak ketiga",
      "Hubungi abang sepupu anda di platform media sosial rasmi beliau untuk pengesahan"
    ],
    replyOptions: [
      ReplyOption(text: "Segera lakukan pindahan RM2,000 kerana bimbangkan keselamatan ahli keluarga di luar negara.", safety: "bahaya"),
      ReplyOption(text: "Balas e-mel untuk menyatakan saya mahu menderma sedikit wang sahaja.", safety: "berisiko"),
      ReplyOption(text: "Saya abaikan e-mel ini, dan terus membuat panggilan telefon ke nombor asal abang sepupu saya.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 20,
    isActive: true,
    type: 'phone',
    category: 'Penipuan Penyamar Keluarga',
    difficulty: 'Sukar',
    threatLevel: 'TINGGI',
    technique: 'Vishing (Social Engineering, Suara Menangis)',
    sender: 'Panggilan Cucu Menangis',
    timestamp: 'Sedang Berlangsung',
    message: "PANGGILAN MASUK: (Suara menangis teresak-esak) Tok, tolong adik Tok! Adik kena tangkap dengan polis dekat stesen bas semalam sebab kawan bawa barang terlarang. Polis kata kena bayar ikat jamin RM3,000 sekarang juga atau masuk lokap. Tolong Tok, jangan beritahu mak ayah, adik takut gila!",
    isScam: true,
    explanation: "Scammer menggunakan suara menangis untuk mengaburkan suara sebenar dan menakutkan warga emas supaya memindahkan wang tebusan secara terburu-buru tanpa menghubungi ibu bapa mereka.",
    recommendedActions: [
      "Letakkan panggilan telefon tersebut serta-merta",
      "Hubungi ibu bapa cucu tersebut secara langsung untuk mengesahkan keberadaan cucu anda",
      "Jangan sesekali memindahkan wang tebusan sivil secara panggilan telefon"
    ],
    replyOptions: [
      ReplyOption(text: "Pergi ke ATM sekarang juga and pindahkan wang ikat jamin RM3,000 itu.", safety: "bahaya"),
      ReplyOption(text: "Cuba tanya cucu tersebut nama penuh and di balai polis mana dia berada.", safety: "berisiko"),
      ReplyOption(text: "Letakkan panggilan telefon dengan tenang and segera telefon ibu bapanya untuk semakan.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 21,
    isActive: true,
    type: 'whatsapp',
    category: 'Lain-lain Jenis Modus Operandi',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Job Scam (Tawaran Kerja Sambilan Palsu)',
    sender: 'Agensi Kerjaya Flexi',
    timestamp: '1:30 PM',
    message: "PELUANG WORK FROM HOME: Tugas mudah hanya menonton dan menyukai video YouTube untuk komisen RM150-RM300 sehari! Sila sertai kumpulan Telegram kami untuk bermula.",
    isScam: true,
    explanation: "Ini merupakan modus operandi 'Job Scam'. Mangsa pada mulanya akan dibayar komisen kecil, kemudian diarah mendepositkan wang sendiri yang besar sebagai 'yuran peningkatan tugasan' sebelum wang dilarikan.",
    recommendedActions: [
      "Abaikan sebarang iklan kerja sambilan yang menawarkan komisen luar biasa mudah",
      "Jangan sesekali memindahkan wang deposit bagi tujuan bekerja sambilan",
      "Sekat nombor WhatsApp pengirim tersebut serta-merta"
    ],
    replyOptions: [
      ReplyOption(text: "Tekan pautan Telegram tersebut dan sedia mendepositkan wang untuk tugasan komisen tinggi.", safety: "bahaya"),
      ReplyOption(text: "Tanya adakah kerja ini sah dan jika saya boleh buat kerja tanpa membayar sebarang yuran.", safety: "berisiko"),
      ReplyOption(text: "Abaikan tawaran ini dan sekat nombor pengirim tersebut demi keselamatan kewangan saya.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 22,
    isActive: true,
    type: 'sms',
    category: 'Lain-lain Jenis Modus Operandi',
    difficulty: 'Sederhana',
    threatLevel: 'TINGGI',
    technique: 'Loan Scam (Tawaran Pinjaman Wang Tidak Sah)',
    sender: 'PINJAMAN-EKSPRES',
    timestamp: 'Baru Sahaja',
    message: "PINJAMAN PERIBADI LULUS SEGERA! Kadar bunga serendah 1.5% tanpa dokumen rumit dan tiada bayaran muka. Sila mohon di pautan kami sekarang untuk kelulusan dalam tempoh 1 jam: https://pinjaman-ekspres-lulus.com",
    isScam: true,
    explanation: "Syarikat pinjaman wang berlesen yang sah dilarang mempromosikan perkhidmatan menerusi SMS rawak. Penipu akan meminta 'yuran guaman' atau 'deposit insurans' pendahuluan sebelum menghilangkan diri.",
    recommendedActions: [
      "Abaikan SMS tawaran pinjaman segera yang mencurigakan ini",
      "Jangan sesekali menghantar wang pendahuluan kepada syarikat pinjaman peribadi",
      "Rujuk institusi perbankan berlesen yang sah jika memerlukan bantuan pembiayaan kewangan"
    ],
    replyOptions: [
      ReplyOption(text: "Mohon pinjaman melalui pautan tersebut dan bayar yuran pendahuluan yang diminta.", safety: "bahaya"),
      ReplyOption(text: "Balas SMS ini untuk bertanyakan sama ada saya boleh meminjam RM10,000 dahulu.", safety: "berisiko"),
      ReplyOption(text: "Abaikan iklan ini dan padam SMS ini bagi mengelakkan diri daripada terpedaya.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 23,
    isActive: true,
    type: 'email',
    category: 'Lain-lain Jenis Modus Operandi',
    difficulty: 'Sukar',
    threatLevel: 'TINGGI',
    technique: 'Investment Scam (Skim Cepat Kaya / Kripto Palsu)',
    sender: 'Pelaburan Shariah Global <info@shariah-crypto-investment.org>',
    timestamp: '4:00 PM',
    message: "PELUANG EMAS: Jana keuntungan pasif 300% dalam masa 48 jam sahaja! Skim pelaburan kripto patuh syariah yang diluluskan antarabangsa. Deposit serendah RM300 dan dapatkan pulangan RM900 dijamin selamat tanpa sebarang risiko kerugian: https://shariah-crypto-investment.org",
    isScam: true,
    explanation: "Sebarang skim pelaburan yang menjanjikan keuntungan luar biasa tinggi (Skim Cepat Kaya) dalam tempoh singkat tanpa risiko kerugian adalah 100% penipuan kewangan.",
    recommendedActions: [
      "Padamkan e-mel ini serta-merta",
      "Rujuk portal Alert List Bank Negara Malaysia (BNM) untuk memeriksa syarikat pelaburan tidak berlesen",
      "Jangan terpedaya dengan istilah 'Patuh Syariah' or 'Dijamin Selamat' yang digunakan sebarangan"
    ],
    replyOptions: [
      ReplyOption(text: "Daftar akaun di pautan tersebut dan labur RM300 untuk mencuba nasib.", safety: "bahaya"),
      ReplyOption(text: "Balas e-mel untuk bertanyakan sijil kelulusan daripada Bank Negara Malaysia.", safety: "berisiko"),
      ReplyOption(text: "Abaikan e-mel palsu ini dan padamkannya terus.", safety: "selamat")
    ],
  ),
  Scenario(
    id: 24,
    isActive: true,
    type: 'phone',
    category: 'Lain-lain Jenis Modus Operandi',
    difficulty: 'Sederhana',
    threatLevel: 'SEDERHANA',
    technique: 'E-Commerce / Buyer Scam',
    sender: 'Pembeli Mudah.my',
    timestamp: 'Sedang Berlangsung',
    message: "PANGGILAN MASUK: Helo encik, saya sangat berminat nak beli barang yang encik iklankan di Mudah.my. Saya dah bayar guna akaun PayPal antarabangsa, tapi PayPal hantar e-mel kata wang ditangguhkan. Encik kena bayar 'yuran pengaktifan' sebanyak RM200 ke akaun ejen tempatan untuk lepaskan bayaran tersebut.",
    isScam: true,
    explanation: "Penipu menyamar sebagai pembeli, mendakwa telah memindahkan bayaran elektronik, and menghantar mesej/panggilan palsu yang mengarahkan penjual membayar 'yuran pengaktifan/pelepasan' terlebih dahulu untuk memperoleh wang tersebut.",
    recommendedActions: [
      "Jangan sesekali membayar sebarang yuran untuk membolehkan anda menerima wang jualan barangan anda",
      "Hanya terima pembayaran secara bersemuka (COD) atau pindahan bank langsung ke akaun bank anda sendiri",
      "Letakkan panggilan telefon serta-merta apabila diarahkan membuat pembayaran pendahuluan"
    ],
    replyOptions: [
      ReplyOption(text: "Bayar yuran pelepasan RM200 tersebut ke akaun ejen agar bayaran barangan saya dilepaskan.", safety: "bahaya"),
      ReplyOption(text: "Minta pembeli tersebut menanggung sendiri yuran pelepasan akaun dan menolaknya dari harga barang.", safety: "berisiko"),
      ReplyOption(text: "Letakkan panggilan telefon, abaikan tawaran pembeli tersebut, and sekat nombornya.", safety: "selamat")
    ],
  ),
];

