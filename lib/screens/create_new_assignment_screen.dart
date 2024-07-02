import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class CreateNewAssignmentScreen extends StatefulWidget {
  @override
  _CreateNewAssignmentScreenState createState() => _CreateNewAssignmentScreenState();
}

class _CreateNewAssignmentScreenState extends State<CreateNewAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _type;
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now();
  String? _imageUrl;
  bool _reminder = false;
  File? _imageFile;
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dueDateController.text = _dueDate.toIso8601String();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = _dueDate.toIso8601String();
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(image);
      final taskSnapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> _saveToFirestore(Map<String, dynamic> newItem) async {
    await FirebaseFirestore.instance.collection('assignments').add(newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Task', style: TextStyle(color: Colors.white)),
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
                      _type = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
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
                  controller: _dueDateController,
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
                  onTap: () {
                    _selectDueDate(context);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a due date';
                    }
                    return null;
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
                if (_imageFile != null)
                  Image.file(_imageFile!, height: 200),
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
                      activeColor: Colors.blue[800], // Change switch color here
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_imageFile != null) {
                        _imageUrl = await _uploadImage(_imageFile!) ?? '';
                      }
                      final newItem = {
                        'type': _type ?? 'Assignment',
                        'title': _title,
                        'description': _description,
                        'dueDate': _dueDate.toIso8601String(),
                        'imageUrl': _imageUrl ?? '',
                        'reminder': _reminder,
                      };
                      await _saveToFirestore(newItem);

                      // Show Snackbar to confirm creation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Successfully created!'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Navigate back to previous screen
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Create', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800], // Change button color here
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
