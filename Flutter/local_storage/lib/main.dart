import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'student_provider.dart';

late final ValueNotifier<int> notifier;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({Key? key, required this.localStorage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap the MaterialApp with the ChangeNotifierProvider
    return ChangeNotifierProvider<StudentProvider>(
      create: (_) => StudentProvider(storage: localStorage),
      child: MaterialApp(
        title: 'Student Management App',
        home: HomeScreen(), // Assuming HomeScreen leads to EditStudentScreen
      ),
    );
  }
}
