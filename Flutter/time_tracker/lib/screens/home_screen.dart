import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/time_entry_provider.dart';

import '../screens/add_entries_screen.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/add_tasks_dialog.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../models/time_entry.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "By Tasks"),
            Tab(text: "By Project"),
          ],
        ),
      ),

      // --------------------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.green),
              title: Text('Manage Projects'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_categories');
              },
            ),
            ListTile(
              leading: Icon(Icons.tag, color: Colors.green),
              title: Text('Manage Tasks'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tags');
              },
            ),
          ],
        ),
      ),

      // ------------------------
      body: TabBarView(
        controller: _tabController,
        children: [
          buildEntriesByTask(context),
          buildEntriesByProject(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddEntryScreen())),
        tooltip: 'Add Time Entries',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildEntriesByTask(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entry.isEmpty) {
          return Center(
            child: Text("Click the + button to record time entries.",
                style: TextStyle(color: Colors.grey[600], fontSize: 18)),
          );
        }
        return ListView.builder(
          itemCount: provider.entry.length,
          itemBuilder: (context, index) {
            final timeEntry = provider.entry[index];
            String formattedDate =
                DateFormat('MMM dd, yyyy').format(timeEntry.date);
            return Dismissible(
              key: Key(timeEntry.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.removeEntry(timeEntry.id);
              },
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                color: Colors.green[50],
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: ListTile(
                  title: Text("${getTaskNameById(context, timeEntry.taskId)} - ${timeEntry.totalTime}hrs"),
                  subtitle: Text(
                      "$formattedDate - Project : ${getCategoryNameById(context, timeEntry.projectId)}"),
                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildEntriesByProject(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entry.isEmpty) {
          return Center(
            child: Text("Click the + button to record time entries.",
                style: TextStyle(color: Colors.grey[600], fontSize: 18)),
          );
        }

        // Grouping time by project
        var grouped = groupBy(provider.entry, (TimeEntry e) => e.projectId);
        return ListView(
          children: grouped.entries.map((entry) {
            String categoryName = getCategoryNameById(
                context, entry.key); // Ensure you implement this function
            double total = entry.value.fold(0.0,
                (double prev, TimeEntry element) => prev + element.totalTime);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "$categoryName - ${total}hrs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                ListView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // to disable scrolling within the inner list view
                  shrinkWrap:
                      true, // necessary to integrate a ListView within another ListView
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    TimeEntry timeentry = entry.value[index];
                    return ListTile(
                      leading: Icon(Icons.access_time, color: Colors.green),
                      title: Text(
                          "${getTaskNameById(context, timeentry.taskId)} - ${timeentry.totalTime}hrs"),
                      subtitle: Text(timeentry.notes),
                      trailing: Text(DateFormat('MMM dd, yyyy').format(timeentry.date)),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  // home_screen.dart
  String getCategoryNameById(BuildContext context, String categoryId) {
    var category = Provider.of<TimeEntryProvider>(context, listen: false)
        .project
        .firstWhere((cat) => cat.id == categoryId);
    return category.name;
  }

  String getTaskNameById(BuildContext context, String taskId) {
    var task = Provider.of<TimeEntryProvider>(context, listen: false)
        .tasks
        .firstWhere((task) => task.id == taskId);
    return task.name;
  }
}
