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
  String dueDate;
  String priority;
  bool completed;

  Task({
    required this.title,
    required this.dueDate,
    required this.priority,
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
    Task(title: "Complete Flutter Assignment", dueDate: "5 Aug 2026", priority: "High"),
    Task(title: "Study Database Management", dueDate: "8 Aug 2026", priority: "Medium"),
    Task(title: "Prepare Robotics PPT", dueDate: "10 Aug 2026", priority: "Low", completed: true),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      TaskScreen(tasks: tasks, onUpdate: () => setState(() {})),
      ReportScreen(tasks: tasks),
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
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
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
  final TextEditingController dateController = TextEditingController();
  String priority = "Medium";

  void addTask() {
    titleController.clear();
    dateController.clear();
    priority = "Medium";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Task Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: "Due Date",
                    hintText: "Eg. 10 Aug 2026",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Priority",
                  ),
                  items: const [
                    DropdownMenuItem(value: "High", child: Text("High")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                  ],
                  onChanged: (value) => priority = value!,
                ),
              ],
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
                    widget.tasks.add(Task(
                      title: titleController.text,
                      dueDate: dateController.text,
                      priority: priority,
                    ));
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

  Color priorityColor(String value) {
    switch (value) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Widget buildTaskCard(Task task, int index) {
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Flexible: due date text shrinks instead of overflowing on narrow cards
                Flexible(child: Text("Due: ${task.dueDate}")),
              ],
            ),
            const SizedBox(height: 5),
            Chip(
              label: Text(task.priority),
              backgroundColor: priorityColor(task.priority),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ],
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
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery: get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // LayoutBuilder: use available width to decide how many columns of cards to show
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adaptive breakpoints: mobile < 600, tablet 600-1024, desktop > 1024
            int columns;
            if (constraints.maxWidth < 600) {
              columns = 1; // mobile: same single column as Experiment 2
            } else if (constraints.maxWidth <= 1024) {
              columns = 2; // tablet
            } else {
              columns = 3; // desktop/web
            }

            // OrientationBuilder: give one extra column in landscape if there is room
            return OrientationBuilder(
              builder: (context, orientation) {
                int finalColumns = columns;
                if (orientation == Orientation.landscape && columns < 3) {
                  finalColumns = columns + 1;
                }

                if (finalColumns == 1) {
                  return ListView.builder(
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) => buildTaskCard(widget.tasks[index], index),
                  );
                } else {
                  // Wrap: cards move to the next line automatically when space runs out
                  double spacing = 12;
                  double cardWidth =
                      (constraints.maxWidth - spacing * (finalColumns - 1)) / finalColumns;

                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: List.generate(widget.tasks.length, (index) {
                        return SizedBox(
                          width: cardWidth,
                          child: buildTaskCard(widget.tasks[index], index),
                        );
                      }),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

// REPORT SCREEN

class ReportScreen extends StatelessWidget {
  final List<Task> tasks;

  const ReportScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    int pending = tasks.where((task) => !task.completed).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Task Summary
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Task Summary",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // Expanded: cards share the row space equally on any screen width
              Expanded(child: reportCard("Total", tasks.length.toString(), Icons.task)),
              const SizedBox(width: 10),
              Expanded(child: reportCard("Pending", pending.toString(), Icons.pending_actions)),
            ],
          ),
          const SizedBox(height: 25),

          // Semester Report
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Semester Report",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.school),
                  title: Text("Current Semester"),
                  subtitle: Text("Semester 5"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text("Current CGPA"),
                  subtitle: Text("7.8"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.credit_score),
                  title: Text("Credits Completed"),
                  subtitle: Text("85 Credits"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Report Summary Card
  Widget reportCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon, size: 35),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// PROFILE SCREEN

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> interests = ["Coding", "AI/ML", "Photography", "Sports"];
  String selectedInterest = "Coding";

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
                  Stack(
                    alignment: Alignment.center,
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
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

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Interests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: interests.map((item) {
              return ChoiceChip(
                label: Text(item),
                selected: selectedInterest == item,
                onSelected: (value) {
                  setState(() => selectedInterest = item);
                },
              );
            }).toList(),
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