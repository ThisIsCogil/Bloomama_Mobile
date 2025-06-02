import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:login/views/screens/dashboard/inbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calender.dart';
import 'registration_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../controllers/pregnancy_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../services/api_service.dart';
import '../../../models/health_model.dart';
import '../../../models/content_model.dart';
import '../../../models/user_pregnancy.dart';
import '../../../models/user_model.dart';
import '../../../controllers/content_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class BabyModelViewer extends StatefulWidget {
  const BabyModelViewer({Key? key}) : super(key: key);

  @override
  State<BabyModelViewer> createState() => _BabyModelViewerState();
}

class _BabyModelViewerState extends State<BabyModelViewer>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  bool _errorLoading = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorLoading = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: _errorLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load 3D model',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : _isLoading
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 100,
                    height: 100,
                  ),
                )
              : ModelViewer(
                  src: 'assets/models/baby_fix.glb',
                  alt: "3D Model Janin",
                  autoRotate: true,
                  cameraControls: true,
                  autoPlay: true,
                  ar: false,
                  shadowIntensity: 1.0,
                  exposure: 0.5,
                  backgroundColor: Colors.transparent,
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

  class _HomeScreenState extends State<HomeScreen>
      with AutomaticKeepAliveClientMixin {
    // Health data caching
    HealthData? _cachedHealthData;
    bool _isHealthDataLoading = false;
    bool _hasHealthDataError = false;
    String? _healthDataErrorMessage;
    bool _isLoadingPregnancyData = true;

    PregnancyData? _cachedPregnancyData;
    bool hasPregnancyData = false;
    String userName = '...';

    List<HealthData> _healthChartData = [];
    bool _isChartLoading = false;
    String? _chartErrorMessage;

    // Data kehamilan
    DateTime? dueDate;
    int pregnancyWeeks = 0;
    int pregnancyDays = 0;
    String trimester = "First trimester";
    int totalPregnancyDays = 0;
    DateTime? startDate;

    // Riwayat kehamilan
    int gravida = 0;
    int para = 0;
    int abortus = 0;

    @override
    bool get wantKeepAlive => true;

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadHealthData();
        _loadPregnancyData();
        _loadUserName();
        _loadChartData();
      });
    }

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      _loadPregnancyData();
    }

    Future<void> _loadUserName() async {
      final user =
          await AuthController().getUser(); // Panggil dari SharedPreferences
      if (user != null) {
        setState(() {
          userName = user.name;
        });
      }
    }

    Future<void> _loadPregnancyData() async {
      try {
        setState(() => _isLoadingPregnancyData = true);

        // First check if we have cached data
        if (_cachedPregnancyData != null) {
          debugPrint('Using cached pregnancy data');
          setState(() => hasPregnancyData = true);
          return;
        }

        // Ambil data user yang login untuk mendapatkan userId
        final user = await AuthController().getUser();
        if (user == null || user.userId == null) {
          debugPrint('No user data or userId found');
          setState(() => hasPregnancyData = false);
          return;
        }

        // Debug: Print userId untuk memastikan
        debugPrint('Loading pregnancy data for userId: ${user.userId}');

        // Ambil data kehamilan berdasarkan userId
        final pregnancyData = await ApiService.getPregnancyData(user.userId!);

        if (pregnancyData != null) {
          debugPrint('Pregnancy data loaded successfully');

          if (mounted) {
            setState(() {
              _cachedPregnancyData = pregnancyData;
              hasPregnancyData = true;
              totalPregnancyDays = pregnancyData.totalDays;
              trimester = pregnancyData.trimester;
            });
          }
        } else {
          debugPrint('No pregnancy data found for userId: ${user.userId}');
          if (mounted) {
            setState(() {
              hasPregnancyData = false;
              _cachedPregnancyData = null; // Clear any stale data
            });
          }
        }
      } catch (error) {
        debugPrint('Error loading pregnancy data: $error');
        if (mounted) {
          setState(() {
            hasPregnancyData = false;
            _cachedPregnancyData = null;
          });
        }
      } finally {
        if (mounted) {
          setState(() => _isLoadingPregnancyData = false);
        }
      }
    }

    // Method untuk load data kesehatan dan cache
    Future<void> _loadHealthData() async {
      if (_cachedHealthData != null) return; // Jika sudah ada cache, skip

      setState(() {
        _isHealthDataLoading = true;
        _hasHealthDataError = false;
        _healthDataErrorMessage = null;
      });

      try {
        final pregnancyController = PregnancyController(apiService: ApiService());
        final healthData = await pregnancyController.getLatestHealthTracking();

        if (mounted) {
          setState(() {
            _cachedHealthData = healthData;
            _isHealthDataLoading = false;
          });
        }
      } catch (error) {
        if (mounted) {
          setState(() {
            _isHealthDataLoading = false;
            _hasHealthDataError = true;
            _healthDataErrorMessage = error.toString();
          });
        }
      }
    }

    // Method untuk refresh data kesehatan
    Future<void> _refreshHealthData() async {
      setState(() {
        _cachedHealthData = null;
      });
      await _loadHealthData();
    }

    Future<void> _loadChartData() async {
      if (!mounted) return;

      setState(() {
        _isChartLoading = true;
        _chartErrorMessage = null;
      });

      try {
        final user = await AuthController().getUser();
        if (user == null || user.userId == null) {
          throw Exception('User not logged in');
        }

        final pregnancyController = PregnancyController(apiService: ApiService());
        final chartData =
            await pregnancyController.fetchHealthTrackingData(user.userId!);

        if (mounted) {
          setState(() {
            _healthChartData = chartData;
            _isChartLoading = false;
          });
        }
      } catch (error) {
        if (mounted) {
          setState(() {
            _isChartLoading = false;
            _chartErrorMessage = error.toString();
          });
        }
      }
    }

    Future<void> _openArticleDetail(BuildContext context, Content content) async {
      if (content.url != null && content.url!.isNotEmpty) {
        try {
          if (await canLaunchUrl(Uri.parse(content.url!))) {
            await launchUrl(
              Uri.parse(content.url!),
              mode: LaunchMode.externalApplication,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tidak dapat membuka tautan')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel tidak memiliki tautan')),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final contentProvider = Provider.of<ContentProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDFF),
      extendBody: true,
      body: SingleChildScrollView(
        controller: widget.scrollController,
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80), // Add padding for navbar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            _buildHeader(),
            _buildPregnancyCard(),
            _buildPregnancyInfo(),
            _buildHealthStats(), // Sekarang menggunakan cached data
            _buildMidwifeVisitsChart(),
            _buildArticlesSection(context, contentProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Today",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.email_outlined,
                    size: 28,
                    color: Color(0xFF00838F),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InboxView()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    size: 28,
                    color: Color(0xFF00838F),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomCalendarPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF2F4F7), Color(0xFFF2F4F7)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E88E5).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selamat Datang,",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFB3EAF4),
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF11B3CF),
                  ),
                ),
              ],
            ),
          ),

          // 3D Model section with the new widget
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 250,
              maxHeight: 250,
            ),
            child: Stack(
              children: [
                // Using the new widget here
                const BabyModelViewer(),

                // Day counter overlay
                if (hasPregnancyData)
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Day ${totalPregnancyDays}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11B3CF),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelViewer() {
    return const BabyModelViewer(); // Using const for further optimization
  }

  Widget _buildPregnancyInfo() {
    if (_isLoadingPregnancyData) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFE0F7FA)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: hasPregnancyData && _cachedPregnancyData != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Week and days indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _cachedPregnancyData!.currentWeekAndDay,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00838F),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Due date information
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF00838F)),
                    const SizedBox(width: 8),
                    Text(
                      'Due: ${DateFormat('dd MMM yyyy').format(_cachedPregnancyData!.dueDate)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF455A64),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress bar with indicators
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pregnancy Progress",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF455A64),
                          ),
                        ),
                        Text(
                          "${(_cachedPregnancyData!.progressPercentage * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00838F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        // Background track
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7FA),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        // Progress indicator
                        Container(
                          height: 12,
                          width: MediaQuery.of(context).size.width *
                              _cachedPregnancyData!.progressPercentage,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00ACC1), Color(0xFF00838F)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        // Trimester markers
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 14,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTrimesterMarker("1st", 0),
                              _buildTrimesterMarker("2nd", 0.33),
                              _buildTrimesterMarker("3rd", 0.66),
                              _buildTrimesterMarker("Due", 1.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : _buildNoPregnancyDataUI(),
    );
  }

  Widget _buildTrimesterMarker(String label, double position) {
    return Transform.translate(
      offset: Offset(-8 * (1 - position), 0),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF00838F),
            ),
          ),
          Container(
            width: 2,
            height: 8,
            color: const Color(0xFF00838F),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPregnancyDataUI() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 150,
            child: Lottie.asset('assets/lottie/family2.json'),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Start New Journey",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00838F),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PregnancyRegistrationScreen(
                        onRegistrationComplete: (pregnancyData) async {
                          // Store in shared preferences
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('cachedPregnancyData',
                              jsonEncode(pregnancyData.toApiJson()));

                          if (mounted) {
                            setState(() {
                              hasPregnancyData = true;
                              _cachedPregnancyData = pregnancyData;
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF00ACC1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  elevation: 3,
                  shadowColor: const Color(0xFF00ACC1).withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Start Now",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Health Data",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: _refreshHealthData,
                icon: const Icon(
                  Icons.refresh,
                  color: Color(0xFF00838F),
                  size: 20,
                ),
                tooltip: 'Refresh Data',
              ),
            ],
          ),
          // Reduced spacing here
          const SizedBox(height: 4),
          _buildHealthContent(),
        ],
      ),
    );
  }

  Widget _buildHealthContent() {
    if (_isHealthDataLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading health data...'),
            ],
          ),
        ),
      );
    }

    if (_hasHealthDataError) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Text(
                'Error: ${_healthDataErrorMessage ?? 'Unknown error'}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _refreshHealthData,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Use MediaQuery to get screen width and determine layout
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = _getCrossAxisCount(screenWidth);
    double childAspectRatio = _getChildAspectRatio(screenWidth);

    // Remove SizedBox height constraint and let GridView size itself
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: 8, // Reduced spacing
      crossAxisSpacing: 8, // Reduced spacing
      padding: EdgeInsets.zero, // Remove default padding
      children: [
        _buildColoredStatItem(
          title: "Tekanan Darah",
          value: _cachedHealthData?.bloodPressure ?? '-/-',
          unit: "mmHg",
          icon: Icons.monitor_heart_outlined,
          color: Colors.blue[400]!,
        ),
        _buildColoredStatItem(
          title: "Detak Jantung",
          value: _cachedHealthData?.heartRate?.toString() ?? '-',
          unit: "BPM",
          icon: Icons.favorite_outline,
          color: Colors.red[400]!,
        ),
        _buildColoredStatItem(
          title: "Berat Badan",
          value: _cachedHealthData?.weight?.toString() ?? '-',
          unit: "Kg",
          icon: Icons.scale_outlined,
          color: Colors.orange[400]!,
        ),
        _buildColoredStatItem(
          title: "Tinggi Badan",
          value: _cachedHealthData?.height?.toString() ?? '-',
          unit: "Cm",
          icon: Icons.straighten_outlined,
          color: Colors.lightBlue[400]!,
        ),
      ],
    );
  }

  // Helper method to determine cross axis count based on screen width
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
      return 1.2; // Increased ratio for mobile to prevent cutting off
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

  Widget _buildMidwifeVisitsChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Grafik Kunjungan Bidan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Pelacakan kesehatan mingguan",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: _loadChartData,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 14,
                            color: Colors.pink[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Perbarui",
                            style: TextStyle(
                              color: Colors.pink[400],
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildChartContent(),
          const SizedBox(height: 16),
          _buildChartLegendSection(),
        ],
      ),
    );
  }

  Widget _buildChartContent() {
    if (_isChartLoading) {
      return Container(
        height: 270,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
              SizedBox(height: 12),
              Text(
                'Memuat data...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_chartErrorMessage != null) {
      return Container(
        height: 270,
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red[100]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[400],
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'Terjadi Kesalahan',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$_chartErrorMessage',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_healthChartData.isEmpty) {
      return Container(
        height: 270,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_chart_outlined,
                color: Colors.grey[400],
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'Belum Ada Data',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Data kunjungan bidan akan muncul setelah pemeriksaan pertama',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 270,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildLineChart(_healthChartData),
    );
  }

  Widget _buildLineChart(List<HealthData> healthDataList) {
    // Filter dan urutkan data berdasarkan minggu kehamilan
    final filteredData =
        healthDataList.where((data) => data.pregnancyweek != null).toList();
    filteredData.sort((a, b) => a.pregnancyweek!.compareTo(b.pregnancyweek!));

    if (filteredData.isEmpty) {
      return const Center(child: Text('Tidak ada data untuk ditampilkan'));
    }

    // Siapkan data untuk chart
    final weeks =
        filteredData.map((data) => data.pregnancyweek!.toDouble()).toList();
    final bloodPressures =
        filteredData.map((data) => data.systolicBloodPressure).toList();
    final weights = filteredData.map((data) => data.weight).toList();
    final heartRates =
        filteredData.map((data) => data.heartRate.toDouble()).toList();

    // Hitung range untuk chart
    final minX = weeks.reduce((a, b) => a < b ? a : b);
    final maxX = weeks.reduce((a, b) => a > b ? a : b);

    // Hitung range Y yang lebih smart untuk setiap metrik
    final allValues = <double>[];
    allValues.addAll(bloodPressures);
    allValues.addAll(weights);
    allValues.addAll(heartRates);

    final minY = allValues.reduce((a, b) => a < b ? a : b);
    final maxY = allValues.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1; // 10% padding

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300]!,
              strokeWidth: 0.5,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey[300]!,
              strokeWidth: 0.5,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Transform.translate(
              offset: Offset(0, -10), // Angkat teks ke atas
              child: Text(
                'Minggu Kehamilan',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
            axisNameSize: 18, // Lebih kecil, jadi lebih rapat

            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: _calculateXInterval(minX, maxX),
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      height: 1.2,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: _calculateYInterval(minY - padding, maxY + padding),
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        minX: minX - 0.5,
        maxX: maxX + 0.5,
        minY: minY - padding,
        maxY: maxY + padding,
        lineBarsData: [
          // Garis tekanan darah sistol
          LineChartBarData(
            spots: weeks
                .asMap()
                .entries
                .map((e) => FlSpot(e.value, bloodPressures[e.key]))
                .toList(),
            isCurved: true,
            color: Colors.pink[400]!,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.pink[400]!,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.pink[400]!.withOpacity(0.1),
            ),
          ),
          // Garis berat badan
          LineChartBarData(
            spots: weeks
                .asMap()
                .entries
                .map((e) => FlSpot(e.value, weights[e.key]))
                .toList(),
            isCurved: true,
            color: Colors.blue[500]!,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.blue[500]!,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue[500]!.withOpacity(0.1),
            ),
          ),
          // Garis detak jantung
          LineChartBarData(
            spots: weeks
                .asMap()
                .entries
                .map((e) => FlSpot(e.value, heartRates[e.key]))
                .toList(),
            isCurved: true,
            color: Colors.green[500]!,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.green[500]!,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green[500]!.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

// Helper function untuk menghitung interval yang tepat
  double _calculateXInterval(double min, double max) {
    final range = max - min;
    if (range <= 5) return 1;
    if (range <= 10) return 2;
    if (range <= 20) return 4;
    return (range / 5).ceilToDouble();
  }

  double _calculateYInterval(double min, double max) {
    final range = max - min;
    if (range <= 10) return 2;
    if (range <= 50) return 10;
    if (range <= 100) return 20;
    return (range / 5).ceilToDouble();
  }

  Widget _buildChartLegendSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Keterangan:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildChartLegend(
                  Colors.pink[400]!,
                  'Tekanan\nDarah',
                ),
              ),
              Expanded(
                child: _buildChartLegend(
                  Colors.blue[500]!,
                  'Berat\nBadan',
                ),
              ),
              Expanded(
                child: _buildChartLegend(
                  Colors.green[500]!,
                  'Detak\nJantung',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue[600],
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Grafik menunjukkan perkembangan kesehatan per minggu kehamilan. '
                    'Konsultasikan dengan bidan jika ada perubahan signifikan.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue[700],
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildArticlesSection(
      BuildContext context, ContentProvider contentProvider) {
    // Fetch data when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (contentProvider.contents.isEmpty && !contentProvider.isLoading) {
        contentProvider.fetchLatestContent();
      }
    });

    if (contentProvider.isLoading && contentProvider.contents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (contentProvider.error.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Text(
          'Failed to load articles: ${contentProvider.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (contentProvider.contents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Rekomendasi Konten",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: contentProvider.contents.length,
              itemBuilder: (context, index) {
                final content = contentProvider.contents[index];
                return _buildArticleCard(
                  title: content.title,
                  // MODIFIED: Use effectiveThumbnail instead of thumbnail
                  thumbnail: content.effectiveThumbnail,
                  // ADDED: Pass YouTube thumbnail fallbacks for error handling
                  youtubeFallbacks: content.youtubeThumbnailFallbacks,
                  url: content.url,
                  // ADDED: Pass YouTube video flag
                  isYouTubeVideo: content.isYouTubeVideo,
                  onTap: () => _openArticleDetail(context, content),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildArticleCard({
  required String title,
  String? thumbnail,
  List<String>? youtubeFallbacks, // ADDED: YouTube fallback URLs
  String? url,
  bool isYouTubeVideo = false, // ADDED: YouTube video flag
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 230,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thumbnail image with play icon overlay
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                color: const Color(0xFF11B3CF),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: thumbnail != null && thumbnail.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: _buildImageWithFallback(
                              thumbnail,
                              youtubeFallbacks ?? [],
                              isYouTubeVideo,
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.play_arrow,
                                color: Colors.white, size: 40),
                          ),
                  ),
                  // Play icon overlay - only show for YouTube videos
                  if (isYouTubeVideo)
                    Center(
                      child: Icon(Icons.play_circle_fill,
                          color: Colors.black.withOpacity(0.6), size: 48),
                    ),
                ],
              ),
            ),
            // Video content (title + optional url)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.start,
                  ),
                  if (url != null && url.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        children: [
                          Icon(
                            // MODIFIED: Use YouTube icon for YouTube videos
                            isYouTubeVideo ? Icons.play_circle : Icons.link,
                            size: 14,
                            color: isYouTubeVideo ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              // MODIFIED: Show "YouTube" for YouTube videos
                              isYouTubeVideo ? "YouTube" : Uri.parse(url).host,
                              style: TextStyle(
                                fontSize: 9,
                                color: isYouTubeVideo ? Colors.red : Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
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
    ),
  );
}

// ADDED: Helper method to handle image loading with fallbacks
Widget _buildImageWithFallback(
  String primaryUrl,
  List<String> fallbackUrls,
  bool isYouTubeVideo,
) {
  return Image.network(
    primaryUrl,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      // If primary URL fails and we have fallbacks, try them
      if (fallbackUrls.isNotEmpty) {
        return _buildFallbackImage(fallbackUrls, 0);
      }
      
      // If no fallbacks or not YouTube, show default icon
      return Center(
        child: Icon(
          isYouTubeVideo ? Icons.play_arrow : Icons.image_not_supported,
          color: Colors.white,
          size: 40,
        ),
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      );
    },
  );
}

// ADDED: Recursive fallback image loader for YouTube thumbnails
Widget _buildFallbackImage(List<String> fallbackUrls, int index) {
  if (index >= fallbackUrls.length) {
    // All fallbacks failed, show default icon
    return const Center(
      child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
    );
  }
  
  return Image.network(
    fallbackUrls[index],
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      // Try next fallback
      return _buildFallbackImage(fallbackUrls, index + 1);
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      );
    },
  );
}
}
