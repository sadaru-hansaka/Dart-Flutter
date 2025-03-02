import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/time_entry_provider.dart';
import '../widgets/add_project_dialog.dart';

// Example for CategoryManagementScreen
class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage project"),
        backgroundColor:
        Colors.green, // Themed color similar to your inspirations
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.project.length,
            itemBuilder: (context, index) {
              final category = provider.project[index];
              return ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteproject(category.id);
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
            builder: (context) => AddProjectDialog(
              onAdd: (newCategory) {
                Provider.of<TimeEntryProvider>(context, listen: false)
                    .addProjects(newCategory);
                Navigator.pop(context); // Close the dialog
              },
            ),
          );
        },
        tooltip: 'Add New Project',
        child: Icon(Icons.add),
      ),
    );
  }
}
