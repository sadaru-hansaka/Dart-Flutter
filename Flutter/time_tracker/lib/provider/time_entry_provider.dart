import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../models/tasks.dart';
import '../models/time_entry.dart';

import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;

// time entry list
  List<TimeEntry> _entries = [];

  final List<Project> _projects = <Project>[
    Project(id: '1', name: 'Project A', isDefault: true),
    Project(id: '2', name: 'Project B', isDefault: true),
    Project(id: '3', name: 'Project C', isDefault: true),
    Project(id: '4', name: 'Project D', isDefault: true),
  ];

  final List<Task> _tasks = <Task>[
    Task(id: '1', name: 'Task 1'),
    Task(id: '2', name: 'Task 2'),
    Task(id: '3', name: 'Task 3'),
    Task(id: '4', name: 'Task 4'),
    Task(id: '5', name: 'Task 5'),
  ];

  List<TimeEntry> get entry => _entries;
  List<Project> get project => _projects;
  List<Task> get tasks => _tasks;

  TimeEntryProvider(this.storage) {
    _loadTimeEntryfromStorage();
  }

  void _loadTimeEntryfromStorage() async {
    var storedTimeEntries = storage.getItem('entries');
    if (storedTimeEntries != null) {
      _entries = List<TimeEntry>.from(
        (storedTimeEntries as List).map((item) => TimeEntry.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void addEntries(TimeEntry entry) {
    _entries.add(entry);
    _saveEntriestoStorage();
    notifyListeners();
  }

  void _saveEntriestoStorage() {
    storage.setItem(
        'entries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  void addOrUpdateEntries(TimeEntry entry) {
    int index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      // Update existing entry
      _entries[index] = entry;
    } else {
      // Add new entry
      _entries.add(entry);
    }
    _saveEntriestoStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Delete an entry
  void deleteEntries(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntriestoStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Add a projects
  void addProjects(Project project) {
    if (!_projects.any((cat) => cat.name == project.name)) {
      _projects.add(project);
      notifyListeners();
    }
  }

  // Delete a project
  void deleteproject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  // Add a task
  void addTasks(Task task) {
    if (!_tasks.any((t) => t.name == task.name)) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  // Delete a task
  void deleteTasks(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void removeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntriestoStorage(); // Save the updated list to local storage
    notifyListeners();
  }
}
