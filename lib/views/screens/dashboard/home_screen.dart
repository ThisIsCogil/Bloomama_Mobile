import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'calender.dart';
import 'registration_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
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

// Model for midwife visit data
class MidwifeVisit {
  final int week;
  final int bloodPressure;
  final double weight;
  final int fetalHeartRate;

  MidwifeVisit(
      {required this.week,
      required this.bloodPressure,
      required this.weight,
      required this.fetalHeartRate});
}

class _HomeScreenState extends State<HomeScreen> {
  // Set initial state to show user doesn't have pregnancy data
  bool hasPregnancyData = false;

  // Pregnancy data fields
  String userName = "Hariadi";
  DateTime? dueDate;
  int pregnancyWeeks = 0;
  int pregnancyDays = 0;
  String trimester = "First trimester";
  int totalPregnancyDays = 0;

  // User pregnancy history
  int pregnancyCount = 0;
  int childrenCount = 0;
  int abortionCount = 0;
  DateTime? firstDayOfPregnancy;

  // Mock health data
  String weight = "58 kg";
  String height = "165 cm";
  String heartRate = "85 bpm";
  String bloodPressure = "110/70";

  @override
  void initState() {
    super.initState();

    // Due date will be calculated after registration
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDFF),
      extendBody: true,
      body: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.only(bottom: 80), // Add padding for navbar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
                height:
                    MediaQuery.of(context).padding.top), // Status bar height
            _buildHeader(),
            _buildPregnancyCard(),
            _buildPregnancyInfo(),
            _buildHealthStats(),
            _buildMidwifeVisitsChart(),
            _buildArticlesSection(),
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
                    Icons.notifications_outlined,
                    size: 28,
                    color: Color(0xFF00838F),
                  ),
                  onPressed: () {},
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
                  "Good afternoon,",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFB3EAF4),
                  ),
                ),
                const Text(
                  "Rahmat",
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
                          color: Colors.white,
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
      child: hasPregnancyData
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$pregnancyWeeks weeks, $pregnancyDays days pregnant",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00838F),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB2EBF2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_today_rounded,
                        color: Color(0xFF006064),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      trimester,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF455A64),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB2EBF2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.event,
                        color: Color(0xFF006064),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      dueDate != null
                          ? "Due ${DateFormat('dd MMM').format(dueDate!)}"
                          : "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF455A64),
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Color(0xFF0097A7),
                      ),
                      label: const Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0097A7),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFE0F7FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Progress",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF455A64),
                          ),
                        ),
                        Text(
                          "${(totalPregnancyDays / 280 * 100).toStringAsFixed(1)}%",
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: totalPregnancyDays /
                                280, // Approximate total days in pregnancy
                            minHeight: 16,
                            backgroundColor: const Color(0xFFB2EBF2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF00ACC1)),
                          ),
                        ),
                        Positioned(
                          left: (totalPregnancyDays / 280) *
                                  MediaQuery.of(context).size.width *
                                  0.85 -
                              10,
                          top: 0,
                          child: const Icon(
                            Icons.child_care,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : Row(
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
                                onRegistrationComplete: (pregnancyData) {
                                  setState(() {
                                    hasPregnancyData = true;
                                    userName = pregnancyData.fullName;
                                    pregnancyCount =
                                        pregnancyData.pregnancyCount;
                                    childrenCount = pregnancyData.childrenCount;
                                    abortionCount = pregnancyData.abortionCount;
                                    firstDayOfPregnancy =
                                        pregnancyData.firstDayOfPregnancy;
                                    dueDate = pregnancyData.dueDate;
                                    pregnancyWeeks = pregnancyData.currentWeeks;
                                    pregnancyDays = pregnancyData.currentDays;
                                    trimester = pregnancyData.trimester;
                                    totalPregnancyDays =
                                        pregnancyData.totalDays;
                                  });
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
            ),
    );
  }

  Widget _buildHealthStats() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Health Data",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 280, // Sesuaikan tinggi sesuai kebutuhan
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio:
                          (constraints.maxWidth / 2) / 120, // Dinamis
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _buildColoredStatItem(
                          title: "Tekanan Darah",
                          value: "120/80",
                          unit: "mmHg",
                          icon: Icons.monitor_heart_outlined,
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
                          icon: Icons.straighten_outlined,
                          color: Colors.lightBlue[400]!,
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
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

  Widget _buildMidwifeVisitsChart() {
    // Mock data for midwife visits
    final List<MidwifeVisit> visits = [
      MidwifeVisit(
          week: 8, bloodPressure: 110, weight: 56.5, fetalHeartRate: 0),
      MidwifeVisit(
          week: 12, bloodPressure: 112, weight: 57.2, fetalHeartRate: 160),
      MidwifeVisit(
          week: 16, bloodPressure: 114, weight: 58.5, fetalHeartRate: 155),
      MidwifeVisit(
          week: 20, bloodPressure: 112, weight: 60.1, fetalHeartRate: 150),
      MidwifeVisit(
          week: 24, bloodPressure: 115, weight: 62.3, fetalHeartRate: 148),
      MidwifeVisit(
          week: 28, bloodPressure: 118, weight: 64.0, fetalHeartRate: 145),
      MidwifeVisit(
          week: 32, bloodPressure: 120, weight: 65.7, fetalHeartRate: 140),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Midwife Appointments",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to detailed view of appointments
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                    color: Colors.pink[300],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Weekly progress tracking",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildLineChart(visits),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              _buildChartLegend(Colors.pink[300]!, "Blood Pressure"),
              _buildChartLegend(Colors.blue[400]!, "Weight"),
              _buildChartLegend(Colors.green[400]!, "Fetal Heart Rate"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<MidwifeVisit> visits) {
    final weeks = visits.map((v) => v.week.toDouble()).toList();
    final bloodPressures =
        visits.map((v) => v.bloodPressure.toDouble()).toList();
    final weights = visits.map((v) => v.weight).toList();
    final fetalRates = visits.map((v) => v.fetalHeartRate.toDouble()).toList();

    final allYValues = [...bloodPressures, ...weights, ...fetalRates];
    final minX = weeks.reduce((a, b) => a < b ? a : b);
    final maxX = weeks.reduce((a, b) => a > b ? a : b);
    final minY = allYValues.reduce((a, b) => a < b ? a : b);
    final maxY = allYValues.reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey[300],
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey[300],
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: (maxX - minX) / 5, // optional
              getTitlesWidget: (value, meta) => Text(
                'Week ${value.toInt()}',
                style: const TextStyle(color: Colors.black87, fontSize: 10),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxY - minY) / 5, // optional
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(color: Colors.black87, fontSize: 10),
              ),
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!),
        ),
        minX: minX - 1,
        maxX: maxX + 1,
        minY: (minY - 10).clamp(0, minY),
        maxY: maxY + 10,
        lineBarsData: [
          // Blood Pressure Line
          LineChartBarData(
            spots: visits
                .map((v) =>
                    FlSpot(v.week.toDouble(), v.bloodPressure.toDouble()))
                .toList(),
            isCurved: true,
            color: Colors.pink[300],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: Colors.pink[300]!,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(show: false),
          ),
          // Weight Line
          LineChartBarData(
            spots:
                visits.map((v) => FlSpot(v.week.toDouble(), v.weight)).toList(),
            isCurved: true,
            color: Colors.blue[400],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: Colors.blue[400]!,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(show: false),
          ),
          // Fetal Heart Rate Line
          LineChartBarData(
            spots: visits
                .map((v) =>
                    FlSpot(v.week.toDouble(), v.fetalHeartRate.toDouble()))
                .toList(),
            isCurved: true,
            color: Colors.green[400],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: Colors.green[400]!,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesSection() {
    final List<Map<String, String>> articles = [
      {'title': 'Healthy eating during pregnancy'},
      {'title': 'Pregnancy exercise basics'},
      {'title': 'Understanding fetal development'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Featured Articles",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return _buildArticleCard(
                  title: articles[index]['title']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard({required String title}) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.blue,
                child: const Center(
                  child: Icon(Icons.image, color: Colors.white, size: 40),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CirclePatternPainter extends CustomPainter {
  final Color color;

  CirclePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.3), size.width * 0.15, paint);

    canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.7), size.width * 0.1, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
