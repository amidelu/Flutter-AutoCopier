import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'database_helper.dart';

class BulkInputScreen extends StatefulWidget {
  const BulkInputScreen({super.key});

  @override
  _BulkInputScreenState createState() => _BulkInputScreenState();
}

class _BulkInputScreenState extends State<BulkInputScreen> {
  final _bulkController = TextEditingController();
  bool _isInserting = false;

  Future<void> _checkPermission() async {
    await FlutterAccessibilityService.requestAccessibilityPermission();
    final bool res = await FlutterAccessibilityService.isAccessibilityPermissionEnabled();

    if (!res) {
      await FlutterAccessibilityService.requestAccessibilityPermission();
    }
  }
  /// Parse the input text and insert users into the database.
  Future<void> _processAndInsertUsers() async {
    String input = _bulkController.text;
    List<String> lines = input.split('\n');
    List<Map<String, String>> users = lines.map((line) {
      List<String> parts = line.split(',');
      return {'email': parts[0].trim(), 'password': parts[1].trim()};
    }).toList();

    setState(() {
      _isInserting = true;
    });

    await DatabaseHelper().insertUsers(users);

    setState(() {
      _isInserting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Users inserted successfully!')),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Input Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _bulkController,
              maxLines: 15,
              decoration: const InputDecoration(
                labelText: 'Enter emails and passwords (comma-separated)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _isInserting
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _processAndInsertUsers,
              child: const Text('Insert Users'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bulkController.dispose();
    super.dispose();
  }
}