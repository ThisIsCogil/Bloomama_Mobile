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
      'size': '0.1 cm, Poppy seed',
      'title': 'The beginning',
      'description':
          'Conception has just occurred! The fertilized egg is dividing rapidly as it travels down the fallopian tube toward the uterus.',
      'emoji': '🌱',
      'notes': 'Semua normal, lanjutkan makan bergizi.',
    },
    2: {
      'size': '0.2 cm, Sesame seed',
      'title': 'Getting comfortable',
      'description':
          'The embryo attaches to the uterine lining. The placenta starts to form and will eventually deliver nutrients to the baby.',
      'emoji': '🌱',
    },
    3: {
      'size': '0.4 cm, Poppy seed',
      'title': 'Forming layers',
      'description':
          'The embryo is now made up of three layers that will develop into different parts of the body.',
      'emoji': '🌱',
    },
    4: {
      'size': '0.6 cm, Blueberry',
      'title': 'Taking shape',
      'description':
          'The neural tube, which will develop into the brain and spinal cord, is forming. Small buds that will become arms and legs start to appear.',
      'emoji': '🫐',
    },
    5: {
      'size': '1.3 cm, Grape',
      'title': 'Growing rapidly',
      'description':
          'The heart is now beating at a regular rhythm. Other organs are starting to develop, and the embryo has a curved C-shape.',
      'emoji': '🍇',
    },
    6: {
      'size': '1.7 cm, Lentil',
      'title': 'Facial features forming',
      'description':
          'Eyes, ears, and nose are beginning to form. The embryo is about the size of a lentil.',
      'emoji': '🫘',
    },
    7: {
      'size': '2.5 cm, Raspberry',
      'title': 'Limb development',
      'description':
          'Arms and legs are growing longer, and fingers and toes are beginning to form. The embryo is now officially a fetus.',
      'emoji': '🍓',
    },
    8: {
      'size': '3.0 cm, Kidney bean',
      'title': 'Becoming more human',
      'description':
          'All essential organs have begun to form. The ears are developing, and the eyelids are starting to cover the eyes.',
      'emoji': '🫘',
    },
    9: {
      'size': '4.0 cm, Grape',
      'title': 'Moving around',
      'description':
          'The baby is starting to move, but you probably won\'t feel it yet. Tiny muscles are developing.',
      'emoji': '🍇',
    },
    10: {
      'size': '5.0 cm, Strawberry',
      'title': 'Developing bones',
      'description':
          'The skeleton is forming from cartilage into bone. The baby now has a more human appearance.',
      'emoji': '🍓',
    },
    11: {
      'size': '6.0 cm, Fig',
      'title': 'Distinct features',
      'description':
          'The baby\'s face is broadening, and the ears are positioned on the sides of the head. Tooth buds are forming.',
      'emoji': '🫐',
    },
    12: {
      'size': '7.0 cm, Lime',
      'title': 'End of first trimester',
      'description':
          'The baby\'s gender may be visible now. The baby can make facial expressions and even suck their thumb.',
      'emoji': '🫒',
    },
    13: {
      'size': '8.0 cm, Lemon',
      'title': 'Unique fingerprints',
      'description':
          'The baby\'s fingerprints are forming. The baby is also starting to produce and secrete urine.',
      'emoji': '🍋',
    },
    14: {
      'size': '9.0 cm, Apple',
      'title': 'Rapid growth',
      'description':
          'The baby\'s body is growing faster than their head. The neck is becoming more defined.',
      'emoji': '🍎',
    },
    15: {
      'size': '10.0 cm, Orange',
      'title': 'Sensing light',
      'description':
          'The baby\'s eyes are becoming sensitive to light. They can also hear sounds from outside the womb.',
      'emoji': '🍊',
    },
    16: {
      'size': '11.5 cm, Avocado',
      'title': 'Developing senses',
      'description':
          'The baby can hear your voice now. The legs are growing longer than the arms, and the body is becoming more proportionate.',
      'emoji': '🥑',
    },
    17: {
      'size': '13.0 cm, Pear',
      'title': 'Growing stronger',
      'description':
          'The baby is developing adipose tissue (fat) and is starting to look more like a newborn.',
      'emoji': '🍐',
    },
    18: {
      'size': '14.2 cm, Sweet potato',
      'title': 'Stretching out',
      'description':
          'The baby\'s movements are becoming more coordinated. They can yawn, stretch, and make facial expressions.',
      'emoji': '🍠',
    },
    19: {
      'size': '15.3 cm, Sandwich Subway!',
      'title': 'Breathing in! Breathing out!',
      'description':
          'My sensitive skin is now covered in vernix caseosa, a greasy, white, cheese-like coating that protects my skin from being wrinkled at birth. Lungs are developing, with the main airways (called bronchioles) beginning to form this week.',
      'emoji': '🥪',
    },
    20: {
      'size': '16.5 cm, Banana',
      'title': 'Halfway there!',
      'description':
          'You\'re halfway through your pregnancy! The baby is developing a regular sleep-wake cycle and may respond to sounds with movement.',
      'emoji': '🍌',
    },
    21: {
      'size': '18.0 cm, Carrot',
      'title': 'Taste buds forming',
      'description':
          'The baby\'s taste buds are developing, and they can taste the different flavors in your amniotic fluid.',
      'emoji': '🥕',
    },
    22: {
      'size': '19.0 cm, Papaya',
      'title': 'Developing eyes',
      'description':
          'The baby\'s eyes are formed but still developing. The irises don\'t have color yet.',
      'emoji': '🍈',
    },
    23: {
      'size': '20.0 cm, Grapefruit',
      'title': 'Gaining weight',
      'description':
          'The baby is putting on weight rapidly now. The lungs are continuing to develop.',
      'emoji': '🍊',
    },
    24: {
      'size': '21.0 cm, Ear of corn',
      'title': 'Viability milestone',
      'description':
          'The baby has reached viability, meaning they might be able to survive outside the womb with intensive care.',
      'emoji': '🌽',
    },
    25: {
      'size': '22.0 cm, Cauliflower',
      'title': 'Responding to sound',
      'description':
          'The baby responds to your voice and other sounds by moving or increasing their heart rate.',
      'emoji': '🥦',
    },
    26: {
      'size': '23.0 cm, Lettuce',
      'title': 'Opening eyes',
      'description':
          'The baby\'s eyes are now open, and they can blink. Their eyelashes have formed.',
      'emoji': '🥬',
    },
    27: {
      'size': '24.0 cm, Rutabaga',
      'title': 'Third trimester begins',
      'description':
          'The baby is starting the third trimester! They\'re sleeping and waking at regular intervals.',
      'emoji': '🥔',
    },
    28: {
      'size': '25.0 cm, Eggplant',
      'title': 'Brain development',
      'description':
          'The baby\'s brain is very active now, and they can dream during REM sleep.',
      'emoji': '🍆',
    },
    29: {
      'size': '26.0 cm, Butternut squash',
      'title': 'Preparing for birth',
      'description':
          'The baby is getting more cramped in the uterus. They\'re usually positioned with their head facing down.',
      'emoji': '🥔',
    },
    30: {
      'size': '27.0 cm, Cabbage',
      'title': 'Rapid brain growth',
      'description':
          'The baby\'s brain is growing rapidly, and they\'re gaining more weight.',
      'emoji': '🥬',
    },
    31: {
      'size': '28.0 cm, Coconut',
      'title': 'Developing immune system',
      'description':
          'The baby is receiving antibodies from you, which will help protect them after birth.',
      'emoji': '🥥',
    },
    32: {
      'size': '29.0 cm, Jicama',
      'title': 'Practicing breathing',
      'description':
          'The baby is practicing breathing by inhaling and exhaling amniotic fluid.',
      'emoji': '🥔',
    },
    33: {
      'size': '30.0 cm, Pineapple',
      'title': 'Stronger bones',
      'description':
          'The baby\'s bones are hardening, except for the skull bones, which remain soft for birth.',
      'emoji': '🍍',
    },
    34: {
      'size': '32.0 cm, Cantaloupe',
      'title': 'Developing reflexes',
      'description':
          'The baby has strong reflexes and may respond to light, sound, and touch.',
      'emoji': '🍈',
    },
    35: {
      'size': '33.0 cm, Honeydew melon',
      'title': 'Getting plump',
      'description':
          'The baby is gaining about an ounce a day and getting plumper.',
      'emoji': '🍈',
    },
    36: {
      'size': '34.0 cm, Romaine lettuce',
      'title': 'Ready for birth',
      'description':
          'The baby is considered full-term at 37 weeks. Their lungs are ready for breathing air.',
      'emoji': '🥬',
    },
    37: {
      'size': '35.0 cm, Swiss chard',
      'title': 'Almost there',
      'description':
          'The baby is considered early term. They\'re practicing important skills like sucking and breathing.',
      'emoji': '🥬',
    },
    38: {
      'size': '36.0 cm, Leek',
      'title': 'Full term',
      'description':
          'The baby is now considered full term. They\'re ready to be born any day now!',
      'emoji': '🥬',
    },
    39: {
      'size': '37.0 cm, Watermelon',
      'title': 'Final preparations',
      'description':
          'The baby is continuing to build fat layers. They\'re preparing for the transition to life outside the womb.',
      'emoji': '🍉',
    },
    40: {
      'size': '38.0 cm, Small pumpkin',
      'title': 'Due date approaching',
      'description':
          'The baby is fully developed and ready to meet you! The average baby weighs about 7.5 pounds at birth.',
      'emoji': '🎃',
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
      padding: const EdgeInsets.all(12),
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
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2, // Allow 2 lines for longer titles
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
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
