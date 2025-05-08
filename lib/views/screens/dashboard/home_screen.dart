import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'calender.dart';
import '../kesehatan/pregnancy_tracker_screen.dart';
import 'registration_screen.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
  String userName = "Adam";
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
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: SingleChildScrollView(
        controller: widget.scrollController,
        padding: EdgeInsets.only(bottom: 80), // Add padding for navbar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top), // Status bar height
            _buildHeader(),
            _buildPregnancyCard(),
            _buildHealthData(),
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
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, size: 28),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.calendar_month_outlined, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomCalendarPage()),
                  );
                },
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  "Adam",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                // Icon in the top-middle
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 100,
                  child: Center(
                    child: Icon(
                      Icons.child_friendly,
                      size: 120,
                      color: Colors.grey[400],
                    ),
                  ),
                ),

                // Show day count only if user has pregnancy data
                if (hasPregnancyData)
                  Positioned(
                    left: 24,
                    bottom: 24,
                    child: Text(
                      "Day ${totalPregnancyDays}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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

  Widget _buildPregnancyInfo() {
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
      child: hasPregnancyData
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$pregnancyWeeks weeks, $pregnancyDays days pregnant",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  trimester,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      dueDate != null ? "Due ${DateFormat('dd MMM').format(dueDate!)}" : "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF10B2CF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: totalPregnancyDays / 280, // Approximate total days in pregnancy
                    minHeight: 16,
                    backgroundColor: Colors.blue[100],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B2CF)),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Track Your Pregnancy",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Register to track your pregnancy progress, health data, and get personalized advice",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to registration screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PregnancyRegistrationScreen(
                          onRegistrationComplete: (pregnancyData) {
                            setState(() {
                              hasPregnancyData = true;
                              
                              // Update user data
                              userName = pregnancyData.fullName;
                              pregnancyCount = pregnancyData.pregnancyCount;
                              childrenCount = pregnancyData.childrenCount;
                              abortionCount = pregnancyData.abortionCount;
                              firstDayOfPregnancy = pregnancyData.firstDayOfPregnancy;
                              
                              // Update pregnancy progress data
                              dueDate = pregnancyData.dueDate;
                              pregnancyWeeks = pregnancyData.currentWeeks;
                              pregnancyDays = pregnancyData.currentDays;
                              trimester = pregnancyData.trimester;
                              totalPregnancyDays = pregnancyData.totalDays;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF10B2CF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
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
    );
  }

  Widget _buildHealthData() {
    return Column(
      children: [
        _buildPregnancyInfo(),
        Container(
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
              const Text(
                "Health Data",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoBox(
                    title: "Tekanan Darah",
                    value: "120/80",
                    color: Colors.redAccent,
                  ),
                  _buildInfoBox(
                    title: "Berat Badan",
                    value: "60 kg",
                    color: Colors.green,
                  ),
                  _buildInfoBox(
                    title: "Tinggi Badan",
                    value: "30 cm",
                    color: Colors.orange,
                  ),
                  _buildInfoBox(
                    title: "Detak Jantung",
                    value: "2 bpm",
                    color: Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildMidwifeVisitsChart(),
      ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartLegend(Colors.pink[300]!, "Blood Pressure"),
              const SizedBox(width: 16),
              _buildChartLegend(Colors.blue[400]!, "Weight"),
              const SizedBox(width: 16),
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
    // Mock articles data
    final List<Map<String, String>> articles = [
      {
        'title': 'Healthy eating during pregnancy',
        'thumbnail': 'assets/pregnancy_food.jpg',
      },
      {
        'title': 'Pregnancy exercise basics',
        'thumbnail': 'assets/pregnancy_exercise.jpg',
      },
      {
        'title': 'Understanding fetal development',
        'thumbnail': 'assets/fetal_development.jpg',
      },
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
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return _buildArticleCard(
                  title: articles[index]['title']!,
                  thumbnail: articles[index]['thumbnail']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard({required String title, required String thumbnail}) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    thumbnail,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}