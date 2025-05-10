import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PregnancyTrackerScreen extends StatefulWidget {
  final ScrollController scrollController;

  const PregnancyTrackerScreen({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<PregnancyTrackerScreen> createState() => _PregnancyTrackerScreenState();
}

class _PregnancyTrackerScreenState extends State<PregnancyTrackerScreen> {
  int _selectedWeek = 19;
  bool isSearching = false;

  final Map<int, Map<String, dynamic>> _weekData = {
    1: {
      'size': '0.1 cm, Poppy seed',
      'title': 'The beginning',
      'description':
          'Conception has just occurred! The fertilized egg is dividing rapidly as it travels down the fallopian tube toward the uterus.',
      'emoji': '🌱',
      'bp': '110/70',
      'weight': '50 kg',
      'height': '60 cm',
      'heartRate': '23 bpm',
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

  Widget _buildTabButton(String title, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.cyan : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          SizedBox(height: 6),
          if (isSelected)
            Container(
              height: 3,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title) {
    return Container(
      height: 32,
      child: OutlinedButton(
        onPressed: () {},
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildFeaturedVideoItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage('assets/profile_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/profile_image.jpg'),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Video Title Here",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Ukuran font lebih kecil
                  ),
                ),
                Wrap(
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Channel Name",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12), // Ukuran font lebih kecil
                    ),
                    Icon(Icons.check_circle, size: 12, color: Colors.grey),
                    Text(
                      "12M views • 1 week ago",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12), // Ukuran font lebih kecil
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryVideoItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: AssetImage('assets/profile_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Video Title Here",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Channel Name",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoListItem() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                image: AssetImage('assets/profile_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Video Title Here",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "Channel Name",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.check_circle, size: 14, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  "12M views • 1 week ago",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBabyImage() {
    final String imagePath = 'assets/baby/minggu$_selectedWeek.png';

    return FutureBuilder<bool>(
      future: _checkImageExists(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final bool exists = snapshot.data ?? false;
        if (exists) {
          return Image.asset(
            imagePath,
            height: 300, // atau sesuaikan sesuai kebutuhan
            fit: BoxFit.contain,
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
              SizedBox(height: 6), // kecilkan dari 10 ke 6
              Text(
                'Gambar minggu$_selectedWeek tidak tersedia',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
      },
    );
  }

// Helper method to check if an asset image exists
  Future<bool> _checkImageExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      debugPrint('Image not found: $assetPath');
      return false;
    }
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
                  overflow: TextOverflow.ellipsis, // Tambahkan ini
                  maxLines: 1, // Batasi 1 baris
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: isSearching
                    ? Row(
                        key: ValueKey('search'),
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Cari Tips n Trik...',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSearching = false;
                              });
                            },
                            child: Icon(Icons.close,
                                size: 28, color: Colors.black54),
                          ),
                        ],
                      )
                    : Row(
                        key: ValueKey('normal'),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kesehatan",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSearching = true;
                                  });
                                },
                                child: Icon(Icons.search,
                                    size: 28, color: Colors.black54),
                              ),
                              SizedBox(width: 16),
                              Icon(Icons.bookmark_border,
                                  size: 28, color: Colors.black54),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TabBar(
                      indicatorWeight: 4,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Color(0xFF10B2CF),
                      labelColor: Color(0xFF10B2CF),
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      tabs: [
                        Tab(text: "Minggu Si-Bayi"),
                        Tab(text: "Tips & Trik"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab - Minggu Si-Bayi
                  SingleChildScrollView(
                    controller: widget.scrollController,
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
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Data Appointment",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return GridView.count(
                                              shrinkWrap: true,
                                              physics:const NeverScrollableScrollPhysics(), 
                                              crossAxisCount: 2,
                                              childAspectRatio:
                                                  (constraints.maxWidth / 2) /
                                                      120, // Dinamis
                                              mainAxisSpacing: 12,
                                              crossAxisSpacing: 12,
                                              children: [
                                                _buildColoredStatItem(
                                                  title: "Tekanan Darah",
                                                  value: "120/80",
                                                  unit: "mmHg",
                                                  icon: Icons
                                                      .monitor_heart_outlined,
                                                  color: Colors.blue[400]!,
                                                ),
                                                _buildColoredStatItem(
                                                  title: "Detak Jantung",
                                                  value: "89",
                                                  unit: "BPM",
                                                  icon: Icons.favorite_outline,
                                                  color: Colors.red[400]!,
                                                ),
                                                _buildColoredStatItem(
                                                  title: "Berat Badan",
                                                  value: "70.5",
                                                  unit: "Kg",
                                                  icon: Icons.scale_outlined,
                                                  color: Colors.orange[400]!,
                                                ),
                                                _buildColoredStatItem(
                                                  title: "Tinggi Badan",
                                                  value: "165.6",
                                                  unit: "Cm",
                                                  icon:
                                                      Icons.straighten_outlined,
                                                  color: Colors.lightBlue[400]!,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
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
                  SingleChildScrollView(
                    controller: widget.scrollController,
                    padding: EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildCategoryButton("Olahraga"),
                                SizedBox(width: 8),
                                _buildCategoryButton("Nutrisi"),
                                SizedBox(width: 8),
                                _buildCategoryButton("Penyakit"),
                                SizedBox(width: 8),
                                _buildCategoryButton("Kesehatan"),
                              ],
                            ),
                          ),
                        ),

                        // Video Terbaru section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Video Terbaru",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              _buildFeaturedVideoItem(),
                            ],
                          ),
                        ),

                        // History Tontonan section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "History Tontonan",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                height: 100,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    _buildHistoryVideoItem(),
                                    SizedBox(width: 10),
                                    _buildHistoryVideoItem(),
                                    SizedBox(width: 10),
                                    _buildHistoryVideoItem(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Video section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Video",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              _buildVideoListItem(),
                              SizedBox(height: 12),
                              _buildVideoListItem(),
                            ],
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
      ),
    );
  }
}
