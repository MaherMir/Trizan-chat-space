import 'package:flutter/material.dart';

// ==========================================
// MODELS
// ==========================================

class TrizanUser {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final bool isOnline;

  TrizanUser({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    this.isOnline = true,
  });
}

class TrizanProjectGroup {
  final String id;
  final String name;
  final String description;

  TrizanProjectGroup({
    required this.id,
    required this.name,
    required this.description,
  });
}

enum TrizanTaskPriority { low, medium, high }
enum TrizanTaskStatus { todo, inProgress, done }

class TrizanTask {
  final String id;
  final String title;
  final String description;
  final String assigneeId;
  final String projectId;
  TrizanTaskPriority priority;
  TrizanTaskStatus status;
  final DateTime dueDate;
  final DateTime createdDate;

  TrizanTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assigneeId,
    required this.projectId,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.createdDate,
  });
}

class TrizanMessage {
  final String id;
  final String text;
  final String senderId;
  final String projectId;
  final DateTime timestamp;
  final bool isSystem;
  final String? attachedTaskId;

  TrizanMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.projectId,
    required this.timestamp,
    this.isSystem = false,
    this.attachedTaskId,
  });
}

// ==========================================
// STATE MANAGEMENT (ChangeNotifier Singleton)
// ==========================================

class TrizanState extends ChangeNotifier {
  static final TrizanState _instance = TrizanState._internal();
  factory TrizanState() => _instance;
  TrizanState._internal() {
    _initData();
  }

  late TrizanUser currentUser;
  final List<TrizanUser> users = [];
  final List<TrizanProjectGroup> projects = [];
  late TrizanProjectGroup activeProject;
  final List<TrizanTask> tasks = [];
  final List<TrizanMessage> messages = [];
  final List<String> activityLog = [];

