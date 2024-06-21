import 'package:flutter/material.dart';
import 'edit_task_screen.dart'; // Add this import

class AssignmentScreen extends StatefulWidget {
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToEditTask(String type, String title, String description, String dueDate, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          type: type,
          title: title,
          description: description,
          dueDate: dueDate,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments & Exams', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800], // Use the same blue as RoomReservationScreen for consistency
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orangeAccent, // Orange indicator for tabs
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
        onPressed: () {
          Navigator.pushNamed(context, '/create_assignment');
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.orangeAccent, // Orange color for FAB
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAssignmentList() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        _buildListItem('Assignment #1', 'Description for Assignment #1', '30/5/2024', 'image_url_1'),
        _buildListItem('Assignment #2', 'Description for Assignment #2', '31/5/2024', 'image_url_2'),
        _buildListItem('Assignment #3', 'Description for Assignment #3', '1/6/2024', 'image_url_3'),
        _buildListItem('Assignment #4', 'Description for Assignment #4', '2/6/2024', 'image_url_4'),
        _buildListItem('Assignment #5', 'Description for Assignment #5', '3/6/2024', 'image_url_5'),
        // Add more list items as needed
      ],
    );
  }

  Widget _buildExamList() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        _buildListItem('Exam #1', 'Description for Exam #1', '4/6/2024', 'image_url_1'),
        _buildListItem('Exam #2', 'Description for Exam #2', '5/6/2024', 'image_url_2'),
        // Add more list items as needed
      ],
    );
  }

  Widget _buildQuizList() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        _buildListItem('Quiz #1', 'Description for Quiz #1', '6/6/2024', 'image_url_1'),
        _buildListItem('Quiz #2', 'Description for Quiz #2', '7/6/2024', 'image_url_2'),
        // Add more list items as needed
      ],
    );
  }

  Widget _buildListItem(String title, String description, String date, String imageUrl) {
    return GestureDetector(
      onTap: () {
        _navigateToEditTask('Task', title, description, date, imageUrl);
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
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 5),
            Text(description, style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 5),
            Text(date, style: TextStyle(fontSize: 12, color: Colors.black45)),
          ],
        ),
      ),
    );
  }
}
