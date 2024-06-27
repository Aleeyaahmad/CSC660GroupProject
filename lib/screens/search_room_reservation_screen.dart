import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'view_room_reservation_screen.dart';
import 'add_room_reservation_screen.dart';

class SearchRoomReservationScreen extends StatefulWidget {
  final String building;
  final String room;

  SearchRoomReservationScreen({required this.building, required this.room});

  @override
  _SearchRoomReservationScreenState createState() => _SearchRoomReservationScreenState();
}

class _SearchRoomReservationScreenState extends State<SearchRoomReservationScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, String>>> _events = {
    DateTime(2024, 2, 1): [
      {
        "subject": "CSC404 TEST I",
        "time": "8:00 am - 10:00 am",
        "lecturer": "AHMAD NAZMI AHMAD FAISAL",
        "type": "Common test"
      },
      {
        "subject": "CSC520 QUIZ",
        "time": "9:00 pm - 11:00 pm",
        "lecturer": "NORMALINA ABDUL RAHIM",
        "type": "Non-common test"
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Reservation'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.building} | ${widget.room}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                _focusedDay = focusedDay;
              });
              _showReservationsForSelectedDay(selectedDay);
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
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              headerMargin: EdgeInsets.only(bottom: 8.0),
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationsForSelectedDay(DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final reservations = _events[selectedDay] ?? [];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Reservations for ${selectedDay.day} ${_getMonthName(selectedDay.month)} ${selectedDay.year}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (reservations.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No reservations for this day.'),
              )
            else
              ...reservations.map((reservation) => ListTile(
                    title: Text(reservation['time']!),
                    subtitle: Text(reservation['subject']!),
                  )),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewRoomReservationScreen(
                      date: '${selectedDay.day} ${_getMonthName(selectedDay.month)} ${selectedDay.year}',
                      reservations: reservations,
                    ),
                  ),
                );
              },
              child: Text('View'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final newReservation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRoomReservationScreen(),
                  ),
                );
                if (newReservation != null) {
                  setState(() {
                    _events[selectedDay] = (_events[selectedDay] ?? [])..add(newReservation);
                  });
                }
              },
              child: Text('Add new time'),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}