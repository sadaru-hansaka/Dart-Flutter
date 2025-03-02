import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'provider/time_entry_provider.dart';
import 'screens/home_screen.dart';
import 'screens/project_management_screen.dart';
import 'screens/task_management_screen.dart';

final LocalStorage localStorage = LocalStorage('time_tracker');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure the storage is ready before launching the app
  await localStorage.ready;

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider(localStorage)),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/manage_categories': (context) => ProjectManagementScreen(),
          '/manage_tags': (context) => TaskManagementScreen(),
        },
      ),
    );
  }
}
