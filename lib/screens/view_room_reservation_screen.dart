import 'package:flutter/material.dart';

class ViewRoomReservationScreen extends StatelessWidget {
  final String date;
  final List<Map<String, String>> reservations;

  ViewRoomReservationScreen({required this.date, required this.reservations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                date,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return ReservationTile(
                    subject: reservation['subject']!,
                    time: reservation['time']!,
                    lecturer: reservation['lecturer']!,
                    color: reservation['type'] == 'Common test' ? Colors.blue[100]! : Colors.green[100]!,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add new time logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('+ Add new time'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReservationTile extends StatelessWidget {
  final String subject;
  final String time;
  final String lecturer;
  final Color color;

  ReservationTile({
    required this.subject,
    required this.time,
    required this.lecturer,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 16,
          height: 16,
          color: color,
        ),
        title: Text(subject),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time),
            Text(lecturer),
          ],
        ),
      ),
    );
  }
}
