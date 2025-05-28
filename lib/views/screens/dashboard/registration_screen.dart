import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/api_service.dart';
import '../../../models/user_pregnancy.dart';
import '../../../controllers/pregnancy_controller.dart';

class PregnancyRegistrationScreen extends StatefulWidget {
  final Function(PregnancyData) onRegistrationComplete;

  const PregnancyRegistrationScreen({
    Key? key,
    required this.onRegistrationComplete,
  }) : super(key: key);

  @override
  State<PregnancyRegistrationScreen> createState() => _PregnancyRegistrationScreenState();
}


class _PregnancyRegistrationScreenState extends State<PregnancyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pregnancyController = PregnancyController(apiService: ApiService());
  
  int _gravida = 1;    // Changed from _pregnancyCount
  int _para = 0;        // Changed from _childrenCount
  int _abortus = 0;     // Changed from _abortionCount
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    await _pregnancyController.registerPregnancy(
      context: context,
      fullName: _nameController.text.trim(),
      gravida: _gravida,
      para: _para,
      abortus: _abortus,
      startDate: _selectedDate,
      onSuccess: (pregnancyData) {
        widget.onRegistrationComplete(pregnancyData);
        Navigator.pop(context); 
      },
    );
  }
}


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        title: const Text('Registrasi Kehamilan'),
        backgroundColor: const Color(0xFF10B2CF),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [ 
            // Gravida (Pregnancy Count)
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Jumlah Kehamilan:',
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
                          onPressed: _gravida > 1
                              ? () => setState(() => _gravida--)
                              : null,
                        ),
                        Text(
                          '$_gravida',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _gravida++),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Para (Children Count)
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Jumlah Anak:',
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
                          onPressed: _para > 0
                              ? () => setState(() => _para--)
                              : null,
                        ),
                        Text(
                          '$_para',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _para++),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Abortus (Abortion Count)
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Jumlah Aborsi:',
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
                          onPressed: _abortus > 0
                              ? () => setState(() => _abortus--)
                              : null,
                        ),
                        Text(
                          '$_abortus',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _abortus++),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Start Date of Pregnancy
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
                          'Hari Pertama Kehamilan',
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
            
            // Due Date Preview
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
                    'Berdasarkan Tanggal Ini:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Perkiraan Bayi Lahir Adalah: ',
                        style: TextStyle(fontSize: 14),
                      ),
                    
                      Text(
                        DateFormat('dd MMM yyyy').format(
                          _selectedDate.add(const Duration(days: 280)),),
                        style: const TextStyle(
                          fontSize: 14,
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
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B2CF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Daftar',
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