  void _initData() {
    // Team Members
    users.addAll([
      TrizanUser(
        id: 'u1',
        name: 'Maher',
        role: 'Project Manager',
        avatarUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=Maher',
      ),
      TrizanUser(
        id: 'u2',
        name: 'Sarah',
        role: 'Lead Designer',
        avatarUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=Sarah',
      ),
      TrizanUser(
        id: 'u3',
        name: 'Alex',
        role: 'Backend Dev',
        avatarUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=Alex',
      ),
      TrizanUser(
        id: 'u4',
        name: 'Emily',
        role: 'QA Engineer',
        avatarUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=Emily',
      ),
    ]);

    currentUser = users[0]; // Maher is default active user

    // Project Groups (Channels)
    projects.addAll([
      TrizanProjectGroup(
        id: 'p1',
        name: 'Mobile App Redesign',
        description: 'Redesigning our client app UI for a premium, glassmorphic look.',
      ),
      TrizanProjectGroup(
        id: 'p2',
        name: 'Backend Integration',
        description: 'API scaling, database index tuning, and order synchronizations.',
      ),
      TrizanProjectGroup(
        id: 'p3',
        name: 'Marketing Campaign',
        description: 'Drafting copy, launch events, social banners and promo material.',
      ),
    ]);

    activeProject = projects[0];

    // Seed Tasks
    tasks.addAll([
      TrizanTask(
        id: 't1',
        title: 'Design Glassmorphic Auth Screen',
        description: 'Create a clean, modern design mockup for the customer login flow.',
        assigneeId: 'u2', // Sarah
        projectId: 'p1',
        priority: TrizanTaskPriority.high,
        status: TrizanTaskStatus.done,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      TrizanTask(
        id: 't2',
        title: 'Implement Dark Mode State',
        description: 'Add global notifier for system-wide theme switching and caching preferences.',
        assigneeId: 'u1', // Maher
        projectId: 'p1',
        priority: TrizanTaskPriority.medium,
        status: TrizanTaskStatus.inProgress,
        dueDate: DateTime.now().add(const Duration(days: 4)),
        createdDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TrizanTask(
        id: 't3',
        title: 'Fix SQLite Database Collisions',
        description: 'Resolve rare primary key conflicts during high-volume offline checkouts.',
        assigneeId: 'u3', // Alex
        projectId: 'p2',
        priority: TrizanTaskPriority.high,
        status: TrizanTaskStatus.todo,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        createdDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TrizanTask(
        id: 't4',
        title: 'Draft Landing Page Copy',
        description: 'Write engaging copy in both French and English targeting local delivery benefits.',
        assigneeId: 'u4', // Emily
        projectId: 'p3',
        priority: TrizanTaskPriority.low,
        status: TrizanTaskStatus.todo,
        dueDate: DateTime.now().add(const Duration(days: 6)),
        createdDate: DateTime.now(),
      ),
      TrizanTask(
        id: 't5',
        title: 'Refactor Custom Scrollbars',
        description: 'Ensure smooth scrolling across Chrome, Safari, and Firefox using webkit parameters.',
        assigneeId: 'u2', // Sarah
        projectId: 'p1',
        priority: TrizanTaskPriority.low,
        status: TrizanTaskStatus.todo,
        dueDate: DateTime.now().add(const Duration(days: 5)),
        createdDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);

    // Seed Messages
    messages.addAll([
      TrizanMessage(
        id: 'm1',
        text: 'Hey team! Welcome to our new TRIZAN task workspace. Let\'s keep track of our work directly in this channel.',
        senderId: 'u1',
        projectId: 'p1',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      TrizanMessage(
        id: 'm2',
        text: 'I finished mockups for the new onboarding layouts. Check out the task card below!',
        senderId: 'u2',
        projectId: 'p1',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      TrizanMessage(
        id: 'sys1',
        text: 'Sarah completed task "Design Glassmorphic Auth Screen"',
        senderId: 'u2',
        projectId: 'p1',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isSystem: true,
      ),
      TrizanMessage(
        id: 'm3',
        text: 'I\'ll start working on the UI state managers right now. I\'ve pinned my task here.',
        senderId: 'u1',
        projectId: 'p1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      TrizanMessage(
        id: 'm_task2',
        text: '',
        senderId: 'u1',
        projectId: 'p1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        attachedTaskId: 't2',
      ),
    ]);

    // Seed Logs
    activityLog.addAll([
      'Maher created project group "Mobile App Redesign"',
      'Sarah marked task "Design Glassmorphic Auth Screen" as completed',
      'Maher set task "Implement Dark Mode State" to In Progress',
    ]);
  }

  // Active user switching
  void switchUser(TrizanUser user) {
    currentUser = user;
    notifyListeners();
  }

  // Active channel switching
  void selectProject(TrizanProjectGroup project) {
    activeProject = project;
    notifyListeners();
  }

  // Add message
  void addTextMessage(String text) {
    if (text.trim().isEmpty) return;

    final isCommand = text.startsWith('/task ');
    if (isCommand) {
      // Parse simple command: /task Title of task
      final taskTitle = text.substring(6).trim();
      if (taskTitle.isNotEmpty) {
        // Automatically open the task dialogue or add a default task assigned to current user
        addTask(
          taskTitle,
          'Task created quickly via slash command.',
          currentUser,
          TrizanTaskPriority.medium,
          DateTime.now().add(const Duration(days: 3)),
        );
        return;
      }
    }

    final newMsg = TrizanMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      senderId: currentUser.id,
      projectId: activeProject.id,
      timestamp: DateTime.now(),
    );

    messages.add(newMsg);
    notifyListeners();
  }

  // Add a task (and embed it in the chat)
  TrizanTask addTask(
    String title,
    String description,
    TrizanUser assignee,
    TrizanTaskPriority priority,
    DateTime dueDate,
  ) {
    final newTaskId = 'task_${DateTime.now().millisecondsSinceEpoch}';
    final newTask = TrizanTask(
      id: newTaskId,
      title: title,
      description: description,
      assigneeId: assignee.id,
      projectId: activeProject.id,
      priority: priority,
      status: TrizanTaskStatus.todo,
      dueDate: dueDate,
      createdDate: DateTime.now(),
    );

    tasks.add(newTask);

    // Add a chat announcement card
    final sysMsg = TrizanMessage(
      id: 'sys_${DateTime.now().millisecondsSinceEpoch}',
      text: '${currentUser.name} created task "$title" assigned to ${assignee.name}',
      senderId: currentUser.id,
      projectId: activeProject.id,
      timestamp: DateTime.now(),
      isSystem: true,
    );
    messages.add(sysMsg);

    final cardMsg = TrizanMessage(
      id: 'msg_card_${DateTime.now().millisecondsSinceEpoch}',
      text: '',
      senderId: currentUser.id,
      projectId: activeProject.id,
      timestamp: DateTime.now(),
      attachedTaskId: newTaskId,
    );
    messages.add(cardMsg);

    activityLog.insert(0, '${currentUser.name} created task "$title"');
    notifyListeners();
    return newTask;
  }

  // Update task status (triggers system chat updates!)
  void updateTaskStatus(String taskId, TrizanTaskStatus newStatus) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex >= 0) {
      final task = tasks[taskIndex];
      final oldStatus = task.status;
      if (oldStatus == newStatus) return;

      task.status = newStatus;

      // Status text conversion
      String statusStr = 'To Do';
      if (newStatus == TrizanTaskStatus.inProgress) statusStr = 'In Progress';
      if (newStatus == TrizanTaskStatus.done) statusStr = 'Completed';

      // System notification message
      final sysMsg = TrizanMessage(
        id: 'sys_${DateTime.now().millisecondsSinceEpoch}',
        text: '${currentUser.name} updated task "${task.title}" status to $statusStr',
        senderId: currentUser.id,
        projectId: task.projectId,
        timestamp: DateTime.now(),
        isSystem: true,
      );
      messages.add(sysMsg);

      activityLog.insert(0, '${currentUser.name} marked "${task.title}" as $statusStr');
      notifyListeners();
    }
  }

  // Assign task to someone else
  void updateTaskAssignee(String taskId, String assigneeId) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex >= 0) {
      final task = tasks[taskIndex];
      final oldAssignee = users.firstWhere((u) => u.id == task.assigneeId).name;
      final newAssignee = users.firstWhere((u) => u.id == assigneeId).name;
      
      final updatedTask = TrizanTask(
        id: task.id,
        title: task.title,
        description: task.description,
        assigneeId: assigneeId,
        projectId: task.projectId,
        priority: task.priority,
        status: task.status,
        dueDate: task.dueDate,
        createdDate: task.createdDate,
      );
      tasks[taskIndex] = updatedTask;

      final sysMsg = TrizanMessage(
        id: 'sys_${DateTime.now().millisecondsSinceEpoch}',
        text: '${currentUser.name} reassigned "${task.title}" from $oldAssignee to $newAssignee',
        senderId: currentUser.id,
        projectId: task.projectId,
        timestamp: DateTime.now(),
        isSystem: true,
      );
      messages.add(sysMsg);

      notifyListeners();
    }
  }

  // Delete Task
  void deleteTask(String taskId) {
    final task = tasks.firstWhere((t) => t.id == taskId);
    tasks.removeWhere((t) => t.id == taskId);
    messages.removeWhere((m) => m.attachedTaskId == taskId);

    final sysMsg = TrizanMessage(
      id: 'sys_${DateTime.now().millisecondsSinceEpoch}',
      text: '${currentUser.name} deleted task "${task.title}"',
      senderId: currentUser.id,
      projectId: activeProject.id,
      timestamp: DateTime.now(),
      isSystem: true,
    );
    messages.add(sysMsg);
    notifyListeners();
  }

  // Add new group/channel
  void createProjectGroup(String name, String desc) {
    final id = 'p_${DateTime.now().millisecondsSinceEpoch}';
    final cleanName = name.replaceAll('#', '').trim();
    final newGroup = TrizanProjectGroup(id: id, name: cleanName, description: desc);
    projects.add(newGroup);
    activeProject = newGroup;

    // Welcome system message
    messages.add(
      TrizanMessage(
        id: 'sys_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Project group "#$cleanName" was created by ${currentUser.name}. Welcome to the discussion.',
        senderId: currentUser.id,
        projectId: id,
        timestamp: DateTime.now(),
        isSystem: true,
      )
    );

    activityLog.insert(0, '${currentUser.name} created channel #$cleanName');
    notifyListeners();
  }

  // Add new member
  void createMember(String name, String role) {
    final id = 'u_${DateTime.now().millisecondsSinceEpoch}';
    final newMember = TrizanUser(
      id: id,
      name: name,
      role: role,
      avatarUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=$name',
    );
    users.add(newMember);

    // Log & notify
    activityLog.insert(0, '${currentUser.name} added $name to the team');
    notifyListeners();
  }
}

// ==========================================
// CUSTOM UI COLOR THEME (Sleek Obsidian/Dark)
// ==========================================

class TrizanTheme {
  static const Color background = Color(0xFF09090B); // Ultra dark gray
  static const Color surface = Color(0xFF121216);    // Dark sidebar/cards
  static const Color cardBg = Color(0xFF1B1B22);     // Message bubbles & item cards
  static const Color accent = Color(0xFF6366F1);     // TRIZAN Indigo primary
  static const Color accentLight = Color(0xFF818CF8);
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF52525B);
  
  static const Color todoColor = Color(0xFF71717A);      // Cool gray
  static const Color progressColor = Color(0xFFF59E0B);  // Amber
  static const Color completedColor = Color(0xFF10B981); // Emerald
  static const Color errorColor = Color(0xFFEF4444);     // Crimson red
  
  static String formatShortDate(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  static String formatShortTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return "$hour:$min";
  }
}

// ==========================================
// MAIN SCREEN VIEW
// ==========================================

class TrizanTaskManagerPage extends StatefulWidget {
  const TrizanTaskManagerPage({Key? key}) : super(key: key);

