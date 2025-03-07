import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailKesehatanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Health Details', 
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {

              
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Healthy Tracker',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 150,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 3),
                                    FlSpot(1, 5),
                                    FlSpot(2, 4),
                                    FlSpot(3, 7),
                                    FlSpot(4, 6),
                                    FlSpot(5, 8),
                                    FlSpot(6, 5),
                                    FlSpot(7, 7),
                                    FlSpot(8, 6),
                                  ],
                                  isCurved: true,
                                  color: Color(0xFF11B3CF),
                                  barWidth: 3,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Color(0xFF11B3CF).withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Blood Type and Rh Factor',
                  description: 'Determines blood type and Rh compatibility to prevent potential complications during pregnancy.',
                  date: 'First Trimester Screening',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Hemoglobin and Anemia Test',
                  description: 'Checks for iron deficiency and anemia, crucial for maternal and fetal health.',
                  date: 'Regular Monitoring Throughout Pregnancy',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Gestational Diabetes Screening',
                  description: 'Identifies high blood sugar levels that can develop during pregnancy, affecting mother and baby.',
                  date: '24-28 Weeks of Pregnancy',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'STI Screening',
                  description: 'Comprehensive test for sexually transmitted infections that could impact pregnancy and newborn health.',
                  date: 'Early Pregnancy Checkup',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Thyroid Function Test',
                  description: 'Evaluates thyroid hormone levels, which are critical for fetal brain development and maternal health.',
                  date: 'First and Second Trimester',
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard({
    required String title,
    required String description,
    required String date,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF11B3CF),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
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