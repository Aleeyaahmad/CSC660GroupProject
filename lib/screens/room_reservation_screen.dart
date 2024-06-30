import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Map<String, String>> _reservations = []; // Store reservations locally

  final CollectionReference _reservationsCollection =
      FirebaseFirestore.instance.collection('reservations');

  @override
  void initState() {
    super.initState();
    // Load existing reservations when the screen initializes
    _loadReservations();
  }

  // Method to load reservations from Firestore
  void _loadReservations() async {
  try {
    final querySnapshot = await _reservationsCollection.get();
    setState(() {
      _reservations = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'building': data['building'] as String,
          'room': data['room'] as String,
          'date': data['date'] as String,
          'lecturer': data['lecturer'] as String,
        };
      }).toList();
    });
  } catch (e) {
    print('Error fetching reservations: $e');
    setState(() {
      _reservations = []; // Ensure _reservations is initialized
    });
  }
}

  // Define room options based on selected building
  List<String> getRoomOptions(String building) {
    switch (building) {
      case 'Building A':
        return ['A3-1', 'A3-2', 'A3-3', 'A3-4', 'Library'];
      case 'Building B':
        return ['MK-B1', 'MK-B2', 'MK-B3', 'MK-B4', 'B3-1', 'B3-2', 'B3-3', 'B3-4'];
      case 'Building C':
        return ['MK-C1', 'MK-C2', 'MK-C3', 'MK-C4', 'C3-1', 'C3-2', 'C3-3', 'C3-4', 'Dewan Akademik'];
      case 'Building D':
        return ['MK-D1', 'MK-D2', 'MK-D3', 'MK-D4', 'D3-1', 'D3-2', 'D3-3', 'D3-4'];
      case 'Building E':
        return ['MK-E1', 'MK-E2', 'MK-E3', 'MK-E4'];
      default:
        return [];
    }
  }

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
                        items: ['Building A', 'Building B', 'Building C', 'Building D', 'Building E'].map((String building) {
                          return DropdownMenuItem<String>(
                            value: building,
                            child: Text(building, style: TextStyle(color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBuilding = newValue;
                            // Reset room selection when building changes
                            _selectedRoomNumber = null;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      if (_selectedBuilding != null)
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
                          items: getRoomOptions(_selectedBuilding!).map((String room) {
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
                        items: [
                          'EN. ZAWAWI BIN ISMAIL @ ABDUL WAHAB',
                          'EN. MUHAMMAD ATIF BIN RAMLAN',
                          'TS. DR. HASIAH BINTI MOHAMED @ OMAR',
                          'PN. NOR JAWANEES BINTI AHMAD HANAFIAH',
                          'EN. AHMAD FAKRULAZIZI BIN ABU BAKAR',
                          'EN. AHMAD ISMAIL BIN MOHD ANUAR'
                        ].map((String lecturer) {
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
                      if (_selectedBuilding != null &&
                          _selectedRoomNumber != null &&
                          _selectedDate != null &&
                          _selectedLecturer != null) {
                        // Check for duplicate reservations
                        bool isDuplicate = _reservations.any((reservation) =>
                            reservation['building'] == _selectedBuilding &&
                            reservation['room'] == _selectedRoomNumber &&
                            reservation['date'] == _selectedDate);

                        if (isDuplicate) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Duplicate Reservation'),
                                content: Text('This reservation already exists.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          _reservationsCollection.add({
                            'building': _selectedBuilding!,
                            'room': _selectedRoomNumber!,
                            'date': _selectedDate!,
                            'lecturer': _selectedLecturer!,
                          }).then((value) {
                            setState(() {
                              _reservations.add({
                                'building': _selectedBuilding!,
                                'room': _selectedRoomNumber!,
                                'date': _selectedDate!,
                                'lecturer': _selectedLecturer!,
                              });
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Reservation saved successfully')),
                            );
                          }).catchError((error) {
                            print('Failed to add reservation: $error');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to save reservation')),
                            );
                          });
                        }
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
                      if (_selectedBuilding != null &&
                          _selectedRoomNumber != null &&
                          _selectedDate != null) {
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
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = _reservations[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Building: ${reservation['building']}", style: TextStyle(color: Colors.black87)),
                              Text("Room: ${reservation['room']}", style: TextStyle(color: Colors.black87)),
                              Text("Date: ${reservation['date']}", style: TextStyle(color: Colors.black87)),
                              Text("Lecturer: ${reservation['lecturer']}", style: TextStyle(color: Colors.black87)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
