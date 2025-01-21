import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'student_model.dart';
import 'student_provider.dart';

class EditStudentScreen extends StatefulWidget {
  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController majorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: majorController,
              decoration: InputDecoration(labelText: 'Major'),
            ),
            ElevatedButton(
              onPressed: () {
                final student = Student(
                  id: DateTime.now()
                      .millisecondsSinceEpoch, // Consider generating unique IDs differently if needed
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  age: int.tryParse(ageController.text) ??
                      0, // Adding error handling for number parsing
                  major: majorController.text,
                );
                Provider.of<StudentProvider>(context, listen: false)
                    .addStudent(student);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
