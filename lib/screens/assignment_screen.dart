import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_task_screen.dart';

class AssignmentScreen extends StatefulWidget {
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> assignments = [];
  List<Map<String, dynamic>> exams = [];
  List<Map<String, dynamic>> quizzes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchTasksFromFirestore();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTasksFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch assignments
    QuerySnapshot assignmentSnapshot = await firestore.collection('assignments').get();
    List<Map<String, dynamic>> fetchedAssignments = assignmentSnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id;
      return data;
    }).toList();

    // Fetch exams
    QuerySnapshot examSnapshot = await firestore.collection('exams').get();
    List<Map<String, dynamic>> fetchedExams = examSnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id;
      return data;
    }).toList();

    // Fetch quizzes
    QuerySnapshot quizSnapshot = await firestore.collection('quizzes').get();
    List<Map<String, dynamic>> fetchedQuizzes = quizSnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id;
      return data;
    }).toList();

    setState(() {
      assignments = fetchedAssignments;
      exams = fetchedExams;
      quizzes = fetchedQuizzes;
    });
  }

  void _navigateToCreateAssignment() async {
    final newItem = await Navigator.pushNamed(context, '/create_assignment');
    if (newItem != null && newItem is Map<String, dynamic>) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection(newItem['type'].toLowerCase() + 's').add(newItem);
      _fetchTasksFromFirestore();
      _showSnackBarMessage('Successfully created!');
    }
  }

  void _navigateToEditTask(Map<String, dynamic> item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          type: item['type'],
          title: item['title'],
          description: item['description'],
          dueDate: item['dueDate'],
          imageUrl: item['imageUrl'],
          reminder: item['reminder'],
        ),
      ),
    );

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String docId = item['docId'];

    if (result != null && result is Map<String, dynamic>) {
      await firestore.collection(result['type'].toLowerCase() + 's').doc(docId).set(result);
      _fetchTasksFromFirestore();
      _showSnackBarMessage('Successfully updated!');
    } else if (result == 'delete') {
      await firestore.collection(item['type'].toLowerCase() + 's').doc(docId).delete();
      _fetchTasksFromFirestore();
      _showSnackBarMessage('Successfully deleted!');
    }
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildAssignmentList() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: assignments.map((assignment) {
        return _buildListItem(assignment);
      }).toList(),
    );
  }

  Widget _buildExamList() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: exams.map((exam) {
        return _buildListItem(exam);
      }).toList(),
    );
  }

  Widget _buildQuizList() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: quizzes.map((quiz) {
        return _buildListItem(quiz);
      }).toList(),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        _navigateToEditTask(item);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              spreadRadius: 2.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['title'],
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            SizedBox(height: 5),
            Text(item['description'],
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 5),
            Text(item['dueDate'],
                style: TextStyle(fontSize: 12, color: Colors.black45)),
            SizedBox(height: 5),
            if (item['imageUrl'] != null && item['imageUrl'].isNotEmpty)
              Container(
                height: 100.0, // set your desired height
                width: 100.0,  // set your desired width
                child: Image.network(
                  item['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            if (item['reminder'] == true)
              Text('Reminder set',
                  style: TextStyle(fontSize: 12, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments & Exams', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orangeAccent,
          tabs: [
            Tab(text: 'Assignments'),
            Tab(text: 'Exams'),
            Tab(text: 'Quizzes'),
          ],
        ),
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
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAssignmentList(),
            _buildExamList(),
            _buildQuizList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateAssignment,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.orangeAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
