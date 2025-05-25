import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'theam.dart';
import 'models/zodiac_model.dart';
import 'services/astrology_service.dart';
import 'services/location_service.dart';
import 'widgets/zodiac_widgets.dart';
import 'widgets/compatibility_details.dart';
import 'widgets/cosmic_background.dart';

void main() {
  runApp(const ZodicApp());
}

class ZodicApp extends StatelessWidget {
  const ZodicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Connection',
      theme: AppTheme.lightTheme,
      home: const ZodicScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ZodicScreen extends StatefulWidget {
  const ZodicScreen({super.key});

  @override
  _ZodicScreenState createState() => _ZodicScreenState();
}

class _ZodicScreenState extends State<ZodicScreen>
    with SingleTickerProviderStateMixin {
  final _nameController1 = TextEditingController();
  final _nameController2 = TextEditingController();
  final _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );

  late TabController _tabController;

  DateTime? _birthDateTime1;
  DateTime? _birthDateTime2;

  String _city1 = "", _country1 = "";
  String _city2 = "", _country2 = "";

  String _sunSign1 = '', _moonSign1 = '', _risingSign1 = '';
  String _sunSign2 = '', _moonSign2 = '', _risingSign2 = '';

  CompatibilityResult? _compatibilityResult;
  bool _isCalculating = false;
  bool _showResult = false;

