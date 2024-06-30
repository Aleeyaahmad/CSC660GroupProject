import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EventCalendarScreen(),
    );
  }
}

class Event {
  final String eventName;
  final DateTime date;
  final String startTime;
  final String endTime;

  Event({
    required this.eventName,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventName: map['eventName'],
      date: DateTime.parse(map['date']),
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}

class EventCalendarScreen extends StatefulWidget {
  @override
  _EventCalendarScreenState createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};
  List<Event> _selectedEvents = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    QuerySnapshot snapshot = await _firestore.collection('events').get();
    Map<DateTime, List<Event>> events = {};
    for (var doc in snapshot.docs) {
      Event event = Event.fromMap(doc.data() as Map<String, dynamic>);
      DateTime eventDate = DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (events[eventDate] == null) {
        events[eventDate] = [];
      }
      events[eventDate]!.add(event);
    }
    setState(() {
      _events = events;
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  Future<void> _addEvent(Event event) async {
    await _firestore.collection('events').add(event.toMap());
    setState(() {
      DateTime eventDate = DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[eventDate] == null) {
        _events[eventDate] = [];
      }
      _events[eventDate]!.add(event);
      if (_selectedDay == eventDate) {
        _selectedEvents = _events[eventDate]!;
      }
    });
  }

  Future<void> _deleteEvent(Event event) async {
    QuerySnapshot snapshot = await _firestore
        .collection('events')
        .where('eventName', isEqualTo: event.eventName)
        .where('date', isEqualTo: event.date.toIso8601String())
        .where('startTime', isEqualTo: event.startTime)
        .where('endTime', isEqualTo: event.endTime)
        .get();

    for (var doc in snapshot.docs) {
      await _firestore.collection('events').doc(doc.id).delete();
    }

    setState(() {
      DateTime eventDate = DateTime.utc(event.date.year, event.date.month, event.date.day);
      _events[eventDate]?.remove(event);
      if (_events[eventDate]?.isEmpty ?? true) {
        _events.remove(eventDate);
      }
      if (_selectedDay == eventDate) {
        _selectedEvents = _events[eventDate] ?? [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF64B5F6).withOpacity(0.5),
              Color(0xFF81C784).withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Text(
              'Event Calendar',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 3.0,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: _getEventsForDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents = _getEventsForDay(selectedDay);
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFFFFD54F),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF4FC3F7),
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
                markerDecoration: BoxDecoration(
                  color: Color(0xFFEF5350),
                  shape: BoxShape.circle,
                ),
                markersAlignment: Alignment.bottomCenter,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                headerPadding: EdgeInsets.symmetric(vertical: 16.0),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedEvents.length,
                itemBuilder: (context, index) {
                  return EventTile(
                    icon: Icons.event,
                    title: _selectedEvents[index].eventName,
                    date:
                        '${_selectedEvents[index].date.day}/${_selectedEvents[index].date.month}/${_selectedEvents[index].date.year}',
                    startTime: _selectedEvents[index].startTime,
                    endTime: _selectedEvents[index].endTime,
                    color: Colors.blue[100]!,
                    onDelete: () {
                      _deleteEvent(_selectedEvents[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Event? newEvent = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddEventScreen(selectedDate: _selectedDay ?? DateTime.now())),
          );

          if (newEvent != null) {
            _addEvent(newEvent);
          }
        },
        backgroundColor: Color(0xFF81C784),
        child: Icon(Icons.add),
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final Color color;
  final VoidCallback onDelete;

  const EventTile({
    required this.icon,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.black87),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: $date', style: TextStyle(color: Colors.black87)),
              Text('Start Time: $startTime', style: TextStyle(color: Colors.black87)),
              Text('End Time: $endTime', style: TextStyle(color: Colors.black87)),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}

class AddEventScreen extends StatefulWidget {
  final DateTime selectedDate;

  AddEventScreen({required this.selectedDate});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Event'),
        backgroundColor: Color(0xFF81C784),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              label: 'Event Name',
              icon: Icons.event,
              controller: eventNameController,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Date',
                    icon: Icons.calendar_today,
                    controller: null,
                    initialValue:
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    enabled: false,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildTextField(
              label: 'Start Time',
              icon: Icons.access_time,
              controller: startTimeController,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  startTimeController.text = pickedTime.format(context);
                }
              },
            ),
            SizedBox(height: 10),
            _buildTextField(
              label: 'End Time',
              icon: Icons.access_time,
              controller: endTimeController,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  endTimeController.text = pickedTime.format(context);
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String eventName = eventNameController.text;
                String startTime = startTimeController.text;
                String endTime = endTimeController.text;

                if (eventName.isNotEmpty &&
                    startTime.isNotEmpty &&
                    endTime.isNotEmpty) {
                  Navigator.pop(
                    context,
                    Event(
                      eventName: eventName,
                      date: _selectedDate,
                      startTime: startTime,
                      endTime: endTime,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF81C784),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                'Add Event',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextEditingController? controller,
    String? initialValue,
    bool enabled = true,
    Function()? onTap,
  }) {
    return TextField(
      controller:
          controller != null ? controller : TextEditingController(text: initialValue),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: Colors.black87),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.black87),
      enabled: enabled,
      onTap: onTap,
      readOnly: onTap != null,
    );
  }

  @override
  void dispose() {
    eventNameController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }
}
