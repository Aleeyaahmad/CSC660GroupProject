import 'package:flutter/material.dart';
import 'search_room_reservation_screen.dart';

class RoomReservationScreen extends StatefulWidget {
  @override
  _RoomReservationScreenState createState() => _RoomReservationScreenState();
}

class _RoomReservationScreenState extends State<RoomReservationScreen> {
  String? _selectedBuilding;
  String? _selectedRoomNumber;
  String? _selectedDate;
  String? _selectedLecturer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Reservation', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800], // Adjusted AppBar color to better match the gradient theme
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[300]!,
              Colors.green[300]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reservation Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Building',
                          labelStyle: TextStyle(color: Colors.black87),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: _selectedBuilding,
                        items: ['Building A', 'Building B', 'Building C'].map((String building) {
                          return DropdownMenuItem<String>(
                            value: building,
                            child: Text(building, style: TextStyle(color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBuilding = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Room Number',
                          labelStyle: TextStyle(color: Colors.black87),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: _selectedRoomNumber,
                        items: ['Room 101', 'Room 102', 'Room 103'].map((String room) {
                          return DropdownMenuItem<String>(
                            value: room,
                            child: Text(room, style: TextStyle(color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedRoomNumber = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Lecturer',
                          labelStyle: TextStyle(color: Colors.black87),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: _selectedLecturer,
                        items: ['Lecturer A', 'Lecturer B', 'Lecturer C'].map((String lecturer) {
                          return DropdownMenuItem<String>(
                            value: lecturer,
                            child: Text(lecturer, style: TextStyle(color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLecturer = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Set Date to Book',
                          labelStyle: TextStyle(color: Colors.black87),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Icon(Icons.calendar_today, color: Colors.black87),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                            });
                          }
                        },
                        readOnly: true,
                        controller: TextEditingController(text: _selectedDate),
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedBuilding != null && _selectedRoomNumber != null && _selectedDate != null && _selectedLecturer != null) {
                        // Save the date logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Reservation saved successfully')),
                        );
                      } else {
                        // Show a message if not all fields are selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Save', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700], // Blue for button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedBuilding != null && _selectedRoomNumber != null && _selectedDate != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchRoomReservationScreen(
                              building: _selectedBuilding!,
                              room: _selectedRoomNumber!,
                            ),
                          ),
                        );
                      } else {
                        // Show a message if not all fields are selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Search', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700], // Green for button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