  int _expandedCardIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Set default values for testing
    _nameController1.text = "Alex";
    _nameController2.text = "Jordan";
    _birthDateTime1 = DateTime(1990, 5, 15, 8, 30);
    _birthDateTime2 = DateTime(1992, 9, 22, 14, 45);
    _city1 = "New York";
    _country1 = "USA";
    _city2 = "London";
    _country2 = "UK";
  }

  void _calculateCompatibility() {
    if (_nameController1.text.isEmpty ||
        _nameController2.text.isEmpty ||
        _birthDateTime1 == null ||
        _birthDateTime2 == null ||
        _city1.isEmpty ||
        _country1.isEmpty ||
        _city2.isEmpty ||
        _country2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all details for both persons."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isCalculating = true;
    });

    // Simulate API call with a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      // Step 1: Calculate Signs
      _sunSign1 = ZodiacData.getSunSign(
        _birthDateTime1!.day,
        _birthDateTime1!.month,
      );
      _sunSign2 = ZodiacData.getSunSign(
        _birthDateTime2!.day,
        _birthDateTime2!.month,
      );

      _moonSign1 = AstrologyService.getMoonSign(_birthDateTime1!);
      _moonSign2 = AstrologyService.getMoonSign(_birthDateTime2!);

      // Get coordinates for rising sign calculation
      final coords1 = LocationService.getCoordinates(_city1, _country1);
      final coords2 = LocationService.getCoordinates(_city2, _country2);

      _risingSign1 = AstrologyService.getRisingSign(
        _birthDateTime1!,
        coords1['latitude']!,
        coords1['longitude']!,
      );

      _risingSign2 = AstrologyService.getRisingSign(
        _birthDateTime2!,
        coords2['latitude']!,
        coords2['longitude']!,
      );

      // Step 2: Calculate Compatibility
      _compatibilityResult = ZodiacData.calculateCompatibility(
        _sunSign1,
        _sunSign2,
      );

      setState(() {
        _isCalculating = false;
        _showResult = true;
      });

      // Play confetti if score is high
      if (_compatibilityResult!.score >= 70) {
        _confettiController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Cosmic Background
          CosmicBackground(
            color1: Colors.deepPurple.shade900,
            color2: Colors.purple.shade800,
            color3: Colors.indigo.shade900,
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      Text(
                            "Cosmic Connection",
                            style: AppTheme.titleStyle.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: -0.2, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        "Discover your zodiac compatibility",
                        style: AppTheme.subtitleStyle.copyWith(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child:
                          _showResult ? _buildResultView() : _buildInputView(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 1,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: const [
                Colors.pink,
                Colors.purple,
                Colors.blue,
                Colors.red,
                Colors.orange,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputView() {
    return Column(
      children: [
        // Tabs
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.person), text: "Person 1"),
              Tab(icon: Icon(Icons.favorite), text: "Person 2"),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Person 1 Form
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController1,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DateTimeInput(
                      label: "Birth Date & Time",
                      value: _birthDateTime1,
                      onChanged: (dateTime) {
                        setState(() {
                          _birthDateTime1 = dateTime;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    LocationInput(
                      label: "Birth Location",
                      city: _city1,
                      country: _country1,
                      onChanged: (city, country) {
                        setState(() {
                          _city1 = city;
                          _country1 = country;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: GradientButton(
                        text: "Next",
                        onPressed: () {
                          _tabController.animateTo(1);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Person 2 Form
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController2,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DateTimeInput(
                      label: "Birth Date & Time",
                      value: _birthDateTime2,
                      onChanged: (dateTime) {
                        setState(() {
                          _birthDateTime2 = dateTime;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    LocationInput(
                      label: "Birth Location",
                      city: _city2,
                      country: _country2,
                      onChanged: (city, country) {
                        setState(() {
                          _city2 = city;
                          _country2 = country;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: GradientButton(
                        text: "Calculate Compatibility",
                        isLoading: _isCalculating,
                        onPressed: _calculateCompatibility,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    if (_compatibilityResult == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header with back button
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    _showResult = false;
                    _expandedCardIndex = -1;
                  });
                },
              ),
              const Expanded(
                child: Text(
                  "Your Compatibility Results",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
          const SizedBox(height: 20),

          // Compatibility Result Card
          CompatibilityResultCard(result: _compatibilityResult!),

          // Person 1 Details
          const SizedBox(height: 20),
          const Text(
            "Astrological Profile",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ZodiacCard(
            sign: _sunSign1,
            personName: "${_nameController1.text}'s Sun Sign",
            isExpanded: _expandedCardIndex == 0,
            onTap: () {
              setState(() {
                _expandedCardIndex = _expandedCardIndex == 0 ? -1 : 0;
              });
            },
          ),

          ZodiacCard(
            sign: _moonSign1,
            personName: "${_nameController1.text}'s Moon Sign",
            isExpanded: _expandedCardIndex == 1,
            onTap: () {
              setState(() {
                _expandedCardIndex = _expandedCardIndex == 1 ? -1 : 1;
              });
            },
          ),

          ZodiacCard(
            sign: _risingSign1,
            personName: "${_nameController1.text}'s Rising Sign",
            isExpanded: _expandedCardIndex == 2,
            onTap: () {
              setState(() {
                _expandedCardIndex = _expandedCardIndex == 2 ? -1 : 2;
              });
            },
          ),

          const SizedBox(height: 20),

          // Person 2 Details
          ZodiacCard(
            sign: _sunSign2,
            personName: "${_nameController2.text}'s Sun Sign",
            isExpanded: _expandedCardIndex == 3,
            onTap: () {
              setState(() {
                _expandedCardIndex = _expandedCardIndex == 3 ? -1 : 3;
              });
            },
          ),

          ZodiacCard(
            sign: _moonSign2,
            personName: "${_nameController2.text}'s Moon Sign",
            isExpanded: _expandedCardIndex == 4,
            onTap: () {
              setState(() {
                _expandedCardIndex = _expandedCardIndex == 4 ? -1 : 4;
              });
            },
          ),

          ZodiacCard(
            sign: _risingSign2,
            personName: "${_nameController2.text}'s Rising Sign",
            isExpanded: _expandedCardIndex == 5,
            onTap: () {
              setState(() {
                _expandedCardIndex = _expandedCardIndex == 5 ? -1 : 5;
              });
            },
          ),

          const SizedBox(height: 30),

          // Detailed Compatibility Analysis
          CompatibilityDetails(
            sign1: _sunSign1,
            sign2: _sunSign2,
            person1: _nameController1.text,
            person2: _nameController2.text,
          ),

          const SizedBox(height: 30),

          // Calculate Again Button
          GradientButton(
            text: "Calculate Again",
            onPressed: () {
              setState(() {
                _showResult = false;
                _expandedCardIndex = -1;
              });
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController1.dispose();
    _nameController2.dispose();
    _tabController.dispose();
    _confettiController.dispose();
    super.dispose();
  }
}
