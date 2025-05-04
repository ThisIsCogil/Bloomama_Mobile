import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'calender.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRegistered = false;
  DateTime? pregnancyStartDate;
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(),
            SizedBox(height: 16),
            _buildStartJourney(),
            SizedBox(height: 16),
            _buildHealthyTracker(),
            SizedBox(height: 16),
            _buildTipsAndTricks(),
            SizedBox(height: 16),
            _buildMakeAppointment(),
            SizedBox(height: 16),
            _buildSchedule(context),
            SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/profile.jpg'),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("King Adam",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Age 20", style: TextStyle(color: Colors.grey)),
          ],
        ),
        Spacer(),
        Icon(Icons.notifications, color: Colors.blue),
      ],
    );
  }

  Widget _buildStartJourney() {
    if (!isRegistered) {
      // ➡️ Kondisi belum registrasi
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF11B3CF), Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.pregnant_woman, size: 45, color: Colors.white),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Start Your Journey",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Langkah pertama untuk Si Bayi!",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _showRegistrationForm(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: TextStyle(fontSize: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Start"),
            ),
          ],
        ),
      );
    } else {
      // ➡️ Kondisi sudah registrasi (tampilkan progress bar)
      final int totalPregnancyDays = 900; // ~40 minggu * 7
      final int currentDays = DateTime.now().difference(pregnancyStartDate!).inDays;
      final double progress = min(currentDays / totalPregnancyDays, 1.0);

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF11B3CF), Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pregnancy Progress",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Hari ke: $currentDays dari $totalPregnancyDays",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      );
    }
  }

void _showRegistrationForm() {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pregnantTimesController = TextEditingController();
  final TextEditingController childCountController = TextEditingController();
  final TextEditingController abortionCountController = TextEditingController();
  DateTime? selectedDate;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Registrasi Kehamilan",
          style: TextStyle(
            color: Color(0xFF11B3CF),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, "Nama Lengkap"),
                  SizedBox(height: 12),
                  _buildTextField(
                    pregnantTimesController,
                    "Hamil Berapa Kali",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    childCountController,
                    "Jumlah Anak",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    abortionCountController,
                    "Pernah Aborsi Berapa Kali",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF11B3CF),
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFF11B3CF),
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setStateDialog(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null
                                ? 'Tanggal Awal Kehamilan'
                                : DateFormat('dd MMMM yyyy', 'id').format(selectedDate!),
                            style: TextStyle(
                              color: selectedDate == null ? Colors.grey : Colors.black,
                            ),
                          ),
                          Icon(Icons.calendar_today, color: Color(0xFF11B3CF)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF11B3CF),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  pregnantTimesController.text.isNotEmpty &&
                  childCountController.text.isNotEmpty &&
                  abortionCountController.text.isNotEmpty &&
                  selectedDate != null) {
                setState(() {
                  isRegistered = true;
                  pregnancyStartDate = selectedDate;
                  // Optional: Simpan data lainnya ke state jika perlu
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Lengkapi semua data terlebih dahulu!")),
                );
              }
            },
            child: Text("Daftar"),
          ),
        ],
      );
    },
  );
}

Widget _buildTextField(TextEditingController controller, String label,
    {TextInputType keyboardType = TextInputType.text}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    inputFormatters: [
      // Jika keyboardType adalah number, hanya izinkan angka
      if (keyboardType == TextInputType.number) 
        FilteringTextInputFormatter.digitsOnly,
    ],
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF11B3CF)),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    validator: (value) {
      // Validasi jika input kosong atau tidak sesuai
      if (value == null || value.isEmpty) {
        return 'Field ini tidak boleh kosong';
      }
      // Validasi hanya angka jika keyboardType adalah number
      if (keyboardType == TextInputType.number && int.tryParse(value) == null) {
        return 'Harus berupa angka';
      }
      return null;
    },
  );
}




  Widget _buildHealthyTracker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Healthy Tracker",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF11B3CF))),
        SizedBox(height: 8),
        Container(
          height: 200,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text("${value.toInt()}",
                          style: TextStyle(fontSize: 12));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (value, meta) {
                      return Text("${value.toInt()}",
                          style: TextStyle(fontSize: 12));
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(1, 5),
                    FlSpot(2, 6),
                    FlSpot(3, 4),
                    FlSpot(4, 7),
                    FlSpot(5, 6.5),
                    FlSpot(6, 8),
                    FlSpot(7, 7),
                  ],
                  isCurved: true,
                  color: Colors.blueAccent,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.blueAccent,
                        strokeColor: Colors.white,
                        strokeWidth: 2,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsAndTricks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tips And Trick",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF11B3CF))),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text("Foods Tips And Fungsi",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF11B3CF),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Book"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text("Konten Untuk Ibu Hamil",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF11B3CF),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Click"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMakeAppointment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Buat Pertemuan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF11B3CF))),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 30, backgroundImage: AssetImage('assets/doctor.jpg')),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dr. Rahmat Hariadi",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("General Consultation",
                      style: TextStyle(color: Colors.grey)),
                  Text("10.30 AM - 12.00 AM",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF11B3CF),
                  foregroundColor: Colors.white,
                ),
                child: Text("Chat"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSchedule(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Kalendar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF11B3CF),
              ),
            ),
            IconButton(
              icon: Icon(Icons.calendar_month, color: Color(0xFF11B3CF)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomCalendarPage()),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        EasyDateTimeLine(
          initialDate: DateTime.now(),
          activeColor: Color(0xFF11B3CF),
          onDateChange: (date) {},
          headerProps: EasyHeaderProps(
            showHeader: false,
          ),
          dayProps: EasyDayProps(
            activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                color: Color(0xFF11B3CF),
                borderRadius: BorderRadius.circular(8),
              ),
              dayNumStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              monthStrStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              dayStrStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            inactiveDayStyle: DayStyle(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              dayNumStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              monthStrStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              dayStrStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}