import 'package:flutter/material.dart';

void main() {
  runApp(const EduPilot());
}

// ============================================================
// COLORS
// ============================================================

const Color primaryColor = Color(0xFF5B6CFF);
const Color purpleColor = Color(0xFF7C5CFC);
const Color backgroundColor = Color(0xFFF7F8FC);

// ============================================================
// APP
// ============================================================

class EduPilot extends StatelessWidget {
  const EduPilot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduPilot',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),

        scaffoldBackgroundColor: backgroundColor,

        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
      ),

      home: const MainScreen(),
    );
  }
}

// ============================================================
// TASK MODEL
// ============================================================

class Task {
  String title;
  String subject;
  DateTime deadline;
  String difficulty;
  double hours;
  bool completed;

  Task({
    required this.title,
    required this.subject,
    required this.deadline,
    required this.difficulty,
    required this.hours,
    this.completed = false,
  });

  bool get isOverdue {
    return !completed &&
        deadline.isBefore(DateTime.now());
  }
}

// ============================================================
// MAIN SCREEN
// ============================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex = 0;

  final List<Task> tasks = [
    Task(
      title: 'DSA Assignment',
      subject: 'Data Structures',
      deadline: DateTime(2026, 8, 11),
      difficulty: 'Hard',
      hours: 2,
    ),

    Task(
      title: 'Chemistry Notes',
      subject: 'Chemistry',
      deadline: DateTime(2026, 8, 14),
      difficulty: 'Medium',
      hours: 1.5,
    ),

    Task(
      title: 'Python Practice',
      subject: 'Python',
      deadline: DateTime(2026, 8, 15),
      difficulty: 'Easy',
      hours: 1,
    ),
  ];

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final screens = [

      DashboardScreen(
        tasks: tasks,
        onRefresh: refresh,
      ),

      TaskScreen(
        tasks: tasks,
        onRefresh: refresh,
      ),

      WorkloadScreen(
        tasks: tasks,
      ),

      PlannerScreen(
        tasks: tasks,
      ),

      RecoveryScreen(
        tasks: tasks,
        onRefresh: refresh,
      ),

      const ProfileScreen(),
    ];

    return Scaffold(

      body: screens[selectedIndex],

      bottomNavigationBar: NavigationBar(

        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [

          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tasks',
          ),

          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Workload',
          ),

          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Planner',
          ),

          NavigationDestination(
            icon: Icon(Icons.restart_alt_outlined),
            selectedIcon: Icon(Icons.restart_alt),
            label: 'Recovery',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================

class DashboardScreen extends StatelessWidget {

  final List<Task> tasks;
  final VoidCallback onRefresh;

  const DashboardScreen({
    super.key,
    required this.tasks,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {

    final totalHours = tasks.fold<double>(
      0,
      (sum, task) => sum + task.hours,
    );

    final completed =
        tasks.where((task) => task.completed).length;

    final overdue =
        tasks.where((task) => task.isOverdue).length;

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'EduPilot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        actions: [

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.fromLTRB(
          20,
          5,
          20,
          25,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Good afternoon! 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Here is your academic overview.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // =================================================
            // MAIN WORKLOAD CARD
            // =================================================

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                gradient: const LinearGradient(
                  colors: [
                    primaryColor,
                    purpleColor,
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(22),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Container(
                        padding:
                            const EdgeInsets.all(10),

                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.18),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.insights_rounded,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        "Today's Overview",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      _stat(
                        totalHours.toStringAsFixed(1),
                        'Hours',
                      ),

                      _stat(
                        '${tasks.length}',
                        'Tasks',
                      ),

                      _stat(
                        '$completed',
                        'Done',
                      ),

                      _stat(
                        '$overdue',
                        'Overdue',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            if (tasks.isEmpty)

              _emptyState()

            else

              ...tasks.take(4).map(
                (task) => Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: TaskCard(
                    task: task,
                    showCheckbox: false,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // =================================================
            // INSIGHT
            // =================================================

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: const Color(0xFFE9F8F0),
                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: const Row(

                children: [

                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Colors.green,
                    size: 28,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Tip: Start your hardest task first while your energy is high.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _stat(
    String number,
    String label,
  ) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  static Widget _emptyState() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: const Column(

        children: [

          Icon(
            Icons.celebration_outlined,
            size: 40,
            color: Colors.green,
          ),

          SizedBox(height: 10),

          Text(
            'You are all caught up!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TASK SCREEN
// ============================================================

class TaskScreen extends StatefulWidget {

  final List<Task> tasks;
  final VoidCallback onRefresh;

  const TaskScreen({
    super.key,
    required this.tasks,
    required this.onRefresh,
  });

  @override
  State<TaskScreen> createState() =>
      _TaskScreenState();
}

class _TaskScreenState
    extends State<TaskScreen> {

  void addTask() {

    final titleController =
        TextEditingController();

    final subjectController =
        TextEditingController();

    final hoursController =
        TextEditingController();

    String difficulty = 'Medium';

    DateTime? selectedDeadline;

    showDialog(

      context: context,

      builder: (context) {

        return StatefulBuilder(

          builder:
              (context, setDialogState) {

            return AlertDialog(

              title: const Text(
                'Add New Task',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              content:
                  SingleChildScrollView(

                child: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    TextField(
                      controller:
                          titleController,

                      decoration:
                          const InputDecoration(
                        labelText:
                            'Assignment name',
                        prefixIcon:
                            Icon(
                          Icons.assignment_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller:
                          subjectController,

                      decoration:
                          const InputDecoration(
                        labelText:
                            'Subject',
                        prefixIcon:
                            Icon(
                          Icons.book_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ========================================
                    // DEADLINE
                    // ========================================

                    ListTile(

                      contentPadding:
                          EdgeInsets.zero,

                      leading: const Icon(
                        Icons.calendar_today_outlined,
                        color: primaryColor,
                      ),

                      title: Text(
                        selectedDeadline == null
                            ? 'Select deadline'
                            : formatDate(
                                selectedDeadline!,
                              ),
                      ),

                      subtitle:
                          const Text(
                        'Tap to choose deadline',
                      ),

                      trailing:
                          const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),

                      onTap: () async {

                        final picked =
                            await showDatePicker(

                          context: context,

                          initialDate:
                              DateTime.now(),

                          firstDate:
                              DateTime.now(),

                          lastDate:
                              DateTime(2030),
                        );

                        if (picked != null) {

                          setDialogState(() {

                            selectedDeadline =
                                picked;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller:
                          hoursController,

                      keyboardType:
                          TextInputType.number,

                      decoration:
                          const InputDecoration(
                        labelText:
                            'Estimated hours',
                        prefixIcon:
                            Icon(
                          Icons.schedule_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(

                      value: difficulty,

                      decoration:
                          const InputDecoration(
                        labelText:
                            'Difficulty',
                        prefixIcon:
                            Icon(
                          Icons.speed_outlined,
                        ),
                      ),

                      items: const [

                        DropdownMenuItem(
                          value: 'Easy',
                          child: Text('Easy'),
                        ),

                        DropdownMenuItem(
                          value: 'Medium',
                          child: Text('Medium'),
                        ),

                        DropdownMenuItem(
                          value: 'Hard',
                          child: Text('Hard'),
                        ),
                      ],

                      onChanged: (value) {

                        setDialogState(() {

                          difficulty =
                              value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [

                TextButton(

                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child:
                      const Text('Cancel'),
                ),

                FilledButton(

                  onPressed: () {

                    if (titleController
                            .text
                            .isEmpty ||
                        subjectController
                            .text
                            .isEmpty ||
                        selectedDeadline ==
                            null) {

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter the task, subject and deadline.',
                          ),
                        ),
                      );

                      return;
                    }

                    widget.tasks.add(

                      Task(

                        title:
                            titleController.text,

                        subject:
                            subjectController.text,

                        deadline:
                            selectedDeadline!,

                        difficulty:
                            difficulty,

                        hours:
                            double.tryParse(
                                  hoursController
                                      .text,
                                ) ??
                                1,
                      ),
                    );

                    widget.onRefresh();

                    Navigator.pop(context);

                    setState(() {});
                  },

                  child:
                      const Text('Add Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(

        onPressed: addTask,

        icon: const Icon(Icons.add),

        label: const Text('Add Task'),
      ),

      body: widget.tasks.isEmpty

          ? const Center(
              child: Text(
                'No tasks yet',
              ),
            )

          : ListView.builder(

              padding:
                  const EdgeInsets.fromLTRB(
                20,
                5,
                20,
                100,
              ),

              itemCount:
                  widget.tasks.length,

              itemBuilder:
                  (context, index) {

                final task =
                    widget.tasks[index];

                return Padding(

                  padding:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: TaskCard(

                    task: task,

                    showCheckbox: true,

                    onChanged: () {

                      setState(() {});

                      widget.onRefresh();
                    },
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// TASK CARD
// ============================================================

class TaskCard extends StatelessWidget {

  final Task task;
  final bool showCheckbox;

  final VoidCallback? onChanged;

  const TaskCard({
    super.key,
    required this.task,
    this.showCheckbox = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    Color iconBackground;
    Color iconColor;
    IconData icon;

    if (task.isOverdue) {

      iconBackground =
          const Color(0xFFFFE4E4);

      iconColor =
          Colors.redAccent;

      icon =
          Icons.warning_amber_rounded;

    } else if (task.difficulty == 'Hard') {

      iconBackground =
          const Color(0xFFFFE4E4);

      iconColor =
          Colors.redAccent;

      icon =
          Icons.priority_high_rounded;

    } else if (task.difficulty == 'Medium') {

      iconBackground =
          const Color(0xFFFFF0D9);

      iconColor =
          Colors.orange;

      icon =
          Icons.bolt_rounded;

    } else {

      iconBackground =
          const Color(0xFFE1F7EA);

      iconColor =
          Colors.green;

      icon =
          Icons.check_circle_outline;
    }

    return Container(

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color:
                Colors.black.withOpacity(0.04),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Row(

        children: [

          if (showCheckbox)

            Checkbox(

              value:
                  task.completed,

              onChanged: (value) {

                task.completed =
                    value ?? false;

                onChanged?.call();
              },
            ),

          Container(

            padding:
                const EdgeInsets.all(11),

            decoration:
                BoxDecoration(

              color:
                  iconBackground,

              borderRadius:
                  BorderRadius.circular(13),
            ),

            child: Icon(
              icon,
              color: iconColor,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  task.title,

                  style: TextStyle(

                    fontSize: 16,

                    fontWeight:
                        FontWeight.bold,

                    decoration:
                        task.completed
                            ? TextDecoration
                                .lineThrough
                            : null,
                  ),
                ),

                const SizedBox(height: 5),

                Text(

                  task.subject,

                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 5),

                Row(

                  children: [

                    Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: task.isOverdue
                          ? Colors.red
                          : Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Text(

                      task.isOverdue
                          ? 'Overdue • ${formatDate(task.deadline)}'
                          : 'Due ${formatDate(task.deadline)}',

                      style: TextStyle(

                        color:
                            task.isOverdue
                                ? Colors.red
                                : Colors.grey.shade600,

                        fontSize: 12,

                        fontWeight:
                            task.isOverdue
                                ? FontWeight.bold
                                : null,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      '${task.hours}h',
                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WORKLOAD SCREEN
// ============================================================

class WorkloadScreen extends StatelessWidget {

  final List<Task> tasks;

  const WorkloadScreen({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {

    final totalHours =
        tasks.fold<double>(
      0,
      (sum, task) =>
          sum + task.hours,
    );

    String workloadText;

    if (totalHours >= 8) {
      workloadText =
          'High workload';
    } else if (totalHours >= 4) {
      workloadText =
          'Moderate workload';
    } else {
      workloadText =
          'Light workload';
    }

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Workload Forecast',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Your academic workload',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'EduPilot looks at your tasks and estimated time.',
              style: TextStyle(
                color:
                    Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color:
                    const Color(0xFFFFF0D9),

                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Row(

                children: [

                  Container(

                    padding:
                        const EdgeInsets.all(12),

                    decoration:
                        BoxDecoration(

                      color:
                          Colors.orange,

                      borderRadius:
                          BorderRadius.circular(14),
                    ),

                    child: const Icon(

                      Icons.warning_amber_rounded,

                      color:
                          Colors.white,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(

                          workloadText,

                          style:
                              const TextStyle(

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '${tasks.length} tasks • ${totalHours.toStringAsFixed(1)} hours',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Weekly Forecast',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _dayBar(
              'Monday',
              0.35,
            ),

            _dayBar(
              'Tuesday',
              0.55,
            ),

            _dayBar(
              'Wednesday',
              0.85,
            ),

            _dayBar(
              'Thursday',
              0.65,
            ),

            _dayBar(
              'Friday',
              0.40,
            ),

            const SizedBox(height: 20),

            Container(

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color:
                    const Color(0xFFE9ECFF),

                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: const Row(

                children: [

                  Icon(
                    Icons.auto_awesome,
                    color:
                        primaryColor,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Wednesday looks busiest. Consider starting harder tasks earlier.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _dayBar(
    String day,
    double progress,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 18,
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            day,
            style: const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          ClipRRect(

            borderRadius:
                BorderRadius.circular(20),

            child:
                LinearProgressIndicator(

              value:
                  progress,

              minHeight:
                  12,

              backgroundColor:
                  Colors.grey.shade200,

              valueColor:
                  const AlwaysStoppedAnimation(
                primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STUDY PLANNER
// ============================================================

class PlannerScreen extends StatelessWidget {

  final List<Task> tasks;

  const PlannerScreen({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {

    final plannerTasks =
        tasks
            .where(
              (task) =>
                  !task.completed &&
                  !task.isOverdue,
            )
            .take(3)
            .toList();

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Study Planner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Your suggested plan',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'EduPilot organizes your work into focused sessions.',
              style: TextStyle(
                color:
                    Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            if (plannerTasks.isEmpty)

              const Center(
                child: Text(
                  'Add upcoming tasks to create a plan.',
                ),
              )

            else

              ...List.generate(

                plannerTasks.length,

                (index) {

                  final task =
                      plannerTasks[index];

                  return Padding(

                    padding:
                        const EdgeInsets.only(
                      bottom: 14,
                    ),

                    child: _studyCard(

                      time: index == 0
                          ? '4:00 PM – 5:00 PM'
                          : index == 1
                              ? '6:00 PM – 7:30 PM'
                              : '8:00 PM – 9:00 PM',

                      task:
                          task,
                    ),
                  );
                },
              ),

            const SizedBox(height: 15),

            Container(

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color:
                    const Color(0xFFEAF7FF),

                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: const Row(

                children: [

                  Icon(
                    Icons.tips_and_updates_outlined,
                    color: Colors.blue,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'EduPilot breaks large tasks into manageable study sessions.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _studyCard({
    required String time,
    required Task task,
  }) {

    return Container(

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color:
              Colors.grey.shade200,
        ),
      ),

      child: Row(

        children: [

          Container(

            width: 6,

            height: 75,

            decoration:
                BoxDecoration(

              color:
                  primaryColor,

              borderRadius:
                  BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  time,

                  style:
                      const TextStyle(

                    color:
                        primaryColor,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Text(

                  task.title,

                  style:
                      const TextStyle(

                    fontSize: 17,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(

                  '${task.subject} • ${task.hours} hour(s)',

                  style: TextStyle(

                    color:
                        Colors.grey.shade600,

                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RECOVERY PLANNER
// ============================================================

class RecoveryScreen extends StatefulWidget {

  final List<Task> tasks;
  final VoidCallback onRefresh;

  const RecoveryScreen({
    super.key,
    required this.tasks,
    required this.onRefresh,
  });

  @override
  State<RecoveryScreen> createState() =>
      _RecoveryScreenState();
}

class _RecoveryScreenState
    extends State<RecoveryScreen> {

  final Set<String> recoveredTasks =
      {};

  void recoverTask(Task task) {

    setState(() {

      recoveredTasks.add(
        task.title,
      );
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(
          'Recovery plan created for ${task.title}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final overdueTasks =
        widget.tasks
            .where(
              (task) =>
                  task.isOverdue,
            )
            .toList();

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Recovery Planner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // =================================================
            // HEADER
            // =================================================

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(

                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF7C5CFC),
                    Color(0xFF5B6CFF),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(22),
              ),

              child: const Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Icon(
                    Icons.restart_alt_rounded,
                    color: Colors.white,
                    size: 32,
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Missed something?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    'EduPilot helps you recover without overwhelming your schedule.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Tasks needing recovery',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            if (overdueTasks.isEmpty)

              Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.all(25),

                decoration:
                    BoxDecoration(

                  color:
                      const Color(0xFFE9F8F0),

                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: const Column(

                  children: [

                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 42,
                    ),

                    SizedBox(height: 10),

                    Text(
                      'No tasks need recovery!',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'You are keeping up with your deadlines.',
                      textAlign:
                          TextAlign.center,
                    ),
                  ],
                ),
              )

            else

              ...overdueTasks.map(
                (task) => Padding(

                  padding:
                      const EdgeInsets.only(
                    bottom: 15,
                  ),

                  child:
                      _recoveryCard(task),
                ),
              ),

            const SizedBox(height: 20),

            // =================================================
            // HOW RECOVERY WORKS
            // =================================================

            const Text(
              'How recovery works',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _step(
              '1',
              'Detect',
              'EduPilot identifies missed deadlines.',
            ),

            _step(
              '2',
              'Redistribute',
              'The task is divided into smaller sessions.',
            ),

            _step(
              '3',
              'Recover',
              'Your study plan is adjusted to catch up.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _recoveryCard(Task task) {

    final recovered =
        recoveredTasks.contains(
      task.title,
    );

    return Container(

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color:
              const Color(0xFFFFD5D5),
        ),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Container(

                padding:
                    const EdgeInsets.all(10),

                decoration:
                    BoxDecoration(

                  color:
                      const Color(0xFFFFE4E4),

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.warning_amber_rounded,
                  color:
                      Colors.redAccent,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      task.title,

                      style:
                          const TextStyle(

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      task.subject,
                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            'Original deadline: ${formatDate(task.deadline)}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Remaining work: ${task.hours} hours',
            style: TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 15),

          if (!recovered)

            SizedBox(

              width: double.infinity,

              child: FilledButton.icon(

                onPressed: () {
                  recoverTask(task);
                },

                icon:
                    const Icon(
                  Icons.auto_awesome,
                ),

                label:
                    const Text(
                  'Create Recovery Plan',
                ),
              ),
            )

          else

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(15),

              decoration:
                  BoxDecoration(

                color:
                    const Color(0xFFE9ECFF),

                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: const Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                      Icon(
                        Icons.check_circle,
                        color:
                            primaryColor,
                      ),

                      SizedBox(width: 8),

                      Text(
                        'Recovery plan created!',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Today: 1 hour focused session',

                  ),

                  SizedBox(height: 5),

                  Text(
                    'Tomorrow: Complete remaining work',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _step(
    String number,
    String title,
    String description,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 14,
      ),

      child: Row(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(

            width: 34,

            height: 34,

            alignment:
                Alignment.center,

            decoration:
                BoxDecoration(

              color:
                  const Color(0xFFE9ECFF),

              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Text(

              number,

              style:
                  const TextStyle(

                color:
                    primaryColor,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style:
                      const TextStyle(

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfileScreen extends StatelessWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 10),

            const CircleAvatar(

              radius: 45,

              backgroundColor:
                  Color(0xFFE9ECFF),

              child: Icon(
                Icons.person,
                size: 48,
                color:
                    primaryColor,
              ),
            ),

            const SizedBox(height: 15),

            const Text(

              'Student',

              style:
                  TextStyle(

                fontSize: 23,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(

              'B.Tech Computer Science',

              style:
                  TextStyle(

                color:
                    Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            _infoCard(
              Icons.school_outlined,
              'Course',
              'B.Tech CSE',
            ),

            _infoCard(
              Icons.layers_outlined,
              'Semester',
              '3rd Semester',
            ),

            _infoCard(
              Icons.menu_book_outlined,
              'Subjects',
              'DSA, Python, Maths, Chemistry, Biology',
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoCard(
    IconData icon,
    String title,
    String value,
  ) {

    return Container(

      width:
          double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(

        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Row(

        children: [

          Container(

            padding:
                const EdgeInsets.all(10),

            decoration:
                BoxDecoration(

              color:
                  const Color(0xFFE9ECFF),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color:
                  primaryColor,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style:
                      TextStyle(

                    color:
                        Colors.grey.shade600,

                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 3),

                Text(

                  value,

                  style:
                      const TextStyle(

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DATE FORMATTER
// ============================================================

String formatDate(DateTime date) {

  const months = [

    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}