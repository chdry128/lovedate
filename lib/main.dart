import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heart_beat/question_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dateCalc.dart';
import 'game_screen.dart';
import 'name.dart';
import 'zodicMatch.dart';
import 'quoteGen.dart';
import 'loveCalc.dart';
import 'package:heart_beat/IntenCalc.dart';
import 'question_repo.dart';
import 'theam.dart';

// App routes for better navigation
class AppRoutes {
  static const String home = '/';
  static const String loveCalculator = '/love-calculator';
  static const String intensityCalculator = '/intensity-calculator';
  static const String compatibility = '/compatibility';
  static const String quotes = '/quotes';
  static const String nameMatch = '/name-match';
  static const String loveGame = '/love-game';
  static const String relationshipTimer = '/relationship-timer';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for better user experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('wyrQuestions');
  Hive.registerAdapter(QuestionIntensityAdapter());
  Hive.registerAdapter(WYRQuestionAdapter());

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<QuestionRepository>(create: (_) => QuestionRepository()),
        // Add more providers if needed
      ],
      child: MaterialApp(
        title: 'Heart Beats',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Respect system theme
        home: const HomePage(),
        routes: {
          AppRoutes.loveCalculator: (context) => const LoveCalculatorApp(),
          AppRoutes.intensityCalculator: (context) => const SexIntensityApp(),
          AppRoutes.compatibility: (context) => const ZodicApp(),
          AppRoutes.quotes: (context) => RomanticQuotesPage(),
          AppRoutes.nameMatch: (context) => const NameCompatibilityPage(),
          AppRoutes.loveGame:
              (context) =>
                  GameScreen(intensityFilter: QuestionIntensity.flirty),
          AppRoutes.relationshipTimer: (context) => RelationshipTimerPage(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive grid count based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade900,
              Colors.red.shade800,
              Colors.pink.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // App Title & Subtitle
              _buildAppHeader(context),

              // Decorative Element
              const SizedBox(height: 10),
              _buildHeartIcons(),
              const SizedBox(height: 20),

              // Calculator Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.85,
                    padding: const EdgeInsets.all(8.0),
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    children: [
                      _buildCalculatorCard(
                        context,
                        title: "Love Calculator",
                        icon: Icons.favorite_border,
                        description: "Check your love compatibility",
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.loveCalculator,
                            ),
                        semanticLabel: "Open Love Calculator",
                      ),
                      _buildCalculatorCard(
                        context,
                        title: "Intensity Calculator",
                        icon: Icons.local_fire_department_outlined,
                        description: "Measure your passion intensity",
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.intensityCalculator,
                            ),
                        color: Colors.redAccent,
                        semanticLabel: "Open Intensity Calculator",
                      ),
                      _buildCalculatorCard(
                        context,
                        title: "Zodiac Compatibility",
                        icon: Icons.star_border,
                        description: "Based on zodiac signs",
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.compatibility,
                            ),
                        color: Colors.purpleAccent,
                        semanticLabel: "Open Zodiac Compatibility",
                      ),
                      _buildCalculatorCard(
                        context,
                        title: "Romantic Quotes",
                        icon: Icons.format_quote_outlined,
                        description: "Generate perfect quotes for love",
                        onPressed:
                            () =>
                                Navigator.pushNamed(context, AppRoutes.quotes),
                        color: Colors.orangeAccent,
                        semanticLabel: "Open Romantic Quotes Generator",
                      ),
                      _buildCalculatorCard(
                        context,
                        title: "Name Match",
                        icon: Icons.people_outline,
                        description: "Check name compatibility",
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.nameMatch,
                            ),
                        color: Colors.teal,
                        semanticLabel: "Open Name Compatibility",
                      ),
                      _buildCalculatorCard(
                        context,
                        title: "Love Game",
                        icon: Icons.games_outlined,
                        description: "Fun game for couples",
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.loveGame,
                            ),
                        color: Colors.deepPurpleAccent,
                        semanticLabel: "Open Love Game",
                      ),
                      _buildCalculatorCard(
                        context,
                        title: "Relationship Timer",
                        icon: Icons.timer_outlined,
                        description: "Track your love journey",
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              AppRoutes.relationshipTimer,
                            ),
                        color: Colors.blueAccent,
                        semanticLabel: "Open Relationship Timer",
                      ),
                    ],
                  ),
                ),
              ),

              // Footer Text
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Hero(
            tag: 'app_title',
            child: const Text(
              "Heart Beats",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Discover your romantic compatibility",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeartIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.favorite, color: Colors.pink.shade300, size: 40),
        const SizedBox(width: 8),
        Icon(Icons.favorite, color: Colors.white, size: 42),
        const SizedBox(width: 8),
        Icon(Icons.favorite, color: Colors.pink.shade300, size: 40),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
      child: Text(
        "Find the magic in your relationship",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
    required VoidCallback onPressed,
    Color color = Colors.pinkAccent,
    required String semanticLabel,
  }) {
    return Hero(
      tag: title,
      child: Semantics(
        label: semanticLabel,
        button: true,
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          color: Colors.white.withOpacity(0.1),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(17),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.6), color.withOpacity(0.8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 40, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
