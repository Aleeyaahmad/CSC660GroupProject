import 'package:flutter/material.dart';

class AddRoomReservationScreen extends StatefulWidget {
  @override
  _AddRoomReservationScreenState createState() => _AddRoomReservationScreenState();
}

class _AddRoomReservationScreenState extends State<AddRoomReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _roomName;
  String? _date;
  String? _startTime;
  String? _endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Room Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Room Name/Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter room name/number';
                  }
                  _roomName = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date';
                  }
                  _date = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Start Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start time';
                  }
                  _startTime = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'End Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter end time';
                  }
                  _endTime = value;
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'roomName': _roomName,
                      'date': _date,
                      'startTime': _startTime,
                      'endTime': _endTime,
                    });
                  }
                },
                child: Text('Confirm Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
