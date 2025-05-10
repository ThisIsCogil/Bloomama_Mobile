import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// For filename consistency, save this file as 'registration_screen.dart'

class PregnancyRegistrationScreen extends StatefulWidget {
  final Function(PregnancyData) onRegistrationComplete;

  const PregnancyRegistrationScreen({
    Key? key,
    required this.onRegistrationComplete,
  }) : super(key: key);

  @override
  State<PregnancyRegistrationScreen> createState() => _PregnancyRegistrationScreenState();
}

class PregnancyData {
  final String fullName;
  final int pregnancyCount;
  final int childrenCount;
  final int abortionCount;
  final DateTime firstDayOfPregnancy;
  
  // Calculated fields
  final DateTime dueDate;
  final int currentWeeks;
  final int currentDays;
  final String trimester;
  final int totalDays;

  PregnancyData({
    required this.fullName,
    required this.pregnancyCount,
    required this.childrenCount,
    required this.abortionCount,
    required this.firstDayOfPregnancy,
    required this.dueDate,
    required this.currentWeeks,
    required this.currentDays,
    required this.trimester,
    required this.totalDays,
  });

  // Factory method to create the pregnancy data and calculate dates
  factory PregnancyData.calculate({
    required String fullName,
    required int pregnancyCount,
    required int childrenCount,
    required int abortionCount,
    required DateTime firstDayOfPregnancy,
  }) {
    // Calculate due date (280 days or 40 weeks from first day)
    final dueDate = firstDayOfPregnancy.add(const Duration(days: 280));
    
    // Calculate current pregnancy progress
    final today = DateTime.now();
    final differenceInDays = today.difference(firstDayOfPregnancy).inDays;
    
    // Calculate weeks and remaining days
    final currentWeeks = differenceInDays ~/ 7;
    final currentDays = differenceInDays % 7;
    
    // Determine trimester
    String trimester;
    if (currentWeeks < 13) {
      trimester = "First trimester";
    } else if (currentWeeks < 27) {
      trimester = "Second trimester";
    } else {
      trimester = "Third trimester";
    }

    return PregnancyData(
      fullName: fullName,
      pregnancyCount: pregnancyCount,
      childrenCount: childrenCount,
      abortionCount: abortionCount,
      firstDayOfPregnancy: firstDayOfPregnancy,
      dueDate: dueDate,
      currentWeeks: currentWeeks,
      currentDays: currentDays, 
      trimester: trimester,
      totalDays: differenceInDays,
    );
  }
}

class _PregnancyRegistrationScreenState extends State<PregnancyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  int _pregnancyCount = 1;
  int _childrenCount = 0;
  int _abortionCount = 0;
  DateTime _selectedDate = DateTime.now(); // Default to today's date
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create and calculate pregnancy data
      final pregnancyData = PregnancyData.calculate(
        fullName: _nameController.text.trim(),
        pregnancyCount: _pregnancyCount,
        childrenCount: _childrenCount,
        abortionCount: _abortionCount,
        firstDayOfPregnancy: _selectedDate,
      );
      
      // Call the callback function with the calculated data
      widget.onRegistrationComplete(pregnancyData);
      
      // Navigate back
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Always use today's date as initialDate when opening picker
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'SELECT FIRST DAY OF PREGNANCY',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF10B2CF),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10B2CF),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy Registration'),
        backgroundColor: const Color(0xFF10B2CF),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [ 
            // Full Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            
            // Pregnancy Count
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Number of Pregnancies:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _pregnancyCount > 1
                              ? () => setState(() => _pregnancyCount--)
                              : null,
                        ),
                        Text(
                          '$_pregnancyCount',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _pregnancyCount++),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Children Count
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Number of Children:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _childrenCount > 0
                              ? () => setState(() => _childrenCount--)
                              : null,
                        ),
                        Text(
                          '$_childrenCount',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _childrenCount++),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Abortion Count
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Number of Abortions:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _abortionCount > 0
                              ? () => setState(() => _abortionCount--)
                              : null,
                        ),
                        Text(
                          '$_abortionCount',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _abortionCount++),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // First Day of Pregnancy
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'First Day of Pregnancy',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMMM yyyy').format(_selectedDate),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Preview of due date based on selected date
           Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue[50],
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Based on this date:',
        style: TextStyle(
          fontSize: 12, // Ukuran font lebih kecil
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          const Text(
            'Estimated Due Date: ',
            style: TextStyle(
              fontSize: 14, // Ukuran font lebih kecil
            ),
          ),
          Text(
            DateFormat('dd MMM yyyy').format(
              _selectedDate.add(const Duration(days: 280)),
            ),
            style: const TextStyle(
              fontSize: 14, // Ukuran font lebih kecil
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B2CF),
            ),
          ),
        ],
      ),
    ],
  ),
),
            const SizedBox(height: 32),
            
            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B2CF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}