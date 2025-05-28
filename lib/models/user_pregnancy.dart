class PregnancyData {
  final String fullName;
  final int gravida;
  final int para;
  final int abortus;
  final DateTime startDate;
  final DateTime dueDate;
  final int pregnancyWeek;
  final String status;
  final int? pregnancyId; // Add this field
  
  // Calculated fields
  final int currentWeeks;
  final int currentDays;
  final String trimester;
  final int totalDays;

  PregnancyData({
    required this.fullName,
    required this.gravida,
    required this.para,
    required this.abortus,
    required this.startDate,
    required this.dueDate,
    required this.pregnancyWeek,
    required this.status,
    this.pregnancyId, // Add to constructor
    required this.currentWeeks,
    required this.currentDays,
    required this.trimester,
    required this.totalDays,
  });

  factory PregnancyData.calculate({
    required String fullName,
    required int gravida,
    required int para,
    required int abortus,
    required DateTime startDate,
    int? pregnancyId,
    String status = 'active',
  }) {
    final dueDate = startDate.add(const Duration(days: 280));
    final today = DateTime.now();
    final differenceInDays = today.difference(startDate).inDays;
    final currentWeeks = differenceInDays ~/ 7;
    final currentDays = differenceInDays % 7;
    
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
      gravida: gravida,
      para: para,
      abortus: abortus,
      startDate: startDate,
      dueDate: dueDate,
      pregnancyWeek: currentWeeks,
      status: status,
      pregnancyId: pregnancyId,
      currentWeeks: currentWeeks,
      currentDays: currentDays,
      trimester: trimester,
      totalDays: differenceInDays,
    );
  }


  // Convert to JSON for API request
  Map<String, dynamic> toApiJson() {
    return {
      'gravida': gravida,
      'para': para,
      'abortus': abortus,
      'start_date': startDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'pregnancy_week': pregnancyWeek,
      'status': status,
    };
  }

  double get progressPercentage {
    final totalDays = dueDate.difference(startDate).inDays;
    final passedDays = DateTime.now().difference(startDate).inDays;
    return (passedDays / totalDays).clamp(0.0, 1.0);
  }

  // Tambahkan method untuk mendapatkan minggu dan hari saat ini
  String get currentWeekAndDay {
    final daysPassed = DateTime.now().difference(startDate).inDays;
    final weeks = daysPassed ~/ 7;
    final days = daysPassed % 7;
    return '$weeks weeks, $days days';
  }

  // Update factory method untuk handle data dari API
// Update method fromApiJson di class PregnancyData
// Update method fromApiJson di class PregnancyData
factory PregnancyData.fromApiJson(Map<String, dynamic> json) {
  try {
    print('Parsing PregnancyData from API JSON: $json');
    
    final startDate = DateTime.parse(json['start_date']);
    final dueDate = DateTime.parse(json['due_date']);
    final pregnancyWeek = json['pregnancy_week'] ?? 0;
    
    // Calculate current weeks and days
    final today = DateTime.now();
    final differenceInDays = today.difference(startDate).inDays;
    final currentWeeks = differenceInDays ~/ 7;
    final currentDays = differenceInDays % 7;
    
    // Get user name from nested user object
    final userName = json['user']?['full_name'] ?? 'User';
    
    print('Parsed dates - Start: $startDate, Due: $dueDate');
    print('Calculated weeks: $currentWeeks, days: $currentDays');

    return PregnancyData(
      fullName: userName,
      gravida: json['gravida'] ?? 1,
      para: json['para'] ?? 0,
      abortus: json['abortus'] ?? 0,
      startDate: startDate,
      dueDate: dueDate,
      pregnancyWeek: currentWeeks, // Use calculated weeks instead of stored weeks
      status: json['status'] ?? 'active',
      pregnancyId: json['id'],
      currentWeeks: currentWeeks,
      currentDays: currentDays,
      trimester: _calculateTrimester(currentWeeks),
      totalDays: differenceInDays,
    );
  } catch (e) {
    print('Error in PregnancyData.fromApiJson: $e');
    print('JSON that failed to parse: $json');
    rethrow;
  }
}
  static String _calculateTrimester(int weeks) {
    if (weeks < 13) return "First trimester";
    if (weeks < 27) return "Second trimester";
    return "Third trimester";
  }

  static Future<PregnancyData?> fromJson(response) async {}
}