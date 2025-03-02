import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/time_entry_provider.dart';
import '../widgets/add_tasks_dialog.dart';

class TaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Tags"),
        backgroundColor:
        Colors.green, // Themed color similar to your inspirations
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final tag = provider.tasks[index];
              return ListTile(
                title: Text(tag.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete the tag
                    provider.deleteTasks(tag.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              onAdd: (newTag) {
                Provider.of<TimeEntryProvider>(context, listen: false)
                    .addTasks(newTag);
                Navigator.pop(
                    context); // Close the dialog after adding the new tag
              },
            ),
          );
        },
        tooltip: 'Add New Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
