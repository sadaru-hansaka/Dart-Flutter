import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/main.dart';

import '../models/time_entry.dart';
import '../provider/time_entry_provider.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/add_tasks_dialog.dart';

class AddEntryScreen extends StatefulWidget {
  final TimeEntry? initialEntries;

  const AddEntryScreen({Key? key, this.initialEntries}) : super(key: key);

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  late TextEditingController _timeController;
  late TextEditingController _noteController;
  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController(
        text: widget.initialEntries?.totalTime.toString() ?? '');
    _noteController =
        TextEditingController(text: widget.initialEntries?.notes ?? '');
    _selectedDate = widget.initialEntries?.date ?? DateTime.now();
    _selectedProjectId = widget.initialEntries?.projectId;
    _selectedTaskId = widget.initialEntries?.taskId;
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<TimeEntryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialEntries == null ? 'Add Entries' : 'Edit Entries'),
        backgroundColor: Colors.green[400],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0), // Adjust the padding as needed
              child: buildProjectDropdown(entryProvider),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0), // Adjust the padding as needed
              child: buildTaskDropdown(entryProvider),
            ),
            buildDateField(_selectedDate),
            buildTextField(_timeController, 'Total Time(hrs)',
                TextInputType.numberWithOptions(decimal: true)),
            buildTextField(_noteController, 'Note', TextInputType.text),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 50.0, left: 8.0, right: 8.0, top: 8.0),
        // padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: _saveEntries,
          child: Text('Save Entries'),
        ),
      ),
    );
  }
  // Helper methods for building the form elements go here (omitted for brevity)

  void _saveEntries() {
    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all required fields!')));
      return;
    }

    final entry = TimeEntry(
      id: widget.initialEntries?.id ??
          DateTime.now().toString(), // Assuming you generate IDs like this
      totalTime: double.parse(_timeController.text),
      projectId: _selectedProjectId!,
      notes: _noteController.text,
      date: _selectedDate,
      taskId: _selectedTaskId!,
    );

    // Calling the provider to add or update the expense
    Provider.of<TimeEntryProvider>(context, listen: false)
        .addOrUpdateEntries(entry);
    Navigator.pop(context);
  }

  // Helper method to build a text field
  Widget buildTextField(
      TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: type,
      ),
    );
  }

// Helper method to build the date picker field
  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
      title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

// Helper method to build the category dropdown
  Widget buildProjectDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedProjectId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddProjectDialog(onAdd: (newProject) {
              //-----------------------------------------
              setState(() {
                _selectedProjectId =
                    newProject.id; // Automatically select the new category
                provider.addProjects(
                    newProject); // Add to provider, assuming this method exists
              });
            }),
          );
        } else {
          setState(() => _selectedProjectId = newValue);
        }
      },
      items: provider.project.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList()
        ..add(DropdownMenuItem(
          value: "New",
          child: Text("Add New Project"),
        )),
      decoration: InputDecoration(
        labelText: 'Project',
        border: OutlineInputBorder(),
      ),
    );
  }

// Helper method to build the task dropdown
  Widget buildTaskDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTaskId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(onAdd: (newTask) {
              //--------------------------------------------
              provider
                  .addTasks(newTask); // Assuming you have an `addtask` method.
              setState(() =>
                  _selectedTaskId = newTask.id); // Update selected task ID
            }),
          );
        } else {
          setState(() => _selectedTaskId = newValue);
        }
      },
      items: provider.tasks.map<DropdownMenuItem<String>>((task) {
        return DropdownMenuItem<String>(
          value: task.id,
          child: Text(task.name),
        );
      }).toList()
        ..add(DropdownMenuItem(
          value: "New",
          child: Text("Add New task"),
        )),
      decoration: InputDecoration(
        labelText: 'task',
        border: OutlineInputBorder(),
      ),
    );
  }
}
