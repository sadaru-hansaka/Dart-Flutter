import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_student_screen.dart';
import 'student_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.students.length,
            itemBuilder: (context, index) {
              final student = provider.students[index];
              return Dismissible(
                key: Key(student.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  provider.deleteStudent(student.id);
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Delete', style: TextStyle(color: Colors.white)),
                      Icon(Icons.delete, color: Colors.white),
                    ],
                  ),
                ),
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('${student.firstName} ${student.lastName}'),
                    subtitle:
                        Text('Age: ${student.age} - Major: ${student.major}'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditStudentScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
