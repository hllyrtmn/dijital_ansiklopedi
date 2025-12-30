import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';

class StorageService {
  static const String _entriesKey = 'entries';

  Future<List<Entry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString(_entriesKey);

    if (entriesJson == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(entriesJson);
    return decoded.map((json) => Entry.fromJson(json)).toList();
  }

  Future<bool> saveEntries(List<Entry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> entriesJson =
        entries.map((entry) => entry.toJson()).toList();
    return await prefs.setString(_entriesKey, jsonEncode(entriesJson));
  }

  Future<bool> addEntry(Entry entry) async {
    final entries = await getEntries();
    entries.insert(0, entry);
    return await saveEntries(entries);
  }

  Future<bool> deleteEntry(String id) async {
    final entries = await getEntries();
    entries.removeWhere((entry) => entry.id == id);
    return await saveEntries(entries);
  }

  Future<List<Entry>> searchEntries(String query) async {
    final entries = await getEntries();
    if (query.isEmpty) {
      return entries;
    }

    final lowerQuery = query.toLowerCase();
    return entries.where((entry) {
      return entry.title.toLowerCase().contains(lowerQuery) ||
          entry.keywords.toLowerCase().contains(lowerQuery) ||
          entry.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // lib/services/storage_service.dart dosyasına eklenecek

  Future<void> initializeMockData() async {
    final entries = await getEntries();
    if (entries.isNotEmpty) return; // Zaten veri varsa ekleme

    final mockEntries = [
      Entry(
        id: '1',
        title: 'Yapay Zeka',
        keywords: 'AI, makine öğrenmesi, derin öğrenme, otomasyon',
        description:
            'Yapay zeka (AI), makinelerin insan zekasını taklit etmesini sağlayan teknolojilerin genel adıdır. Makine öğrenmesi, doğal dil işleme ve bilgisayarlı görü gibi alt dalları vardır. Günümüzde sağlık, finans, otomotiv ve birçok sektörde kullanılmaktadır.',
        sources: 'https://tr.wikipedia.org/wiki/Yapay_zeka',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      Entry(
        id: '2',
        title: 'Blockchain Teknolojisi',
        keywords: 'blockchain, kripto, bitcoin, dağıtık defter',
        description:
            'Blockchain, verilerin güvenli bir şekilde saklandığı dağıtık veritabanı teknolojisidir. Her blok, önceki bloğun hash değerini içerir ve bu sayede değiştirilemez bir zincir oluşur. Kripto paralar, akıllı sözleşmeler ve tedarik zinciri yönetiminde kullanılır.',
        sources: 'Bitcoin Whitepaper, Ethereum Documentation',
        createdAt: DateTime.now().subtract(Duration(days: 29)),
      ),
      Entry(
        id: '3',
        title: 'Kuantum Bilgisayarlar',
        keywords: 'kuantum, qubit, süperpozisyon, dolanıklık',
        description:
            'Kuantum bilgisayarlar, klasik bilgisayarlardan farklı olarak kuantum mekaniği prensiplerine dayalı çalışır. Qubit adı verilen birimleri kullanarak süperpozisyon ve dolanıklık sayesinde bazı hesaplamaları üstel hızda yapabilir.',
        sources: 'IBM Quantum Computing, Nature Journal',
        createdAt: DateTime.now().subtract(Duration(days: 28)),
      ),
      Entry(
        id: '4',
        title: 'Fotosentez',
        keywords: 'bitki, klorofil, güneş ışığı, oksijen, glikoz',
        description:
            'Fotosentez, bitkilerin güneş ışığını kullanarak su ve karbondioksidden glikoz ve oksijen ürettiği biyokimyasal süreçtir. Kloroplastlarda gerçekleşen bu olay, dünya üzerindeki yaşamın temel enerji kaynağıdır.',
        sources: 'Biyoloji Kitapları, Bilimsel Makaleler',
        createdAt: DateTime.now().subtract(Duration(days: 27)),
      ),
      Entry(
        id: '5',
        title: 'Rönesans Dönemi',
        keywords: 'sanat, Avrupa, Leonardo da Vinci, hümanizm',
        description:
            'Rönesans, 14-17. yüzyıllar arası Avrupa\'da yaşanan kültürel, sanatsal ve bilimsel yeniden doğuş hareketidir. Klasik antik çağ eserlerine dönüş, insan merkezli düşünce ve bilimsel gelişmelerin arttığı bir dönemdir.',
        sources: 'Tarih Kitapları, Sanat Tarihi Kaynakları',
        createdAt: DateTime.now().subtract(Duration(days: 26)),
      ),
      Entry(
        id: '6',
        title: 'DNA Yapısı',
        keywords: 'genetik, çift sarmal, nükleotid, Watson, Crick',
        description:
            'DNA (Deoksiribonükleik asit), canlılardaki genetik bilgiyi taşıyan moleküldür. Watson ve Crick tarafından keşfedilen çift sarmal yapısı, adenin-timin ve guanin-sitozin baz çiftlerinden oluşur.',
        sources: 'Nature 1953, Moleküler Biyoloji Kitapları',
        createdAt: DateTime.now().subtract(Duration(days: 25)),
      ),
      Entry(
        id: '7',
        title: 'İklim Değişikliği',
        keywords: 'sera gazı, küresel ısınma, CO2, iklim',
        description:
            'İklim değişikliği, insan faaliyetleri sonucu atmosferdeki sera gazı konsantrasyonunun artması ile oluşan küresel sıcaklık artışı ve bunun sonuçlarıdır. Deniz seviyesi yükselmesi, ekstrem hava olayları ve ekosistem değişiklikleri gibi etkileri vardır.',
        sources: 'IPCC Raporları, Bilimsel Çalışmalar',
        createdAt: DateTime.now().subtract(Duration(days: 24)),
      ),
      Entry(
        id: '8',
        title: 'Osmanlı İmparatorluğu',
        keywords: 'tarih, Türk, imparatorluk, İstanbul, padişah',
        description:
            'Osmanlı İmparatorluğu, 1299-1922 yılları arasında üç kıtada hüküm sürmüş Türk-İslam devletidir. 1453\'te İstanbul\'un fethi ile doruk noktasına ulaşmış, 623 yıl boyunca varlığını sürdürmüştür.',
        sources: 'Osmanlı Tarihi Kitapları, Arşiv Belgeleri',
        createdAt: DateTime.now().subtract(Duration(days: 23)),
      ),
      Entry(
        id: '9',
        title: 'Elektrik ve Manyetizma',
        keywords: 'fizik, elektrik, manyetik alan, Maxwell',
        description:
            'Elektrik ve manyetizma, birbirleriyle ilişkili iki temel fiziksel olgudur. James Clerk Maxwell, bu iki olguyu birleştiren denklemleri formüle etmiş ve elektromanyetik dalgaların varlığını öngörmüştür.',
        sources: 'Fizik Ders Kitapları, Maxwell Denklemleri',
        createdAt: DateTime.now().subtract(Duration(days: 22)),
      ),
      Entry(
        id: '10',
        title: 'Piramitler',
        keywords: 'Mısır, antik, mimari, firavun, Giza',
        description:
            'Mısır piramitleri, antik Mısır firavunları için mezar olarak inşa edilmiş anıtsal yapılardır. Giza\'daki Büyük Piramit, dünyanın yedi harikasından günümüze ulaşan tek yapıdır ve yaklaşık 2560 yılında inşa edilmiştir.',
        sources: 'Arkeoloji Kitapları, National Geographic',
        createdAt: DateTime.now().subtract(Duration(days: 21)),
      ),
      Entry(
        id: '11',
        title: 'Nöron ve Sinir Sistemi',
        keywords: 'beyin, sinir, nöron, sinaps, elektrik sinyali',
        description:
            'Nöronlar, sinir sisteminin temel yapı taşlarıdır. Elektrik ve kimyasal sinyaller aracılığıyla bilgi iletimini sağlar. İnsan beyninde yaklaşık 86 milyar nöron bulunur ve bunlar sinapslar aracılığıyla birbirleriyle bağlantı kurar.',
        sources: 'Nörobilim Kitapları, Tıp Literatürü',
        createdAt: DateTime.now().subtract(Duration(days: 20)),
      ),
      Entry(
        id: '12',
        title: 'Rölativite Teorisi',
        keywords: 'Einstein, fizik, uzay-zaman, E=mc², özel rölativite',
        description:
            'Albert Einstein\'ın 1905\'te öne sürdüğü özel rölativite teorisi, ışık hızının sabit olduğunu ve zaman ile mekanın göreceli olduğunu açıklar. E=mc² denklemi ile kütle-enerji eşdeğerliğini ortaya koymuştur.',
        sources: 'Einstein\'ın Makaleleri, Modern Fizik Kitapları',
        createdAt: DateTime.now().subtract(Duration(days: 19)),
      ),
      Entry(
        id: '13',
        title: 'Barok Müzik',
        keywords: 'klasik müzik, Bach, Vivaldi, beste, dönem',
        description:
            'Barok müzik, 1600-1750 yılları arasındaki müzik dönemidir. Johann Sebastian Bach, Antonio Vivaldi ve George Frideric Handel bu dönemin önemli bestecileridir. Karmaşık polifoni ve süslü melodiler ile karakterizedir.',
        sources: 'Müzik Tarihi Kitapları, Konservatuar Kaynakları',
        createdAt: DateTime.now().subtract(Duration(days: 18)),
      ),
      Entry(
        id: '14',
        title: 'Evrim Teorisi',
        keywords: 'Darwin, doğal seçilim, tür, adaptasyon, biyoloji',
        description:
            'Charles Darwin\'in ortaya koyduğu evrim teorisi, canlıların zaman içinde doğal seçilim yoluyla değiştiğini ve yeni türlerin oluştuğunu açıklar. "Türlerin Kökeni" kitabı 1859\'da yayınlanmıştır.',
        sources: 'Türlerin Kökeni, Evrimsel Biyoloji Kitapları',
        createdAt: DateTime.now().subtract(Duration(days: 17)),
      ),
      Entry(
        id: '15',
        title: 'Sanayi Devrimi',
        keywords: 'tarih, endüstri, fabrika, buhar makinesi, İngiltere',
        description:
            'Sanayi Devrimi, 18. yüzyılda İngiltere\'de başlayan ve üretim yöntemlerini kökten değiştiren toplumsal ve ekonomik dönüşümdür. Buhar makinesinin icadı ile fabrika sistemine geçiş gerçekleşmiştir.',
        sources: 'Ekonomi Tarihi Kitapları, Tarih Kaynakları',
        createdAt: DateTime.now().subtract(Duration(days: 16)),
      ),
      Entry(
        id: '16',
        title: 'Kara Delik',
        keywords: 'astronomi, uzay, çekim, olay ufku, Einstein',
        description:
            'Kara delikler, çekim alanı o kadar güçlü olan kozmik cisimlerdir ki ışık bile bu alandan kaçamaz. Büyük kütleli yıldızların çökmesi sonucu oluşur. İlk kara delik görüntüsü 2019 yılında elde edilmiştir.',
        sources: 'NASA, Astrofizik Makaleleri',
        createdAt: DateTime.now().subtract(Duration(days: 15)),
      ),
      Entry(
        id: '17',
        title: 'Antibiyotikler',
        keywords: 'tıp, ilaç, bakteri, Fleming, penisilin',
        description:
            'Antibiyotikler, bakteriyel enfeksiyonları tedavi etmek için kullanılan ilaçlardır. Alexander Fleming 1928\'de penisilin\'i keşfetmiş ve bu keşif modern tıbbın en önemli dönüm noktalarından biri olmuştur.',
        sources: 'Tıp Tarihi, Farmakoloji Kitapları',
        createdAt: DateTime.now().subtract(Duration(days: 14)),
      ),
      Entry(
        id: '18',
        title: 'Shakespeare',
        keywords: 'edebiyat, İngiliz, yazar, tiyatro, oyun',
        description:
            'William Shakespeare (1564-1616), İngiliz edebiyatının en büyük yazarlarından biridir. Hamlet, Romeo ve Juliet, Macbeth gibi ölümsüz eserlerin yazarıdır. 37 oyun ve 154 sone yazmıştır.',
        sources: 'Edebiyat Tarihi, Shakespeare Eserleri',
        createdAt: DateTime.now().subtract(Duration(days: 13)),
      ),
      Entry(
        id: '19',
        title: 'Mitokondri',
        keywords: 'hücre, enerji, ATP, organel, biyoloji',
        description:
            'Mitokondri, hücrelerin enerji santralidir. Besin maddelerini ATP\'ye (adenozin trifosfat) dönüştürerek hücreye enerji sağlar. Kendi DNA\'sına sahiptir ve anne tarafından kalıtsaldır.',
        sources: 'Hücre Biyolojisi Kitapları, Bilimsel Makaleler',
        createdAt: DateTime.now().subtract(Duration(days: 12)),
      ),
      Entry(
        id: '20',
        title: 'Van Gogh',
        keywords: 'sanat, ressam, empresyonizm, yıldızlı gece',
        description:
            'Vincent van Gogh (1853-1890), Hollandalı post-empresyonist ressam. Yaşamı boyunca sadece bir tablo satabilmiş, ancak ölümünden sonra dünya çapında tanınmıştır. Yıldızlı Gece, Ayçiçekleri gibi ünlü eserleri vardır.',
        sources: 'Sanat Tarihi, Van Gogh Müzesi',
        createdAt: DateTime.now().subtract(Duration(days: 11)),
      ),
      Entry(
        id: '21',
        title: 'Python Programlama',
        keywords: 'yazılım, kodlama, programlama dili, AI, veri bilimi',
        description:
            'Python, Guido van Rossum tarafından 1991\'de geliştirilen yüksek seviyeli programlama dilidir. Kolay sözdizimi, geniş kütüphane desteği ile veri bilimi, yapay zeka ve web geliştirmede yaygın kullanılır.',
        sources: 'Python.org, Programlama Kitapları',
        createdAt: DateTime.now().subtract(Duration(days: 10)),
      ),
      Entry(
        id: '22',
        title: 'Barok Mimari',
        keywords: 'mimarlık, sanat, Avrupa, süsleme, görkemli',
        description:
            'Barok mimari, 17. yüzyılda Avrupa\'da ortaya çıkan, görkemli ve süslü tarzıyla bilinen mimari akımdır. Karmaşık detaylar, bol süsleme ve dramatik etkiler kullanılır. Versailles Sarayı en bilinen örneklerdendir.',
        sources: 'Mimarlık Tarihi, Sanat Kitapları',
        createdAt: DateTime.now().subtract(Duration(days: 9)),
      ),
      Entry(
        id: '23',
        title: 'Nobel Ödülleri',
        keywords: 'bilim, ödül, Alfred Nobel, barış, edebiyat',
        description:
            'Nobel Ödülleri, Alfred Nobel\'in vasiyeti üzerine 1901\'den beri verilen prestijli ödüllerdir. Fizik, Kimya, Tıp, Edebiyat, Barış ve Ekonomi dallarında verilir. Her yıl Aralık ayında Stockholm\'de törenle takdim edilir.',
        sources: 'NobelPrize.org, Bilim Tarihi',
        createdAt: DateTime.now().subtract(Duration(days: 8)),
      ),
      Entry(
        id: '24',
        title: 'Magna Carta',
        keywords: 'hukuk, İngiltere, anayasa, özgürlük, 1215',
        description:
            'Magna Carta (Büyük Şart), 1215\'te İngiltere\'de Kral John tarafından imzalanan ve kralın yetkilerini sınırlayan tarihsel belgedir. Modern anayasacılık ve insan hakları hareketlerinin temelini oluşturmuştur.',
        sources: 'Hukuk Tarihi, Anayasa Kitapları',
        createdAt: DateTime.now().subtract(Duration(days: 7)),
      ),
      Entry(
        id: '25',
        title: 'Güneş Sistemi',
        keywords: 'astronomi, gezegen, Güneş, Merkür, Jüpiter',
        description:
            'Güneş Sistemi, Güneş ve onun çekim alanındaki sekiz gezegen, cüce gezegenler, uydu ve diğer gök cisimlerinden oluşur. Yaklaşık 4.6 milyar yıl önce bir nebuladan oluşmuştur.',
        sources: 'NASA, Astronomi Kitapları',
        createdAt: DateTime.now().subtract(Duration(days: 6)),
      ),
      Entry(
        id: '26',
        title: 'Beethoven',
        keywords: 'klasik müzik, besteci, senfoni, Alman, sağır',
        description:
            'Ludwig van Beethoven (1770-1827), Klasik dönemden Romantik döneme geçişte önemli rol oynamış Alman bestecisidir. 9 senfoni, 32 piyano sonatı bestelemiştir. Kariyerinin son döneminde tamamen sağırlaşmıştır.',
        sources: 'Müzik Tarihi, Beethoven Biyografileri',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      Entry(
        id: '27',
        title: 'Atom Teorisi',
        keywords: 'fizik, kimya, proton, nötron, elektron',
        description:
            'Modern atom teorisi, atomun çekirdek (proton ve nötron) ve etrafında dolanan elektronlardan oluştuğunu açıklar. Niels Bohr, Schrödinger ve Heisenberg gibi bilim insanları atom modelinin gelişimine katkıda bulunmuştur.',
        sources: 'Kimya Kitapları, Fizik Makaleleri',
        createdAt: DateTime.now().subtract(Duration(days: 4)),
      ),
      Entry(
        id: '28',
        title: 'Çin Seddi',
        keywords: 'Çin, mimari, tarih, savunma, antik',
        description:
            'Çin Seddi, Çin\'in kuzey sınırlarını korumak için inşa edilen devasa savunma yapısıdır. MÖ 7. yüzyıldan başlayarak yüzyıllar boyunca inşa edilmiş, toplamda 21,000 km uzunluğundadır. Uzaydan görülen tek yapı efsanesi doğru değildir.',
        sources: 'Tarih Kitapları, Arkeoloji Kaynakları',
        createdAt: DateTime.now().subtract(Duration(days: 3)),
      ),
      Entry(
        id: '29',
        title: 'İnternet Protokolü',
        keywords: 'teknoloji, TCP/IP, network, bilgisayar, internet',
        description:
            'İnternet Protokolü (IP), bilgisayar ağlarında veri paketlerinin yönlendirilmesini sağlayan temel protokoldür. TCP/IP protokol ailesi, modern internetin omurgasını oluşturur. IPv4 ve IPv6 olmak üzere iki ana versiyonu vardır.',
        sources: 'RFC Belgeleri, Network Kitapları',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      Entry(
        id: '30',
        title: 'Antik Yunan Felsefesi',
        keywords: 'felsefe, Sokrates, Platon, Aristoteles, mantık',
        description:
            'Antik Yunan felsefesi, Batı felsefesinin temelini oluşturur. Sokrates, Platon ve Aristoteles\'in öğretileri günümüze kadar etkisini sürdürmüştür. Etik, mantık, metafizik gibi temel felsefi disiplinler bu dönemde şekillenmiştir.',
        sources: 'Felsefe Tarihi, Antik Metinler',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
    ];

    await saveEntries(mockEntries);
  }
}
