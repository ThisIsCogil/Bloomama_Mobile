import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/controllers/kesehatan_controller.dart';
import 'package:login/services/api_service.dart';
import '../../../models/health_model.dart';
import 'tips_trik_tab.dart';

class PregnancyTrackerScreen extends StatefulWidget {
  final ScrollController scrollController;

  const PregnancyTrackerScreen({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<PregnancyTrackerScreen> createState() => _PregnancyTrackerScreenState();
}

class _PregnancyTrackerScreenState extends State<PregnancyTrackerScreen> {
  final KesehatanController _kesehatanController = KesehatanController(apiService: ApiService(),);
  int _selectedWeek = 1;
  HealthData? _currentWeekHealthData;
  bool _isLoadingHealthData = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  final Map<String, bool> _imageExistsCache = {};

final Map<int, Map<String, dynamic>> _weekData = {
  1: {
    'size': '0.1 cm, Biji Opium',
    'title': 'Awal Kehidupan',
    'description': 'Pembuahan baru saja terjadi! Sel telur yang telah dibuahi sedang membelah cepat menuju rahim.',
    'emoji': '🌱',
    'notes': 'Semua normal, lanjutkan makan bergizi.',
  },
  2: {
    'size': '0.2 cm, Biji Wijen',
    'title': 'Mulai Menempel',
    'description': 'Embrio mulai menempel di dinding rahim. Plasenta mulai terbentuk untuk memberi nutrisi.',
    'emoji': '🌰',
  },
  3: {
    'size': '0.4 cm, Biji Chia',
    'title': 'Membentuk Lapisan',
    'description': 'Embrio kini memiliki tiga lapisan utama yang akan menjadi bagian tubuh.',
    'emoji': '🔹',
  },
  4: {
    'size': '0.6 cm, Beras',
    'title': 'Mulai Terbentuk',
    'description': 'Tabung saraf mulai terbentuk menjadi otak dan tulang belakang.',
    'emoji': '🌾',
  },
  5: {
    'size': '1.3 cm, Biji Apel',
    'title': 'Pertumbuhan Cepat',
    'description': 'Jantung mulai berdetak teratur dan organ-organ mulai berkembang.',
    'emoji': '🍎',
  },
  6: {
    'size': '1.7 cm, Kacang Merah',
    'title': 'Ciri Wajah Mulai Terbentuk',
    'description': 'Mata, telinga, dan hidung mulai terlihat.',
    'emoji': '🫘',
  },
  7: {
    'size': '2.5 cm, Blueberry',
    'title': 'Perkembangan Anggota Tubuh',
    'description': 'Tangan dan kaki bertumbuh dengan jari-jari mulai terbentuk.',
    'emoji': '🫐',
  },
  8: {
    'size': '3.0 cm, Raspberry',
    'title': 'Semakin Menyerupai Manusia',
    'description': 'Organ penting mulai terbentuk dan kelopak mata mulai menutupi mata.',
    'emoji': '🍓',
  },
  9: {
    'size': '4.0 cm, Cherry',
    'title': 'Mulai Bergerak',
    'description': 'Bayi mulai bergerak walau belum terasa. Otot mulai berkembang.',
    'emoji': '🍒',
  },
  10: {
    'size': '5.0 cm, Strawberry',
    'title': 'Tulang Mulai Terbentuk',
    'description': 'Kerangka mulai berkembang dari tulang rawan menjadi tulang keras.',
    'emoji': '🍓',
  },
  11: {
    'size': '6.0 cm, Jeruk Nipis',
    'title': 'Ciri Unik Terlihat',
    'description': 'Bentuk wajah semakin jelas dan tunas gigi mulai muncul.',
    'emoji': '🍋',
  },
  12: {
    'size': '7.0 cm, Plum',
    'title': 'Akhir Trimester Pertama',
    'description': 'Jenis kelamin mungkin mulai terlihat dan bayi bisa menghisap jempol.',
    'emoji': '🍑',
  },
  13: {
    'size': '8.0 cm, Lemon',
    'title': 'Sidik Jari Terbentuk',
    'description': 'Sidik jari bayi mulai terbentuk dan bayi mulai buang air kecil.',
    'emoji': '🍋',
  },
  14: {
    'size': '9.0 cm, Buah Persik',
    'title': 'Pertumbuhan Pesat',
    'description': 'Tubuh tumbuh lebih cepat dari kepala dan leher semakin terlihat.',
    'emoji': '🍑',
  },
  15: {
    'size': '10.0 cm, Apel',
    'title': 'Mengenal Cahaya',
    'description': 'Mata bayi mulai sensitif terhadap cahaya dan bisa mendengar suara.',
    'emoji': '🍎',
  },
  16: {
    'size': '11.5 cm, Alpukat',
    'title': 'Perkembangan Indra',
    'description': 'Bayi bisa mendengar suara ibu. Kaki tumbuh lebih panjang dari tangan.',
    'emoji': '🥑',
  },
  17: {
    'size': '13.0 cm, Pir',
    'title': 'Bertambah Kuat',
    'description': 'Bayi mulai membentuk jaringan lemak dan tampak seperti bayi baru lahir.',
    'emoji': '🍐',
  },
  18: {
    'size': '14.2 cm, Paprika',
    'title': 'Peregangan',
    'description': 'Gerakan bayi semakin terkoordinasi. Bisa menguap dan meregang.',
    'emoji': '🫑',
  },
  19: {
    'size': '15.3 cm, Mangga',
    'title': 'Latihan Pernapasan',
    'description': 'Kulit bayi dilindungi lapisan putih (vernix). Paru-paru mulai berkembang.',
    'emoji': '🥭',
  },
  20: {
    'size': '16.5 cm, Pisang',
    'title': 'Setengah Jalan!',
    'description': 'Kehamilan sudah setengah jalan. Bayi mulai punya pola tidur-bangun.',
    'emoji': '🍌',
  },
    21: {
    'size': '18.0 cm, Wortel',
    'title': 'Pengecap Terbentuk',
    'description': 'Indra pengecap bayi mulai terbentuk dan bisa merasakan cairan ketuban.',
    'emoji': '🥕',
  },
  22: {
    'size': '19.0 cm, Jeruk Bali',
    'title': 'Perkembangan Mata',
    'description': 'Mata bayi sudah terbentuk meski iris belum memiliki warna.',
    'emoji': '🍊',
  },
  23: {
    'size': '20.0 cm, Buku',
    'title': 'Bertambah Berat',
    'description': 'Bayi mulai menambah berat badan dengan cepat. Paru-paru terus berkembang.',
    'emoji': '📘',
  },
  24: {
    'size': '21.0 cm, Jagung',
    'title': 'Tahap Viabilitas',
    'description': 'Bayi mulai dianggap dapat bertahan hidup di luar rahim dengan perawatan intensif.',
    'emoji': '🌽',
  },
  25: {
    'size': '22.0 cm, Kembang Kol',
    'title': 'Merespon Suara',
    'description': 'Bayi merespons suara ibu dan suara lainnya dengan gerakan atau peningkatan detak jantung.',
    'emoji': '🥦',
  },
  26: {
    'size': '23.0 cm, Selada',
    'title': 'Membuka Mata',
    'description': 'Mata bayi mulai terbuka dan bisa berkedip. Bulu mata sudah tumbuh.',
    'emoji': '🥬',
  },
  27: {
    'size': '24.0 cm, Pizza',
    'title': 'Trimester Ketiga Dimulai',
    'description': 'Trimester ketiga dimulai. Bayi mulai punya pola tidur-bangun yang rutin.',
    'emoji': '🍕',
  },
  28: {
    'size': '25.0 cm, Paha Ayam',
    'title': 'Otak Aktif',
    'description': 'Otak bayi sangat aktif dan bisa bermimpi selama tidur REM.',
    'emoji': '🍗',
  },
  29: {
    'size': '26.0 cm, Terong',
    'title': 'Persiapan Lahir',
    'description': 'Ruang gerak bayi mulai sempit. Umumnya kepala mulai menghadap ke bawah.',
    'emoji': '🍆',
  },
  30: {
    'size': '27.0 cm, Kubis',
    'title': 'Pertumbuhan Otak',
    'description': 'Otak bayi tumbuh dengan cepat dan berat badan semakin bertambah.',
    'emoji': '🥬',
  },
  31: {
    'size': '28.0 cm, Sepatu Boots',
    'title': 'Sistem Imun Terbentuk',
    'description': 'Bayi mulai menerima antibodi dari ibu untuk perlindungan setelah lahir.',
    'emoji': '👢',
  },
  32: {
    'size': '29.0 cm, Kelapa',
    'title': 'Latihan Napas',
    'description': 'Bayi melatih napas dengan menghirup dan menghembuskan cairan ketuban.',
    'emoji': '🥥',
  },
  33: {
    'size': '30.0 cm, Nanas',
    'title': 'Tulang Semakin Kuat',
    'description': 'Tulang bayi mengeras kecuali tulang tengkorak yang masih lunak untuk persalinan.',
    'emoji': '🍍',
  },
  34: {
    'size': '32.0 cm, Durian',
    'title': 'Refleks Aktif',
    'description': 'Refleks bayi sudah kuat dan ia mulai merespons cahaya, suara, dan sentuhan.',
    'emoji': '🌰',
  },
  35: {
    'size': '33.0 cm, Melon',
    'title': 'Menjadi Gemuk',
    'description': 'Bayi bertambah sekitar 30 gram per hari dan tubuhnya makin berisi.',
    'emoji': '🍈',
  },
  36: {
    'size': '34.0 cm, Pepaya',
    'title': 'Siap Dilahirkan',
    'description': 'Bayi dianggap cukup bulan pada minggu ke-37. Paru-paru siap bernapas.',
    'emoji': '🍈',
  },
  37: {
    'size': '35.0 cm, Ukulele',
    'title': 'Hampir Sampai',
    'description': 'Bayi berada pada tahap “early term” dan berlatih menghisap serta bernapas.',
    'emoji': '🎸',
  },
  38: {
    'size': '36.0 cm, Buah Nangka',
    'title': 'Cukup Bulan',
    'description': 'Bayi dianggap cukup bulan dan siap lahir kapan saja.',
    'emoji': '🥭',
  },
  39: {
    'size': '37.0 cm, Labu',
    'title': 'Persiapan Akhir',
    'description': 'Lemak terus bertambah. Bayi siap menghadapi dunia luar.',
    'emoji': '🎃',
  },
  40: {
    'size': '38.0 cm, Semangka',
    'title': 'Hari Perkiraan Lahir',
    'description': 'Bayi sudah berkembang sempurna dan siap bertemu denganmu!',
    'emoji': '🍉',
  },
};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHealthDataForWeek(_selectedWeek);
    });
  }

  void _fetchHealthDataForWeek(int week) async {
    if (!mounted) return;

    setState(() {
      _isLoadingHealthData = true;
    });

    try {
      final healthData =
          await _kesehatanController.getHealthTrackingByWeek(week);
      if (!mounted) return;

      setState(() {
        _currentWeekHealthData = healthData;
      });
    } catch (e) {
      print('Error fetching health data: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingHealthData = false;
      });
    }
  }

  Widget _getBabyImage() {
    final String imagePath = 'assets/baby/minggu$_selectedWeek.png';

    // Check if we've already verified this image exists
    if (_imageExistsCache.containsKey(imagePath)) {
      return _renderImage(imagePath, _imageExistsCache[imagePath]!);
    }

    return FutureBuilder<bool>(
      future: _checkAndCacheImageExists(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final bool exists = snapshot.data ?? false;
        return _renderImage(imagePath, exists);
      },
    );
  }

  // Helper method to render the image based on existence
  Widget _renderImage(String imagePath, bool exists) {
    if (exists) {
      return Image.asset(
        imagePath,
        height: 300,
        fit: BoxFit.contain,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          SizedBox(height: 6),
          Text(
            'Gambar minggu$_selectedWeek tidak tersedia',
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }

  // Modified helper method to check and cache image existence
  Future<bool> _checkAndCacheImageExists(String assetPath) async {
    if (_imageExistsCache.containsKey(assetPath)) {
      return _imageExistsCache[assetPath]!;
    }

    try {
      await rootBundle.load(assetPath);
      _imageExistsCache[assetPath] = true;
      return true;
    } catch (e) {
      debugPrint('Image not found: $assetPath');
      _imageExistsCache[assetPath] = false;
      return false;
    }
  }

  // Make sure to override dispose to clean up resources if needed
  @override
  void dispose() {
    _imageExistsCache.clear();
    _searchController.dispose();
    super.dispose();
  }

Widget _buildColoredStatItem({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            offset: const Offset(0, 3),
            blurRadius: 6,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: const Offset(-2, -2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10), // Slightly reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: color), // Slightly smaller icon
              ),
              const SizedBox(width: 6), // Reduced spacing
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12, // Reduced font size
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6), // Reduced spacing
          Expanded( // Changed from Flexible to Expanded
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20, // Slightly reduced font size
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 11, // Slightly reduced font size
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: Color(0xFFF2F4F7),
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Color(0xFFF2F4F7),
      ),
      body: Container(
        color: Color(0xFFF2F4F7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section dengan padding yang lebih kecil
            Builder(
              builder: (context) {
                final currentTab = DefaultTabController.of(context)?.index ?? 0;
                return Container(
                  color: Color(0xFFF2F4F7),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8, // Dikurangi dari 16
                    left: 20,
                    right: 20,
                    bottom: 8, // Dikurangi dari 16
                  ),
                  child: Column(
                    children: [
                      // Title dan Search Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _isSearching
                                ? SizedBox(
                                    key: ValueKey('search-field'),
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: TextField(
                                      controller: _searchController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Cari Tips n Trik...',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Color(0xFFF2F4F7),
                                      ),
                                      style: TextStyle(color: Colors.black87),
                                      onChanged: (value) {
                                        setState(() {
                                          _searchQuery = value;
                                        });
                                      },
                                    ),
                                  )
                                : Text(
                                    "Kesehatan",
                                    key: ValueKey('title'),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                          ),
                          if (currentTab == 1)
                            IconButton(
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _isSearching
                                    ? Icon(Icons.close, key: ValueKey('close-icon'))
                                    : Icon(Icons.search, key: ValueKey('search-icon')),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSearching = !_isSearching;
                                  if (!_isSearching) {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  }
                                });
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 12), // Dikurangi dari 16
                      // TabBar dengan ukuran yang lebih kompak
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F4F7),
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                        child: TabBar(
                          indicatorWeight: 3, // Dikurangi dari 4
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Color(0xFF10B2CF),
                          labelColor: Color(0xFF10B2CF),
                          unselectedLabelColor: Colors.grey,
                          labelStyle: TextStyle(
                            fontSize: 16, // Dikurangi dari 18
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 16, // Dikurangi dari 18
                            fontWeight: FontWeight.w400,
                          ),
                          // Mengurangi padding di TabBar
                          labelPadding: EdgeInsets.symmetric(vertical: 8), // Tambahkan ini
                          tabs: [
                            Tab(text: "Minggu Si-Bayi"),
                            Tab(text: "Tips & Trik"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab - Minggu Si-Bayi
                  SingleChildScrollView(
                    controller: widget.scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                itemCount: 40,
                                itemBuilder: (context, index) {
                                  final weekNum = index + 1;
                                  final isSelected = weekNum == _selectedWeek;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedWeek = weekNum;
                                      });
                                      _fetchHealthDataForWeek(weekNum);
                                    },
                                    child: Container(
                                      width: 40,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            weekNum.toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: isSelected
                                                  ? FontWeight.w800
                                                  : FontWeight.w600,
                                              color: isSelected
                                                  ? Color(0xFF10B2CF)
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 200),
                                            width: isSelected ? 16 : 0,
                                            height: 2,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Color(0xFF10B2CF)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: _getBabyImage(),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bayi Di Minggu Ini",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      _weekData[_selectedWeek]?['size'] ??
                                          "Unknown size",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    _weekData[_selectedWeek]?['emoji'] ?? "🍼",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                _weekData[_selectedWeek]?['title'] ?? "",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                _weekData[_selectedWeek]?['description'] ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Data Appointment",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Builder(
                                    builder: (context) {
                                      double screenWidth =
                                          MediaQuery.of(context).size.width;
                                      int crossAxisCount =
                                          _getCrossAxisCount(screenWidth);
                                      double childAspectRatio =
                                          _getChildAspectRatio(screenWidth);
                                      double gridHeight = _calculateGridHeight(
                                          crossAxisCount, screenWidth);
                                      return SizedBox(
                                        height: gridHeight,
                                        child: _isLoadingHealthData
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : GridView.count(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                crossAxisCount: crossAxisCount,
                                                childAspectRatio:
                                                    childAspectRatio,
                                                mainAxisSpacing: 12,
                                                crossAxisSpacing: 12,
                                                children: [
                                                  _buildColoredStatItem(
                                                    title: "Tekanan Darah",
                                                    value: _currentWeekHealthData
                                                            ?.bloodPressure ??
                                                        "-/-",
                                                    unit: "mmHg",
                                                    icon: Icons
                                                        .monitor_heart_outlined,
                                                    color: Colors.blue[400]!,
                                                  ),
                                                  _buildColoredStatItem(
                                                    title: "Detak Jantung",
                                                    value:
                                                        _currentWeekHealthData
                                                                ?.heartRate
                                                                ?.toString() ??
                                                            "-",
                                                    unit: "BPM",
                                                    icon:
                                                        Icons.favorite_outline,
                                                    color: Colors.red[400]!,
                                                  ),
                                                  _buildColoredStatItem(
                                                    title: "Berat Badan",
                                                    value: _currentWeekHealthData
                                                            ?.weight
                                                            ?.toStringAsFixed(
                                                                1) ??
                                                        "-",
                                                    unit: "Kg",
                                                    icon: Icons.scale_outlined,
                                                    color: Colors.orange[400]!,
                                                  ),
                                                  _buildColoredStatItem(
                                                    title: "Tinggi Badan",
                                                    value: _currentWeekHealthData
                                                            ?.height
                                                            ?.toStringAsFixed(
                                                                1) ??
                                                        "-",
                                                    unit: "Cm",
                                                    icon: Icons
                                                        .straighten_outlined,
                                                    color:
                                                        Colors.lightBlue[400]!,
                                                  ),
                                                ],
                                              ),
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(
                                "Catatan Bidan",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Text(
                                  _currentWeekHealthData?.notes ??
                                      _weekData[_selectedWeek]?['notes'] ??
                                      "Belum ada catatan.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Second Tab - Tips & Trik
                 TipsTrikTab(
                  scrollController: widget.scrollController,
                  searchQuery: _searchQuery,
                  isSearching: _isSearching,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    ),
  );
}

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) {
      return 4; // Very large screens (desktop)
    } else if (screenWidth > 800) {
      return 3; // Large screens (tablet landscape)
    } else if (screenWidth > 600) {
      return 2; // Medium screens (tablet portrait)
    } else {
      return 2; // Small screens (mobile)
    }
  }

// Helper method to determine aspect ratio based on screen width
  double _getChildAspectRatio(double screenWidth) {
    if (screenWidth > 1200) {
      return 1.6; // Very large screens
    } else if (screenWidth > 800) {
      return 1.5; // Large screens
    } else if (screenWidth > 600) {
      return 1.4; // Medium screens
    } else {
      return 1.3; // Small screens
    }
  }

// Helper method to calculate grid height based on cross axis count and screen width
  double _calculateGridHeight(int crossAxisCount, double screenWidth) {
    // Calculate number of rows (4 items total)
    int rows = (4 / crossAxisCount).ceil();

    // Base item height calculation
    double itemWidth = (screenWidth - 32 - (crossAxisCount - 1) * 12) /
        crossAxisCount; // Screen width minus margins and spacing
    double childAspectRatio = _getChildAspectRatio(screenWidth);
    double itemHeight = itemWidth / childAspectRatio;

    // Total height = (rows * item height) + ((rows - 1) * main axis spacing)
    return (rows * itemHeight) + ((rows - 1) * 12);
  }
}
