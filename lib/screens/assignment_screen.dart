import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_task_screen.dart';

class AssignmentScreen extends StatefulWidget {
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  List<Map<String, dynamic>> assignments = [];
  List<Map<String, dynamic>> exams = [];
  List<Map<String, dynamic>> quizzes = [];

  @override
  void initState() {
    super.initState();
    _fetchAllTasks();
  }

  void _fetchAllTasks() {
    _fetchTasksForType('Assignment');
    _fetchTasksForType('Exam');
    _fetchTasksForType('Quiz');
  }

  void _fetchTasksForType(String type) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection(type.toLowerCase() + 's').get();
    List<Map<String, dynamic>> fetchedItems = snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id;
      return data;
    }).toList();

    setState(() {
      if (type == 'Assignment') {
        assignments = fetchedItems;
      } else if (type == 'Exam') {
        exams = fetchedItems;
      } else if (type == 'Quiz') {
        quizzes = fetchedItems;
      }
    });
  }

  void _navigateToCreateAssignment() async {
    final newItem = await Navigator.pushNamed(context, '/create_assignment');
    if (newItem != null && newItem is Map<String, dynamic>) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection(newItem['type'].toLowerCase() + 's').add(newItem);
      _fetchTasksForType(newItem['type']);
      _showSnackBarMessage('Successfully created!');
    }
  }

  void _navigateToEditTask(Map<String, dynamic> item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          docId: item['docId'],
          type: item['type'],
          title: item['title'],
          description: item['description'],
          dueDate: item['dueDate'],
          imageUrl: item['imageUrl'],
          reminder: item['reminder'],
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String docId = item['docId'];
      String oldType = item['type'];

      if (result['action'] == 'update') {
        String newType = result['updatedItem']['type'];
        if (oldType != newType) {
          await firestore.collection(oldType.toLowerCase() + 's').doc(docId).delete();
        }
        await firestore.collection(newType.toLowerCase() + 's').doc(docId).set(result['updatedItem']);
        _fetchTasksForType(oldType);
        _fetchTasksForType(newType);
        _showSnackBarMessage('Successfully updated!');
      } else if (result['action'] == 'delete') {
        await firestore.collection(oldType.toLowerCase() + 's').doc(docId).delete();
        _fetchTasksForType(oldType);
        _showSnackBarMessage('Successfully deleted!');
      }
    }
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Assignments & Exams', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue[800],
          bottom: TabBar(
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
            children: [
              _buildTaskList(assignments),
              _buildTaskList(exams),
              _buildTaskList(quizzes),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToCreateAssignment,
          child: Icon(Icons.add),
          backgroundColor: Colors.orangeAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildTaskList(List<Map<String, dynamic>> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final item = tasks[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            title: Text(item['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['description']),
                SizedBox(height: 5),
                Text(
                  DateTime.parse(item['dueDate']).toLocal().toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (item['reminder'] == true)
                  Row(
                    children: [
                      Icon(Icons.notifications, color: Colors.red, size: 16),
                      SizedBox(width: 5),
                      Text('Reminder set', style: TextStyle(fontSize: 12, color: Colors.red)),
                    ],
                  ),
                if (item['imageUrl'] != null && item['imageUrl'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.network(
                      item['imageUrl'],
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
            onTap: () => _navigateToEditTask(item),
          ),
        );
      },
    );
  }
}
