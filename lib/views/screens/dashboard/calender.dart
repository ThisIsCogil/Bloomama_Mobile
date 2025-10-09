import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/event_model.dart';
import '../../../services/api_service.dart';
import 'package:flutter_animate/flutter_animate.dart';


class CustomCalendarPage extends StatefulWidget {
  @override
  _CustomCalendarPageState createState() => _CustomCalendarPageState();
}

final List<Color> _eventColors = [
  Color(0xFFE3F2FD), // Light Blue
  Color(0xFFE8F5E8), // Light Green
  Color(0xFFFFF3E0), // Light Orange
  Color(0xFFF3E5F5), // Light Purple
  Color(0xFFE0F2F1), // Light Teal
  Color(0xFFFCE4EC), // Light Pink
  Color(0xFFF1F8E9), // Light Lime
  Color(0xFFEDE7F6), // Light Deep Purple
];

final List<Color> _eventAccentColors = [
  Color(0xFF2196F3), // Blue
  Color(0xFF4CAF50), // Green
  Color(0xFFFF9800), // Orange
  Color(0xFF9C27B0), // Purple
  Color(0xFF009688), // Teal
  Color(0xFFE91E63), // Pink
  Color(0xFF8BC34A), // Lime
  Color(0xFF673AB7), // Deep Purple
];

final List<IconData> _eventIcons = [
  Icons.event,
  Icons.meeting_room,
  Icons.work,
  Icons.school,
  Icons.sports_esports,
  Icons.restaurant,
  Icons.fitness_center,
  Icons.music_note,
  Icons.movie,
  Icons.shopping_bag,
  Icons.flight,
  Icons.medical_services,
];

class _CustomCalendarPageState extends State<CustomCalendarPage> {
  final ScrollController _scrollController = ScrollController();
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  List<EventModel> _events = [];
  Map<DateTime, List<EventModel>> _allEvents = {};
  

  @override
  void initState() {
    super.initState();
    _scrollToSelectedDate();
    _loadEventsForMonth(_currentMonth);
    _loadEventsForDate(_selectedDate);
  }

  void _scrollToSelectedDate() {
  final days = _generateDaysInMonth(_currentMonth);
  final today = DateTime.now();
  final todayIndex = days.indexWhere((d) =>
      d.year == today.year && d.month == today.month && d.day == today.day);

  // Estimasi ukuran item + margin
  final double itemWidth = 50 + 8; // lebar item + margin horizontal

  if (todayIndex != -1) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        (todayIndex * itemWidth).toDouble(),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}


  void _loadEventsForMonth(DateTime month) async {
    try {
      // Load events for the entire month to show indicators
      final days = _generateDaysInMonth(month);
      Map<DateTime, List<EventModel>> monthEvents = {};
      
      for (DateTime day in days) {
        final events = await ApiService.fetchEventsByDate(day);
        if (events.isNotEmpty) {
          monthEvents[DateTime(day.year, day.month, day.day)] = events;
        }
      }
      
      setState(() {
        _allEvents = monthEvents;
      });
    } catch (e) {
      print('Error loading month events: $e');
    }
  }

  void _loadEventsForDate(DateTime date) async {
    try {
      final events = await ApiService.fetchEventsByDate(date);
      setState(() {
        _events = events;
      });
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  List<DateTime> _generateDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    return List.generate(
        daysInMonth, (index) => firstDay.add(Duration(days: index)));
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month + delta, 1);
    });
    _loadEventsForMonth(_currentMonth);
  }

  bool _hasEventsOnDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _allEvents.containsKey(dateKey) && _allEvents[dateKey]!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateDaysInMonth(_currentMonth);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        children: [
          // Header bulan & timeline
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              bottom: 20,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left, size: 30),
                        onPressed: () => _changeMonth(-1),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      SizedBox(width: 8),
                      Text(
                        DateFormat('MMMM yyyy').format(_currentMonth),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11B3CF),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.chevron_right, size: 30),
                        onPressed: () => _changeMonth(1),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      final isSelected = _selectedDate.year == day.year &&
                          _selectedDate.month == day.month &&
                          _selectedDate.day == day.day;
                      final isToday = DateTime.now().year == day.year &&
                          DateTime.now().month == day.month &&
                          DateTime.now().day == day.day;
                      final hasEvents = _hasEventsOnDate(day);
                        return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = day;
                          });
                          _loadEventsForDate(day);
                        },
                        child: Container(
                          width: 50,
                          height: 70,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFF11B3CF) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: isToday
                                ? Border.all(color: Color(0xFF11B3CF), width: 2)
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.E().format(day),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: hasEvents
                                      ? (isSelected ? Colors.white : Color(0xFF11B3CF))
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ).animate(
                          effects: [
                            FadeEffect(duration: 300.ms),
                            SlideEffect(
                              duration: 300.ms,
                              curve: Curves.easeOut,
                              begin: Offset(0, 0.2),
                              end: Offset.zero,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),

          // Event list dengan design yang diperbaiki
          SizedBox(height: 20), // Memberikan jarak dari kalender
          
          Expanded(
            child: _events.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.event_note, 
                            size: 40, 
                            color: Colors.grey.shade400
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No events scheduled',
                          style: TextStyle(
                            color: Colors.grey.shade600, 
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your calendar is free for ${DateFormat('MMMM d').format(_selectedDate)}',
                          style: TextStyle(
                            color: Colors.grey.shade500, 
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: 8),
                            itemCount: _events.length,
                            itemBuilder: (context, index) {
                              final event = _events[index];
                              final colorIndex = index % _eventColors.length;
                              final backgroundColor = _eventColors[colorIndex];
                              final accentColor = _eventAccentColors[colorIndex];
                              final icon = _eventIcons[index % _eventIcons.length];
                              
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: accentColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: accentColor.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          icon,
                                          color: accentColor,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (event.description.isNotEmpty) ...[
                                              SizedBox(height: 4),
                                              Text(
                                                event.description,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                            SizedBox(height: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: accentColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.access_time, size: 14, color: accentColor),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    '${DateFormat.Hm().format(event.startDateTime)} - ${DateFormat.Hm().format(event.endDateTime)}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: accentColor,
                                                      fontWeight: FontWeight.w500,
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
                              ).animate().fade(duration: 500.ms).slideY(begin: 0.1, curve: Curves.easeOut);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}