  @override
  State<TrizanTaskManagerPage> createState() => _TrizanTaskManagerPageState();
}

class _TrizanTaskManagerPageState extends State<TrizanTaskManagerPage> {
  int _currentTab = 0; // 0: Chat, 1: Task Board, 2: Analytics

  @override
  Widget build(BuildContext context) {
    final state = TrizanState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: TrizanTheme.background,
            primaryColor: TrizanTheme.accent,
            colorScheme: const ColorScheme.dark(
              primary: TrizanTheme.accent,
              secondary: TrizanTheme.accentLight,
              background: TrizanTheme.background,
              surface: TrizanTheme.surface,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: TrizanTheme.surface,
              elevation: 1,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TrizanTheme.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text(
                      'TRIZAN',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${state.activeProject.name}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          state.activeProject.description,
                          style: const TextStyle(fontSize: 10, color: TrizanTheme.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                // Active User Dropdown Switcher
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: TrizanTheme.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: PopupMenuButton<TrizanUser>(
                    onSelected: (user) {
                      state.switchUser(user);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Switched view to acting as ${user.name}'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: TrizanTheme.accent,
                        ),
                      );
                    },
                    offset: const Offset(0, 40),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white24,
                          child: Text(
                            state.currentUser.name[0],
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          state.currentUser.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white70),
                      ],
                    ),
                    itemBuilder: (BuildContext context) {
                      return state.users.map((TrizanUser user) {
                        return PopupMenuItem<TrizanUser>(
                          value: user,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white24,
                                child: Text(user.name[0]),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text(user.role, style: const TextStyle(color: TrizanTheme.textSecondary, fontSize: 10)),
                                ],
                              ),
                              if (user.id == state.currentUser.id) ...[
                                const Spacer(),
                                const Icon(Icons.check, color: TrizanTheme.accent, size: 16),
                              ]
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
            drawer: const TrizanNavigationDrawer(),
            body: IndexedStack(
              index: _currentTab,
              children: const [
                TrizanChatView(),
                TrizanBoardView(),
                TrizanAnalyticsView(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentTab,
              onTap: (index) {
                setState(() {
                  _currentTab = index;
                });
              },
              backgroundColor: TrizanTheme.surface,
              selectedItemColor: TrizanTheme.accentLight,
              unselectedItemColor: TrizanTheme.textMuted,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline_rounded),
                  activeIcon: Icon(Icons.chat_bubble_rounded),
                  label: 'Discussion',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.assignment_outlined),
                  activeIcon: const Icon(Icons.assignment_rounded),
                  label: 'Task Board (${state.tasks.where((t) => t.projectId == state.activeProject.id && t.status != TrizanTaskStatus.done).length})',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_outlined),
                  activeIcon: Icon(Icons.analytics_rounded),
                  label: 'Leaderboard',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// DRAWER / SIDEBAR FOR PROJECT CHANNELS
// ==========================================

class TrizanNavigationDrawer extends StatelessWidget {
  const TrizanNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = TrizanState();

    return Drawer(
      backgroundColor: TrizanTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: TrizanTheme.background,
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'TRIZAN',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: TrizanTheme.completedColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Trizan Collaboration Hub',
                      style: TextStyle(fontSize: 12, color: TrizanTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Project Channels List Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PROJECT GROUPS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: TrizanTheme.textSecondary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_box_rounded, size: 20, color: Colors.white70),
                  onPressed: () => _showCreateProjectDialog(context, state),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Create New Project Group',
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                final project = state.projects[index];
                final isActive = project.id == state.activeProject.id;
                final taskCount = state.tasks.where((t) => t.projectId == project.id && t.status != TrizanTaskStatus.done).length;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    selected: isActive,
                    selectedTileColor: TrizanTheme.cardBg,
                    leading: Text(
                      '#',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isActive ? TrizanTheme.accentLight : TrizanTheme.textMuted,
                      ),
                    ),
                    title: Text(
                      project.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? Colors.white : TrizanTheme.textSecondary,
                      ),
                    ),
                    trailing: taskCount > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: TrizanTheme.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$taskCount',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          )
                        : null,
                    onTap: () {
                      state.selectProject(project);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                );
              },
            ),
          ),

