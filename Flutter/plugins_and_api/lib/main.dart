import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Plugins',
      home: const HomeScreen(),
      routes: {
        '/urlLauncher': (context) => const UrlLauncherScreen(),
        '/sharedPreferences': (context) => const SharedPreferencesScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Plugins'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/urlLauncher');
              },
              child: const Text('URL Launcher Example'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sharedPreferences');
              },
              child: const Text('Shared Preferences Example'),
            ),
          ],
        ),
      ),
    );
  }
}

class UrlLauncherScreen extends StatelessWidget {
  const UrlLauncherScreen({super.key});

  void _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Launcher Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchURL,
          child: const Text('Open Flutter Website'),
        ),
      ),
    );
  }
}

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({super.key});

  @override
  _SharedPreferencesScreenState createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  final TextEditingController _controller = TextEditingController();
  String _storedValue = '';

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('myKey', _controller.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data saved!')),
    );
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedValue = prefs.getString('myKey') ?? 'No Data';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter some text'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Save Data'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Load Data'),
            ),
            const SizedBox(height: 16),
            Text('Stored Value: $_storedValue'),
          ],
        ),
      ),
    );
  }
}
