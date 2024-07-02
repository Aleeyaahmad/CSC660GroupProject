import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRoomReservationScreen extends StatefulWidget {
  final String selectedBuilding;
  final String selectedRoomNumber;
  final String selectedDate;

  SearchRoomReservationScreen({
    required this.selectedBuilding,
    required this.selectedRoomNumber,
    required this.selectedDate, required String room, required String building, required String date,
  });

  @override
  _SearchRoomReservationScreenState createState() => _SearchRoomReservationScreenState();
}

class _SearchRoomReservationScreenState extends State<SearchRoomReservationScreen> {
  List<Map<String, dynamic>> _searchResults = [];

  final CollectionReference _reservationsCollection =
      FirebaseFirestore.instance.collection('reservations');

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  void _performSearch() async {
    try {
      final querySnapshot = await _reservationsCollection
          .where('building', isEqualTo: widget.selectedBuilding)
          .where('room', isEqualTo: widget.selectedRoomNumber)
          .where('date', isEqualTo: widget.selectedDate)
          .get();

      setState(() {
        _searchResults = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    } catch (e) {
      print('Error searching reservations: $e');
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
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
          child: _searchResults.isEmpty
              ? Center(
                  child: Text(
                    'No reservations found for the selected criteria.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final reservation = _searchResults[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          'Building: ${reservation['building']}',
                          style: TextStyle(color: Colors.black87),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Room: ${reservation['room']}',
                              style: TextStyle(color: Colors.black87),
                            ),
                            Text(
                              'Date: ${reservation['date']}',
                              style: TextStyle(color: Colors.black87),
                            ),
                            Text(
                              'Lecturer: ${reservation['lecturer']}',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
