import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
// import 'dart:math'; // Redundant, min is also in flutter_animate
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math'; // Keep for Random

class RelationshipTimerPage extends StatefulWidget {
  const RelationshipTimerPage({super.key});

  @override
  _RelationshipTimerPageState createState() => _RelationshipTimerPageState();
}

class _RelationshipTimerPageState extends State<RelationshipTimerPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  // Dates storage
  DateTime? relationshipStartDate;
  DateTime? firstKissDate;
  DateTime? firstHugDate;
  DateTime? firstChatDate;
  DateTime? firstDateDate;
  DateTime? nextAnniversary;

  // User data
  String partnerName1 = "You";
  String partnerName2 = "Your Love";

  // UI State
  double flowerGrowth = 0.1;
  String dailyMessage = "Loading your special message...";
  bool _isLoading = true;

  // API
  // final String nvidiaApiUrl =
  //     "https://api.nvidia.com/love-quotes "; // Unused variable

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _colorAnimation = ColorTween(
      begin: Colors.pink[200],
      end: Colors.red[400],
    ).animate(_animationController);

    _animationController.repeat(reverse: true);

    _loadData();
    _fetchDailyMessage();
    _scheduleNotifications();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      relationshipStartDate = DateTime.parse(
        prefs.getString('relationshipStartDate') ?? DateTime.now().toString(),
      );
      firstKissDate =
          prefs.getString('firstKissDate') != null
              ? DateTime.parse(prefs.getString('firstKissDate')!)
              : null;
      firstHugDate =
          prefs.getString('firstHugDate') != null
              ? DateTime.parse(prefs.getString('firstHugDate')!)
              : null;
      firstChatDate =
          prefs.getString('firstChatDate') != null
              ? DateTime.parse(prefs.getString('firstChatDate')!)
              : null;
      firstDateDate =
          prefs.getString('firstDateDate') != null
              ? DateTime.parse(prefs.getString('firstDateDate')!)
              : null;
      partnerName1 = prefs.getString('partnerName1') ?? "You";
      partnerName2 = prefs.getString('partnerName2') ?? "Your Love";

      // Calculate flower growth based on relationship duration
      final duration = DateTime.now().difference(relationshipStartDate!);
      flowerGrowth = min(
        1.0,
        duration.inDays / 365 * 0.5 + 0.1,
      ); // Grows over time, max at 1.0

      // Calculate next anniversary
      nextAnniversary = _calculateNextAnniversary();

      _isLoading = false;
    });
  }

  DateTime _calculateNextAnniversary() {
    final now = DateTime.now();
    final start = relationshipStartDate!;
    var next = DateTime(now.year, start.month, start.day);

    if (next.isBefore(now)) {
      next = DateTime(now.year + 1, start.month, start.day);
    }

    return next;
  }

  Future<void> _fetchDailyMessage() async {
    try {
      // In a real app, you would call the NVIDIA API here
      // final response = await http.get(Uri.parse(nvidiaApiUrl));
      // final data = json.decode(response.body);

      // Simulating API response
      await Future.delayed(Duration(seconds: 1));

      final messages = [
        "Every moment with you feels like the first time we met - magical and unforgettable.",
        "Your love is the poetry my heart writes every day.",
        "In your arms is where I find my home, my peace, and my wildest dreams.",
        "The way you look at me makes time stand still.",
        "Our love story is my favorite. Let's keep adding chapters.",
        "You're the reason I believe in forever.",
        "With you, every day is Valentine's Day.",
        "Your touch sets my soul on fire in the most beautiful way.",
        "I fall in love with you more with each sunrise we share.",
        "Our love is the kind that legends are made of.",
      ];

      final random = Random();
      setState(() {
        dailyMessage = messages[random.nextInt(messages.length)];
      });
    } catch (e) {
      setState(() {
        dailyMessage = "My heart skips a beat every time I think of you.";
      });
    }
  }

  Future<void> _scheduleNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Initialize notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create notification channel
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'daily_love_reminder',
          'Love Reminders',
          channelDescription: 'Daily romantic messages for your relationship',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          color: Colors.pink,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Schedule daily notification
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Love Reminder ❤️',
      dailyMessage,
      RepeatInterval.daily,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    // Schedule anniversary notification if needed
    if (nextAnniversary != null) {
      final daysUntilAnniversary =
          nextAnniversary!.difference(DateTime.now()).inDays;

      if (daysUntilAnniversary <= 30) {
        await flutterLocalNotificationsPlugin.show(
          1,
          'Anniversary Coming!',
          'Only $daysUntilAnniversary days until your ${_getAnniversaryNumber()} anniversary!',
          platformChannelSpecifics,
        );
      }
    }
  }

  String _getAnniversaryNumber() {
    final years =
        DateTime.now().difference(relationshipStartDate!).inDays ~/ 365;
    if (years == 1) return '1st';
    if (years == 2) return '2nd';
    if (years == 3) return '3rd';
    return '${years}th';
  }

  Future<void> _editDate(String key, DateTime? currentDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.pink,
              onPrimary: Colors.white,
              surface: Colors.pink[100]!,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.pink[50]),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, date.toString());
      _loadData();
    }
  }

  String _formatDuration(Duration duration) {
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;
    final days = (duration.inDays % 365) % 30;

    return '$years years, $months months, $days days';
  }

  String _formatCountdown(Duration duration) {
    if (duration.inDays > 30) {
      return '${duration.inDays ~/ 30} months ${duration.inDays % 30} days';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} days ${duration.inHours % 24} hours';
    } else {
      return '${duration.inHours} hours ${duration.inMinutes % 60} minutes';
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade50, Colors.purple.shade50],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),

                  // Header with couple names
                  Center(
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Text(
                            '$partnerName1 & $partnerName2',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[800],
                              fontFamily: 'Pacifico',
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  // Relationship duration
                  _buildRomanticCard(
                    child: Column(
                      children: [
                        Text(
                          'Together for',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.pink[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _formatDuration(
                            DateTime.now().difference(relationshipStartDate!),
                          ),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[900],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'since ${DateFormat('MMMM d, y').format(relationshipStartDate!)}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.pink[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.pink),
                          onPressed:
                              () => _editDate(
                                'relationshipStartDate',
                                relationshipStartDate,
                              ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Growing flower visualization
                  _buildRomanticCard(
                    child: Column(
                      children: [
                        Text(
                          'Our Love Blooms',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Flower pot
                            Container(
                              width: 120,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.brown[400],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),

                            // Flower stem
                            Positioned(
                              bottom: 40,
                              child: Container(
                                width: 8,
                                height: 100 * flowerGrowth,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green[600]!,
                                      Colors.green[400]!,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),

                            // Flower petals
                            Positioned(
                              top: 100 - (100 * flowerGrowth),
                              child: Transform.scale(
                                scale: flowerGrowth,
                                child: Animate(
                                  effects: [
                                    ShakeEffect(
                                      duration: Duration(seconds: 2),
                                      hz: 0.5,
                                      curve: Curves.easeInOut,
                                    ),
                                  ],
                                  child: Icon(
                                    Icons.eco,
                                    color: Colors.pink,
                                    size: 60,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: flowerGrowth,
                          backgroundColor: Colors.pink[100],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.pink,
                          ),
                          minHeight: 10,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${(flowerGrowth * 100).toStringAsFixed(1)}% of our love journey',
                          style: TextStyle(
                            color: Colors.pink[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Special moments timeline
                  _buildRomanticCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Our Special Moments',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildMomentItem(
                          icon: Icons.favorite,
                          title: 'First Date',
                          date: firstDateDate,
                          onEdit:
                              () => _editDate('firstDateDate', firstDateDate),
                        ),
                        _buildMomentItem(
                          icon: Icons.chat,
                          title: 'First Chat',
                          date: firstChatDate,
                          onEdit:
                              () => _editDate('firstChatDate', firstChatDate),
                        ),
                        _buildMomentItem(
                          icon: Icons.people,
                          title: 'First Hug',
                          date: firstHugDate,
                          onEdit: () => _editDate('firstHugDate', firstHugDate),
                        ),
                        _buildMomentItem(
                          icon: Icons.face,
                          title: 'First Kiss',
                          date: firstKissDate,
                          onEdit:
                              () => _editDate('firstKissDate', firstKissDate),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Countdowns
                  _buildRomanticCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Countdowns',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildCountdownItem(
                          title: 'Next Anniversary',
                          date: nextAnniversary!,
                          color: Colors.pink,
                        ),
                        _buildCountdownItem(
                          title: "Valentine's Day",
                          date: _calculateNextValentinesDay(),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Daily romantic message
                  _buildRomanticCard(
                    child: Column(
                      children: [
                        Text(
                          "Today's Love Note",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        AnimatedBuilder(
                          animation: _colorAnimation,
                          builder: (context, child) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _colorAnimation.value!.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _colorAnimation.value!,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                dailyMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.pink[900],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _fetchDailyMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'New Message',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),

            // Confetti effect
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.pink,
                  Colors.red,
                  Colors.purple,
                  Colors.white,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _calculateNextValentinesDay() {
    final now = DateTime.now();
    var valentines = DateTime(now.year, 2, 14);

    if (valentines.isBefore(now)) {
      valentines = DateTime(now.year + 1, 2, 14);
    }

    return valentines;
  }

  Widget _buildRomanticCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.pink.withOpacity(0.3), width: 1),
      ),
      child: child,
    );
  }

  Widget _buildMomentItem({
    required IconData icon,
    required String title,
    required DateTime? date,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.pink),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[800],
                  ),
                ),
                Text(
                  date != null
                      ? DateFormat('MMMM d, y').format(date)
                      : 'Not set yet',
                  style: TextStyle(
                    color: date != null ? Colors.pink[600] : Colors.grey,
                    fontStyle:
                        date != null ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.pink),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownItem({
    required String title,
    required DateTime date,
    required Color color,
  }) {
    final duration = date.difference(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            DateFormat('MMMM d, y').format(date),
            style: TextStyle(color: Colors.pink[600]),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              _formatCountdown(duration),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
