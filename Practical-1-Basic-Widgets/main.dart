import 'package:flutter/material.dart';

void main() {
  runApp(const StudyPlannerApp());
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Study Planner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// Task Model

class Task {
  String title;
  bool completed;

  Task({
    required this.title,
    this.completed = false,
  });
}

// Home Page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  List<Task> tasks = [
    Task(title: "Complete Flutter Assignment"),
    Task(title: "Study Database Management"),
    Task(title: "Prepare Robotics PPT", completed: true),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      TaskScreen(tasks: tasks, onUpdate: () => setState(() {})),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Study Planner"),
        centerTitle: true,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.indigo,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// TASK MANAGEMENT SCREEN

class TaskScreen extends StatefulWidget {
  final List<Task> tasks;
  final VoidCallback onUpdate;

  const TaskScreen({super.key, required this.tasks, required this.onUpdate});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController titleController = TextEditingController();

  void addTask() {
    titleController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Task Title",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    widget.tasks.add(Task(title: titleController.text));
                  });
                  widget.onUpdate();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Task Added Successfully")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: widget.tasks.length,
          itemBuilder: (context, index) {
            final task = widget.tasks[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              child: ListTile(
                leading: Checkbox(
                  value: task.completed,
                  onChanged: (value) {
                    setState(() => task.completed = value!);
                    widget.onUpdate();
                  },
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => widget.tasks.removeAt(index));
                    widget.onUpdate();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Task Deleted")),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// PROFILE SCREEN

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                                  CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.indigo,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                  const SizedBox(height: 15),
                  const Text(
                    "Bhakti Baraf",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text("Computer Engineering Student"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Student Information
          Card(
            child: Column(
              children: const [
                ListTile(leading: Icon(Icons.badge), title: Text("Roll Number"), subtitle: Text("CE2024XXX")),
                Divider(),
                ListTile(leading: Icon(Icons.school), title: Text("College"), subtitle: Text("VJTI Mumbai")),
                Divider(),
                ListTile(leading: Icon(Icons.email), title: Text("Email"), subtitle: Text("student@gmail.com")),
                Divider(),
                ListTile(leading: Icon(Icons.phone), title: Text("Phone"), subtitle: Text("+91 XXXXX XXXXX")),
              ],
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save Profile"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile Saved Successfully")),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}