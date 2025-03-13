import 'package:flutter/material.dart';
import 'kesehatan/detail_kesehatan.dart'; 
import 'kesehatan/penyakit.dart'; 
import 'kesehatan/food_tips.dart'; 
import 'kesehatan/olahraga.dart'; 

class KesehatanScreen extends StatelessWidget {
  final ScrollController scrollController;

  KesehatanScreen({required this.scrollController});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
           
          },
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
      body: SingleChildScrollView(  
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHealthSection(
                context: context,
                icon: Icons.health_and_safety_outlined,
                title: 'Health Details',
                description: 'Vital Signs And Physical Examination (Blood Pressure, Weight, Medical History, etc.)',
                destination: DetailKesehatanScreen(),
              ),
              SizedBox(height: 16),
              _buildHealthSection(
                context: context,
                icon: Icons.medical_information_outlined,
                title: 'Disease Information',
                description: 'Symptoms, Causes, Diagnosis, Treatment, Prevention, Risk Factors, Prognosis, and Medical Complications',
                destination: PenyakitScreen(), 
              ),
              SizedBox(height: 16),
              _buildHealthSection(
                context: context,
                icon: Icons.fastfood_outlined,
                title: 'Food Tips',
                description: 'Consumer Selected Meals, Fruits, Vegetables, Nutrition, Calorie Calculations, Healthy Eating, and to Sustain Nutrition',
                destination: FoodScreen(), 
              ),
              SizedBox(height: 16),
              _buildHealthSection(
                context: context,
                icon: Icons.directions_run_outlined,
                title: 'Exercise Tips',
                description: '60 Minutes Of Movement, Activity, Weekly, Workout, Calorie, Strength Training, Diet, Endurance, Flexibility Exercises',
                destination: ExerciseScreen(), 
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Widget? destination,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Color(0xFF11B3CF)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: destination != null 
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => destination,
                      ),
                    );
                  }
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF11B3CF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Click', 
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}