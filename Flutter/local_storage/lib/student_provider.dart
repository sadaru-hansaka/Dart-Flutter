import 'package:flutter/material.dart';
import 'student_model.dart';
import 'package:localstorage/localstorage.dart';

class StudentProvider with ChangeNotifier {
  final LocalStorage storage;
  List<Student> _students = [];
  List<Student> get students => _students;

  StudentProvider({required this.storage});
  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  void removeStudent(int id) {
    _students.removeWhere((student) => student.id == id);
    notifyListeners();
  }

  void updateStudent(Student updatedStudent) {
    var index =
        _students.indexWhere((student) => student.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
    }
  }

  void deleteStudent(int id) {
    _students.removeWhere((student) => student.id == id);
    notifyListeners();
  }
}
