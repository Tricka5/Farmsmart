import 'package:flutter/material.dart';


class TaskReminderApp extends StatelessWidget {
  const TaskReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Reminder',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: TaskListPage(),
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Map<String, String>> tasks = [];

  void _navigateToAddTaskPage({Map<String, String>? task, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(task: task),
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          tasks[index] = result;
        } else {
          tasks.add(result);
        }
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Grey background container with centered "Task Reminder" title
          Container(
            color: Colors.grey[300],
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Task Reminder',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.notifications, color: Colors.black),
                ],
              ),
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? Center(child: Text('No tasks added'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Colors.grey[400], // Round grey background
                          child: Icon(Icons.task, color: Colors.white),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                tasks[index]['title'] ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold), // Bold title
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded background
                              ),
                              child: Text(
                                tasks[index]['date'] ?? '',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                                8.0), // Rounded background
                          ),
                          child: Text(tasks[index]['subtitle'] ?? ''),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _navigateToAddTaskPage(
                                  task: tasks[index], index: index);
                            } else if (value == 'delete') {
                              _deleteTask(index);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTaskPage(),
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddTaskPage extends StatefulWidget {
  final Map<String, String>? task;

  const AddTaskPage({super.key, this.task});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _dateController = TextEditingController(); // Add a date controller

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!['title'] ?? '';
      _subtitleController.text = widget.task!['subtitle'] ?? '';
      _dateController.text = widget.task!['date'] ?? ''; // Initialize date
    }
  }

  // Helper function to validate date in DD/MM/YYYY format
  bool isValidDate(String input) {
    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegex.hasMatch(input)) return false;

    final parts = input.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return false;

    // Basic range check
    if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1000) {
      return false;
    }

    // Additional checks for month and day boundaries
    final daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && isLeapYear(year)) {
      return day <= 29;
    } else {
      return day <= daysInMonth[month - 1];
    }
  }

  // Helper function to check if a year is a leap year
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  void _saveTask() {
    final date = _dateController.text;
    if (_titleController.text.isNotEmpty &&
        _subtitleController.text.isNotEmpty &&
        isValidDate(date)) {
      Navigator.pop(context, {
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
        'date': date,
      });
    } else {
      // Show an error or handle invalid date
      print("Invalid date format. Use DD/MM/YYYY.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null
            ? 'Add Task Description'
            : 'Edit Task Description'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 150.0, // Make subtitle 5x the height of title
              child: TextField(
                controller: _subtitleController,
                maxLines: null, // Allows the field to expand vertically
                decoration: InputDecoration(
                  labelText: 'Subtitle',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date (DD/MM/YYYY)',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 255, 8),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('SAVE', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
