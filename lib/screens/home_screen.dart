import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'calender.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController scrollController;

  HomeScreen({required this.scrollController});


  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFFF2F4F7),
    body: SafeArea( // Tambahkan SafeArea di sini
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16.0),
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
          ],
        ),
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
          padding: EdgeInsets.all(8), // Ukuran padding lebih pas
          child: Icon(Icons.pregnant_woman, size: 45, color: Colors.white), // Icon sedikit lebih besar
        ),

        SizedBox(width: 14),

        // Bagian Kanan: Teks dan Tombol
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Mencegah overflow
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Start Your Journey",
                style: TextStyle(
                  fontSize: 20, // Font lebih besar dari sebelumnya
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6), // Jarak antar teks lebih proporsional
              Text(
                "Langkah pertama untuk Si Bayi!",
                style: TextStyle(
                  fontSize: 13, // Font lebih jelas
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
          onPressed: () {},
          child: Text("Start"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Tombol lebih nyaman ditekan
            textStyle: TextStyle(fontSize: 14), // Ukuran teks tombol lebih proporsional
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
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
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.calendar_month, color: Color(0xFF11B3CF)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FullCalendarScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 8),
      EasyDateTimeLine(
        initialDate: DateTime.now(),
        activeColor: Color(0xFF11B3CF),
        onDateChange: (date) {},
        headerProps: EasyHeaderProps(
          showHeader: false, // Sembunyikan teks hari di atas kotak tanggal
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