          // Team Members / Progress Section in Drawer
          const Divider(color: Colors.white10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TEAM PROGRESS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: TrizanTheme.textSecondary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 20, color: Colors.white70),
                  onPressed: () => _showCreateMemberDialog(context, state),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Add Team Member',
                ),
              ],
            ),
          ),
          
          Container(
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                
                // Calculate completion rate
                final userTasks = state.tasks.where((t) => t.assigneeId == user.id && t.projectId == state.activeProject.id).toList();
                final completedTasks = userTasks.where((t) => t.status == TrizanTaskStatus.done).length;
                final totalTasks = userTasks.length;
                final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) : 1.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white12,
                                child: Text(user.name[0], style: const TextStyle(fontSize: 9, color: Colors.white70)),
                              ),
                              const SizedBox(width: 8),
                              Text(user.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text(
                            '$completedTasks/$totalTasks',
                            style: const TextStyle(fontSize: 11, color: TrizanTheme.textSecondary),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: completionRate,
                          backgroundColor: TrizanTheme.cardBg,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            completionRate == 1.0 && totalTasks > 0
                                ? TrizanTheme.completedColor
                                : TrizanTheme.accentLight,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context, TrizanState state) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TrizanTheme.surface,
          title: const Text('New Project Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'e.g. mobile-redesign, qa-sprint-2',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What is the focus of this channel?',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  state.createProjectGroup(nameController.text.trim(), descController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateMemberDialog(BuildContext context, TrizanState state) {
    final nameController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TrizanTheme.surface,
          title: const Text('Add Team Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'e.g. Sarah Jenkins',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  hintText: 'e.g. Frontend Developer',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty && roleController.text.trim().isNotEmpty) {
                  state.createMember(nameController.text.trim(), roleController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Member'),
            ),
          ],
        );
      },
    );
  }
}

// ==========================================
// VIEW 1: DISCUSSION CHAT & TASK STREAM
// ==========================================

class TrizanChatView extends StatefulWidget {
  const TrizanChatView({Key? key}) : super(key: key);

  @override
  State<TrizanChatView> createState() => _TrizanChatViewState();
}

