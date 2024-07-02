import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EditTaskScreen extends StatefulWidget {
  final String docId;
  final String? type;
  final String? title;
  final String? description;
  final String? dueDate;
  final String? imageUrl;
  final bool reminder;

  EditTaskScreen({
    required this.docId,
    this.type,
    this.title,
    this.description,
    this.dueDate,
    this.imageUrl,
    required this.reminder,
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late String _title;
  late String _description;
  late DateTime _dueDate;
  String? _imageUrl;
  late bool _reminder;

  @override
  void initState() {
    super.initState();
    _type = widget.type ?? 'Assignment';
    _title = widget.title ?? '';
    _description = widget.description ?? '';
    _dueDate = widget.dueDate != null ? DateTime.parse(widget.dueDate!) : DateTime.now();
    _imageUrl = widget.imageUrl;
    _reminder = widget.reminder;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final destination = 'files/$fileName';

      try {
        final ref = FirebaseStorage.instance.ref(destination);
        await ref.putFile(file);
        final url = await ref.getDownloadURL();

        setState(() {
          _imageUrl = url;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedItem = {
        'type': _type,
        'title': _title,
        'description': _description,
        'dueDate': _dueDate.toIso8601String(),
        'imageUrl': _imageUrl,
        'reminder': _reminder,
      };

      Navigator.of(context).pop({
        'action': 'update',
        'updatedItem': updatedItem,
      });
    }
  }

  Future<void> _confirmDeleteTask() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this task?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTask();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTask() {
    Navigator.of(context).pop({
      'action': 'delete',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: TextStyle(color: Colors.white), // Change text color to white
        ),
        backgroundColor: Colors.blue[800], // Adjust app bar color
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['Assignment', 'Exam', 'Quiz'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _type = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: DateFormat.yMMMd().format(_dueDate),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _dueDate) {
                      setState(() {
                        _dueDate = pickedDate;
                      });
                    }
                  },
                ),
                SizedBox(height: 10),
                Text('Image', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt, color: Colors.white), // Adjust icon and text color
                      label: Text('Camera', style: TextStyle(color: Colors.white)), // Adjust text color
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800], // Change button color here
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.image, color: Colors.white), // Adjust icon and text color
                      label: Text('Gallery', style: TextStyle(color: Colors.white)), // Adjust text color
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800], // Change button color here
                      ),
                    ),
                  ],
                ),
                if (_imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.network(_imageUrl!, height: 200),
                  ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Reminder?', style: TextStyle(color: Colors.white)),
                    Switch(
                      value: _reminder,
                      onChanged: (value) {
                        setState(() {
                          _reminder = value;
                        });
                      },
                      activeColor: Colors.blue[800], // Adjust switch color
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveTask,
                      child: Text('Update', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800], // Change button color here
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _confirmDeleteTask,
                      child: Text('Delete', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Adjust button color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
