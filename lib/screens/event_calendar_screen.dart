import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarScreen extends StatefulWidget {
  @override
  _EventCalendarScreenState createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF64B5F6).withOpacity(0.5), // Light Blue with opacity
              Color(0xFF81C784).withOpacity(0.5), // Light Green with opacity
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
                color: Colors.white, // Keep the title white
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
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
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
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFFFFD54F), // Light Orange
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF4FC3F7), // Light Blue Accent
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
                markerDecoration: BoxDecoration(
                  color: Color(0xFFEF5350), // Light Red
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
            Expanded(
              child: ListView(
                children: [
                  EventTile(
                    icon: Icons.festival,
                    title: 'MEGA CLUB FESTIVAL (MeCFest) 2.0',
                    date: '10:00 - 23:00',
                    color: Colors.pink[100]!,
                  ),
                  EventTile(
                    icon: Icons.restaurant,
                    title: 'Annual Dinner SISKOM',
                    date: '20:00 - 23:00',
                    color: Colors.green[100]!,
                  ),
                  // Add more EventTile widgets as needed
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventScreen()),
          );
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
  final Color color;

  const EventTile({
    required this.icon,
    required this.title,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            date,
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}

class AddEventScreen extends StatelessWidget {
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
            _buildTextField(label: 'Event Name', icon: Icons.event),
            SizedBox(height: 10),
            _buildTextField(label: 'Date', icon: Icons.calendar_today),
            SizedBox(height: 10),
            _buildTextField(label: 'Start Time', icon: Icons.access_time),
            SizedBox(height: 10),
            _buildTextField(label: 'End Time', icon: Icons.access_time),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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

  Widget _buildTextField({required String label, required IconData icon}) {
    return TextField(
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
    );
  }
}