class _TrizanChatViewState extends State<TrizanChatView> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = TrizanState();
    final projectMessages = state.messages.where((m) => m.projectId == state.activeProject.id).toList();

    // Trigger auto-scroll on list redraw
    _scrollToBottom();

    return Column(
      children: [
        // Message Timeline
        Expanded(
          child: projectMessages.isEmpty
              ? const Center(
                  child: Text(
                    'No messages yet. Send a message or post a task card!',
                    style: TextStyle(color: TrizanTheme.textSecondary),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: projectMessages.length,
                  itemBuilder: (context, index) {
                    final msg = projectMessages[index];

                    if (msg.isSystem) {
                      return _buildSystemMessage(msg);
                    }

                    if (msg.attachedTaskId != null) {
                      return _buildTaskCardMessage(msg, state);
                    }

                    return _buildUserMessage(msg, state);
                  },
                ),
        ),

        // Chat Input Area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            color: TrizanTheme.surface,
            border: Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Insertion shortcuts
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _showAddTaskDialog(context, state),
                    icon: const Icon(Icons.add_task_rounded, size: 16, color: TrizanTheme.accentLight),
                    label: const Text('Add Task Card', style: TextStyle(fontSize: 12, color: TrizanTheme.accentLight)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      backgroundColor: TrizanTheme.cardBg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tip: Type /task [title] to post a task',
                    style: TextStyle(fontSize: 10, color: TrizanTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Main input text box
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: TrizanTheme.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Message this group...',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty) {
                            state.addTextMessage(val);
                            _msgController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: TrizanTheme.accent,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: () {
                        if (_msgController.text.trim().isNotEmpty) {
                          state.addTextMessage(_msgController.text);
                          _msgController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // System status messages
  Widget _buildSystemMessage(TrizanMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            msg.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: TrizanTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // Standard user bubble messages
  Widget _buildUserMessage(TrizanMessage msg, TrizanState state) {
    final sender = state.users.firstWhere((u) => u.id == msg.senderId,
        orElse: () => TrizanUser(id: 'unknown', name: 'Unknown User', role: 'Team Member', avatarUrl: ''));
    final isSelf = msg.senderId == state.currentUser.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSelf) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white12,
              child: Text(sender.name[0], style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Name and Time
              Row(
                children: [
                  Text(
                    sender.name,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: TrizanTheme.textSecondary),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    TrizanTheme.formatShortTime(msg.timestamp),
                    style: const TextStyle(fontSize: 9, color: TrizanTheme.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Message Bubble
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelf ? TrizanTheme.accent : TrizanTheme.cardBg,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: isSelf ? const Radius.circular(12) : const Radius.circular(0),
                    bottomRight: isSelf ? const Radius.circular(0) : const Radius.circular(12),
                  ),
                  border: isSelf ? null : Border.all(color: Colors.white10),
                ),
                child: Text(
                  msg.text,
                  style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.white),
                ),
              ),
            ],
          ),
          if (isSelf) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Text(sender.name[0], style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }

  // Interactive Task Card message in discussion thread
  Widget _buildTaskCardMessage(TrizanMessage msg, TrizanState state) {
    // Find task
    final taskIndex = state.tasks.indexWhere((t) => t.id == msg.attachedTaskId);
    if (taskIndex < 0) {
      return const SizedBox.shrink(); // Task deleted
    }

    final task = state.tasks[taskIndex];
    final assignee = state.users.firstWhere((u) => u.id == task.assigneeId,
        orElse: () => TrizanUser(id: 'unknown', name: 'Unknown User', role: 'Team Member', avatarUrl: ''));

    Color borderLeftColor = TrizanTheme.todoColor;
    if (task.priority == TrizanTaskPriority.medium) borderLeftColor = TrizanTheme.progressColor;
    if (task.priority == TrizanTaskPriority.high) borderLeftColor = TrizanTheme.errorColor;
    if (task.status == TrizanTaskStatus.done) borderLeftColor = TrizanTheme.completedColor;

    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 4, bottom: 4, right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: TrizanTheme.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: borderLeftColor, width: 4),
            top: const BorderSide(color: Colors.white10),
            right: const BorderSide(color: Colors.white10),
            bottom: const BorderSide(color: Colors.white10),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.assignment_rounded, size: 14, color: TrizanTheme.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      'TASK CARD',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: borderLeftColor,
                      ),
                    ),
                  ],
                ),
                // Priority Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: borderLeftColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: borderLeftColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              task.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                decoration: task.status == TrizanTaskStatus.done ? TextDecoration.lineThrough : null,
                color: task.status == TrizanTaskStatus.done ? TrizanTheme.textSecondary : Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            // Desc
            Text(
              task.description,
              style: const TextStyle(fontSize: 11, color: TrizanTheme.textSecondary, height: 1.3),
            ),
            const SizedBox(height: 12),

            // Assignee & Due Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.white12,
                      child: Text(assignee.name[0], style: const TextStyle(fontSize: 7, color: Colors.white)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Assigned to ${assignee.name}',
                      style: const TextStyle(fontSize: 10, color: TrizanTheme.textSecondary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 10, color: TrizanTheme.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      TrizanTheme.formatShortDate(task.dueDate),
                      style: const TextStyle(fontSize: 10, color: TrizanTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status Interactive Toggles
            Container(
              decoration: BoxDecoration(
                color: TrizanTheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatusToggleButton(
                      label: 'To Do',
                      isActive: task.status == TrizanTaskStatus.todo,
                      activeColor: TrizanTheme.todoColor,
                      onTap: () => state.updateTaskStatus(task.id, TrizanTaskStatus.todo),
                    ),
                  ),
                  Expanded(
                    child: _buildStatusToggleButton(
                      label: 'Working',
                      isActive: task.status == TrizanTaskStatus.inProgress,
                      activeColor: TrizanTheme.progressColor,
                      onTap: () => state.updateTaskStatus(task.id, TrizanTaskStatus.inProgress),
                    ),
                  ),
                  Expanded(
                    child: _buildStatusToggleButton(
                      label: 'Done',
                      isActive: task.status == TrizanTaskStatus.done,
                      activeColor: TrizanTheme.completedColor,
                      onTap: () => state.updateTaskStatus(task.id, TrizanTaskStatus.done),
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

  Widget _buildStatusToggleButton({
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.black : TrizanTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TrizanState state) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    TrizanUser selectedAssignee = state.users[0];
    TrizanTaskPriority selectedPriority = TrizanTaskPriority.medium;
    DateTime selectedDate = DateTime.now().add(const Duration(days: 3));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: TrizanTheme.surface,
              title: const Text('Post Interactive Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Task Title'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    // Assignee Dropdown
                    DropdownButtonFormField<TrizanUser>(
                      value: selectedAssignee,
                      decoration: const InputDecoration(labelText: 'Assign To'),
                      items: state.users.map((user) {
                        return DropdownMenuItem<TrizanUser>(
                          value: user,
                          child: Text(user.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedAssignee = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // Priority Dropdown
                    DropdownButtonFormField<TrizanTaskPriority>(
                      value: selectedPriority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: TrizanTaskPriority.values.map((p) {
                        return DropdownMenuItem<TrizanTaskPriority>(
                          value: p,
                          child: Text(p.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedPriority = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // Date picker field
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Due Date: ${TrizanTheme.formatShortDate(selectedDate)}'),
                      trailing: const Icon(Icons.date_range_rounded, color: TrizanTheme.accentLight),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null) {
                          setDialogState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      state.addTask(
                        titleController.text.trim(),
                        descController.text.trim(),
                        selectedAssignee,
                        selectedPriority,
                        selectedDate,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Post Task Card'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ==========================================
// VIEW 2: TASK BOARD (Kanban style columns)
// ==========================================

class TrizanBoardView extends StatefulWidget {
  const TrizanBoardView({Key? key}) : super(key: key);

  @override
  State<TrizanBoardView> createState() => _TrizanBoardViewState();
}

class _TrizanBoardViewState extends State<TrizanBoardView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _assigneeFilter = 'all'; // 'all' or userId
  String _priorityFilter = 'all'; // 'all', 'low', 'medium', 'high'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = TrizanState();

    // Filtered tasks for the current project
    final projectTasks = state.tasks.where((t) => t.projectId == state.activeProject.id).toList();

    // Secondary filtering by assignee, priority, search text
    final filteredTasks = projectTasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesAssignee = _assigneeFilter == 'all' || task.assigneeId == _assigneeFilter;
      
      final matchesPriority = _priorityFilter == 'all' || task.priority.name == _priorityFilter;

      return matchesSearch && matchesAssignee && matchesPriority;
    }).toList();

    final todoTasks = filteredTasks.where((t) => t.status == TrizanTaskStatus.todo).toList();
    final progressTasks = filteredTasks.where((t) => t.status == TrizanTaskStatus.inProgress).toList();
    final doneTasks = filteredTasks.where((t) => t.status == TrizanTaskStatus.done).toList();

    return Column(
      children: [
        // Search & Filter Panel
        Container(
          padding: const EdgeInsets.all(12),
          color: TrizanTheme.surface,
          child: Column(
            children: [
              // Search input
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search tasks by title...',
                  prefixIcon: Icon(Icons.search, size: 18),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
              const SizedBox(height: 8),
              // Dropdown Filters
              Row(
                children: [
                  // Assignee Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: TrizanTheme.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _assigneeFilter,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          items: [
                            const DropdownMenuItem(value: 'all', child: Text('All Members')),
                            ...state.users.map((u) => DropdownMenuItem(value: u.id, child: Text(u.name))),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _assigneeFilter = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Priority Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: TrizanTheme.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _priorityFilter,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All Priorities')),
                            DropdownMenuItem(value: 'low', child: Text('Low Priority')),
                            DropdownMenuItem(value: 'medium', child: Text('Medium Priority')),
                            DropdownMenuItem(value: 'high', child: Text('High Priority')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _priorityFilter = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Column Tab Header (Segmented control layout)
        TabBar(
          controller: _tabController,
          indicatorColor: TrizanTheme.accentLight,
          labelColor: Colors.white,
          unselectedLabelColor: TrizanTheme.textSecondary,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'To Do (${todoTasks.length})'),
            Tab(text: 'Working (${progressTasks.length})'),
            Tab(text: 'Done (${doneTasks.length})'),
          ],
        ),

        // Columns Views content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBoardColumn(todoTasks, state),
              _buildBoardColumn(progressTasks, state),
              _buildBoardColumn(doneTasks, state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoardColumn(List<TrizanTask> columnTasks, TrizanState state) {
    if (columnTasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found in this section.',
          style: TextStyle(color: TrizanTheme.textSecondary, fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: columnTasks.length,
      itemBuilder: (context, index) {
        final task = columnTasks[index];
        final assignee = state.users.firstWhere((u) => u.id == task.assigneeId,
            orElse: () => TrizanUser(id: 'unknown', name: 'Unknown User', role: 'Team Member', avatarUrl: ''));

        Color priorityColor = TrizanTheme.todoColor;
        if (task.priority == TrizanTaskPriority.medium) priorityColor = TrizanTheme.progressColor;
        if (task.priority == TrizanTaskPriority.high) priorityColor = TrizanTheme.errorColor;

        return Card(
          color: TrizanTheme.cardBg,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showTaskDetailsBottomSheet(context, task, state),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Priority Label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.priority.name.toUpperCase(),
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: priorityColor),
                        ),
                      ),
                      // Quick Status Shift actions
                      Row(
                        children: [
                          if (task.status != TrizanTaskStatus.todo)
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 12),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                final prevStatus = task.status == TrizanTaskStatus.done
                                    ? TrizanTaskStatus.inProgress
                                    : TrizanTaskStatus.todo;
                                state.updateTaskStatus(task.id, prevStatus);
                              },
                            ),
                          const SizedBox(width: 8),
                          if (task.status != TrizanTaskStatus.done)
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                final nextStatus = task.status == TrizanTaskStatus.todo
                                    ? TrizanTaskStatus.inProgress
                                    : TrizanTaskStatus.done;
                                state.updateTaskStatus(task.id, nextStatus);
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: TrizanTheme.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.white12,
                            child: Text(assignee.name[0], style: const TextStyle(fontSize: 7, color: Colors.white)),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            assignee.name,
                            style: const TextStyle(fontSize: 11, color: TrizanTheme.textSecondary),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 10, color: TrizanTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            TrizanTheme.formatShortDate(task.dueDate),
                            style: const TextStyle(fontSize: 10, color: TrizanTheme.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTaskDetailsBottomSheet(BuildContext context, TrizanTask task, TrizanState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TrizanTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final assignee = state.users.firstWhere((u) => u.id == task.assigneeId, orElse: () => state.users[0]);
            
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Task Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever_rounded, color: TrizanTheme.errorColor),
                        onPressed: () {
                          state.deleteTask(task.id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Task deleted.')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    task.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 12, color: TrizanTheme.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),

                  // Reassign row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Assignee:', style: TextStyle(fontSize: 12, color: TrizanTheme.textSecondary)),
                      DropdownButton<String>(
                        value: task.assigneeId,
                        dropdownColor: TrizanTheme.cardBg,
                        underline: const SizedBox.shrink(),
                        items: state.users.map((u) {
                          return DropdownMenuItem<String>(
                            value: u.id,
                            child: Text(u.name, style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          if (newVal != null) {
                            state.updateTaskAssignee(task.id, newVal);
                            setSheetState(() {});
                          }
                        },
                      ),
                    ],
                  ),

                  // Status shift row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status:', style: TextStyle(fontSize: 12, color: TrizanTheme.textSecondary)),
                      DropdownButton<TrizanTaskStatus>(
                        value: task.status,
                        dropdownColor: TrizanTheme.cardBg,
                        underline: const SizedBox.shrink(),
                        items: TrizanTaskStatus.values.map((status) {
                          String label = 'To Do';
                          if (status == TrizanTaskStatus.inProgress) label = 'In Progress';
                          if (status == TrizanTaskStatus.done) label = 'Completed';
                          return DropdownMenuItem<TrizanTaskStatus>(
                            value: status,
                            child: Text(label, style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (newStatus) {
                          if (newStatus != null) {
                            state.updateTaskStatus(task.id, newStatus);
                            setSheetState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ==========================================
// VIEW 3: LEADERBOARD & METRICS (Analytics)
// ==========================================

class TrizanAnalyticsView extends StatelessWidget {
  const TrizanAnalyticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = TrizanState();

    // Active project statistics calculations
    final projectTasks = state.tasks.where((t) => t.projectId == state.activeProject.id).toList();
    final totalCount = projectTasks.length;
    final doneCount = projectTasks.where((t) => t.status == TrizanTaskStatus.done).length;
    final progressCount = projectTasks.where((t) => t.status == TrizanTaskStatus.inProgress).length;
    final todoCount = projectTasks.where((t) => t.status == TrizanTaskStatus.todo).length;
    
    final completionRate = totalCount > 0 ? (doneCount / totalCount) : 0.0;
    
    // Sort users by performance rate
    final List<Map<String, dynamic>> leaderboardData = [];
    for (var user in state.users) {
      final userTasks = state.tasks.where((t) => t.assigneeId == user.id && t.projectId == state.activeProject.id).toList();
      final userCompleted = userTasks.where((t) => t.status == TrizanTaskStatus.done).length;
      final userTotal = userTasks.length;
      final userRate = userTotal > 0 ? (userCompleted / userTotal) : 1.0; // 100% completed if no tasks assigned
      
      leaderboardData.add({
        'user': user,
        'completed': userCompleted,
        'total': userTotal,
        'rate': userRate,
      });
    }

    // Sort: highest rate first. If rate is same, sort by total tasks completed
    leaderboardData.sort((a, b) {
      final rateCompare = (b['rate'] as double).compareTo(a['rate'] as double);
      if (rateCompare != 0) return rateCompare;
      return (b['completed'] as int).compareTo(a['completed'] as int);
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Health Radial Card
          Card(
            color: TrizanTheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Circular Progress Indicator
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: completionRate,
                          strokeWidth: 8,
                          backgroundColor: TrizanTheme.cardBg,
                          valueColor: const AlwaysStoppedAnimation<Color>(TrizanTheme.completedColor),
                        ),
                      ),
                      Text(
                        '${(completionRate * 100).toInt()}%',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  // Text stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Project Completion',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Overall progress for group #${state.activeProject.name}',
                          style: const TextStyle(fontSize: 11, color: TrizanTheme.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatText('Total', '$totalCount'),
                            _buildStatText('Todo', '$todoCount'),
                            _buildStatText('Working', '$progressCount'),
                            _buildStatText('Completed', '$doneCount'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Team Productivity Leaderboard
          const Text(
            'TEAM LEADERBOARD',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: TrizanTheme.textSecondary),
          ),
          const SizedBox(height: 10),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leaderboardData.length,
            itemBuilder: (context, index) {
              final data = leaderboardData[index];
              final user = data['user'] as TrizanUser;
              final completed = data['completed'] as int;
              final total = data['total'] as int;
              final rate = data['rate'] as double;
              final percentage = (rate * 100).toInt();

              // Highlight first place
              final isFirst = index == 0 && completed > 0;

              return Card(
                color: isFirst ? TrizanTheme.accent.withOpacity(0.08) : TrizanTheme.surface,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isFirst ? TrizanTheme.accentLight.withOpacity(0.3) : Colors.white10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      // Rank indicator
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isFirst ? TrizanTheme.progressColor : Colors.white10,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 11, 
                            fontWeight: FontWeight.bold,
                            color: isFirst ? Colors.black : Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user.role,
                              style: const TextStyle(fontSize: 10, color: TrizanTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),

                      // Completion Rate Bar & Ratio
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$completed/$total tasks done',
                                style: const TextStyle(fontSize: 11, color: TrizanTheme.textSecondary),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: rate == 1.0 && total > 0
                                      ? TrizanTheme.completedColor.withOpacity(0.12)
                                      : TrizanTheme.cardBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '$percentage%',
                                  style: TextStyle(
                                    fontSize: 10, 
                                    fontWeight: FontWeight.bold,
                                    color: rate == 1.0 && total > 0
                                        ? TrizanTheme.completedColor
                                        : TrizanTheme.accentLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),

          // Priority Task Load Breakdown
          const Text(
            'PRIORITY WORKLOAD',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: TrizanTheme.textSecondary),
          ),
          const SizedBox(height: 10),
          _buildPriorityDistributionCard(projectTasks),
        ],
      ),
    );
  }

  Widget _buildStatText(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 9, color: TrizanTheme.textSecondary)),
      ],
    );
  }

  Widget _buildPriorityDistributionCard(List<TrizanTask> projectTasks) {
    final total = projectTasks.length;
    final high = projectTasks.where((t) => t.priority == TrizanTaskPriority.high).length;
    final med = projectTasks.where((t) => t.priority == TrizanTaskPriority.medium).length;
    final low = projectTasks.where((t) => t.priority == TrizanTaskPriority.low).length;

    final highPercent = total > 0 ? (high / total) : 0.0;
    final medPercent = total > 0 ? (med / total) : 0.0;
    final lowPercent = total > 0 ? (low / total) : 0.0;

    return Card(
      color: TrizanTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPriorityBar('High Priority', high, highPercent, TrizanTheme.errorColor),
            const SizedBox(height: 12),
            _buildPriorityBar('Medium Priority', med, medPercent, TrizanTheme.progressColor),
            const SizedBox(height: 12),
            _buildPriorityBar('Low Priority', low, lowPercent, TrizanTheme.todoColor),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBar(String label, int count, double ratio, Color barColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            Text('$count tasks (${(ratio * 100).toInt()}%)', style: const TextStyle(fontSize: 10, color: TrizanTheme.textSecondary)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: TrizanTheme.cardBg,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
