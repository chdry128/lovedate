import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theam.dart';
import 'widgets/cosmic_background.dart';
import 'widgets/letter_background.dart';
import 'widgets/letter_preview.dart';
import 'services/ai_letter_service.dart';

class LoveLetterGeneratorPage extends StatefulWidget {
  const LoveLetterGeneratorPage({super.key});

  @override
  _LoveLetterGeneratorPageState createState() =>
      _LoveLetterGeneratorPageState();
}

class _LoveLetterGeneratorPageState extends State<LoveLetterGeneratorPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _yourNameController = TextEditingController();
  final _partnerNameController = TextEditingController();
  final _specialMemoryController = TextEditingController();
  final _additionalDetailsController = TextEditingController();
  final _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );
  late AnimationController _animationController;

  // Form data
  DateTime? _specialDate;
  String _selectedTone = 'Romantic';
  final List<String> _toneOptions = [
    'Romantic',
    'Playful',
    'Poetic',
    'Passionate',
    'Sweet',
    'Nostalgic',
    'Heartfelt',
  ];

  // UI state
  bool _isGenerating = false;
  bool _showResult = false;
  String _generatedLetter = '';
  bool _isSaved = false;
  List<Map<String, dynamic>> _savedLetters = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Add listeners to update UI when text changes
    _yourNameController.addListener(_updateUI);
    _partnerNameController.addListener(_updateUI);

    _loadSavedData();
  }

  void _updateUI() {
    // This forces a rebuild to update the preview
    if (mounted) setState(() {});
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _yourNameController.text = prefs.getString('yourName') ?? '';
      _partnerNameController.text = prefs.getString('partnerName') ?? '';

      // Load saved letters
      final savedLettersJson = prefs.getStringList('savedLetters') ?? [];
      _savedLetters =
          savedLettersJson
              .map(
                (json) => Map<String, dynamic>.from(
                  Map<String, dynamic>.from({
                    'date': DateTime.now().toString(),
                    'yourName': '',
                    'partnerName': '',
                    'letter': '',
                    'tone': '',
                  }),
                ),
              )
              .toList();
    });
  }

  Future<void> _saveFormData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('yourName', _yourNameController.text);
    await prefs.setString('partnerName', _partnerNameController.text);
  }

  Future<void> _saveLetter() async {
    if (_generatedLetter.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    final newLetter = {
      'date': DateTime.now().toString(),
      'yourName': _yourNameController.text,
      'partnerName': _partnerNameController.text,
      'letter': _generatedLetter,
      'tone': _selectedTone,
    };

    _savedLetters.add(newLetter);

    final savedLettersJson =
        _savedLetters.map((letter) => letter.toString()).toList();

    await prefs.setStringList('savedLetters', savedLettersJson);

    setState(() {
      _isSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Letter saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _generateLetter() async {
    // Only names are required, special date and memories are optional
    if (_yourNameController.text.isEmpty ||
        _partnerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both your name and your partner\'s name'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    // Save form data for future use
    _saveFormData();

    // Format the special date if provided
    final String? formattedDate =
        _specialDate != null
            ? DateFormat('MMMM d, y').format(_specialDate!)
            : null;

    // Try to generate letter using AI API if online
    final aiLetter = await AiLetterService.generateLoveLetter(
      yourName: _yourNameController.text,
      partnerName: _partnerNameController.text,
      specialMemory:
          _specialMemoryController.text.isNotEmpty
              ? _specialMemoryController.text
              : null,
      formattedDate: formattedDate,
      tone: _selectedTone,
      additionalDetails:
          _additionalDetailsController.text.isNotEmpty
              ? _additionalDetailsController.text
              : null,
    );

    // If AI generation was successful, use it; otherwise, fall back to local generation
    final String letter;
    if (aiLetter != null) {
      letter = aiLetter;
      // Show a toast that online generation was used
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Generated online with AI'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Fall back to local generation
      letter = _createLoveLetter(
        _yourNameController.text,
        _partnerNameController.text,
        _specialDate, // Now nullable
        _specialMemoryController.text.isEmpty
            ? null
            : _specialMemoryController.text,
        _selectedTone,
        _additionalDetailsController.text.isEmpty
            ? null
            : _additionalDetailsController.text,
      );
      // Show a toast that offline generation was used
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Generated offline (no internet connection)'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _generatedLetter = letter;
      _isGenerating = false;
      _showResult = true;
      _isSaved = false;
    });

    _confettiController.play();
  }

  String _createLoveLetter(
    String yourName,
    String partnerName,
    DateTime? specialDate,
    String? specialMemory,
    String tone,
    String? additionalDetails,
  ) {
    // Format the special date if provided
    final String? formattedDate =
        specialDate != null
            ? DateFormat('MMMM d, y').format(specialDate)
            : null;

    // Opening lines based on tone
    final List<String> openings = _getOpeningsByTone(tone, partnerName);

    // Body paragraphs based on tone
    final List<String> bodyParagraphs = _getBodyParagraphsByTone(
      tone,
      partnerName,
      specialMemory,
      formattedDate,
      additionalDetails,
    );

    // Closing lines based on tone
    final List<String> closings = _getClosingsByTone(
      tone,
      partnerName,
      yourName,
    );

    // Select random elements from each list
    final random = Random();
    final opening = openings[random.nextInt(openings.length)];

    // Build the letter
    final StringBuffer letter = StringBuffer();
    letter.writeln(opening);
    letter.writeln();

    for (final paragraph in bodyParagraphs) {
      letter.writeln(paragraph);
      letter.writeln();
    }

    final closing = closings[random.nextInt(closings.length)];
    letter.writeln(closing);

    return letter.toString();
  }

  List<String> _getOpeningsByTone(String tone, String partnerName) {
    switch (tone) {
      case 'Romantic':
        return [
          "My dearest $partnerName,",
          "To my beloved $partnerName,",
          "My darling $partnerName,",
        ];
      case 'Playful':
        return [
          "Hey there, gorgeous $partnerName!",
          "To the one who makes me smile, $partnerName,",
          "Hey you, yes you, $partnerName!",
        ];
      case 'Poetic':
        return [
          "To $partnerName, the poetry in my prose,",
          "My dearest $partnerName, light of my heart,",
          "To the one who paints colors in my world, $partnerName,",
        ];
      case 'Passionate':
        return [
          "To my flame, my passion, my $partnerName,",
          "$partnerName, the fire in my soul,",
          "To the one who ignites my heart, $partnerName,",
        ];
      case 'Sweet':
        return [
          "Sweet $partnerName,",
          "To my honey, $partnerName,",
          "My sweet $partnerName,",
        ];
      case 'Nostalgic':
        return [
          "To $partnerName, my journey through time,",
          "My dear $partnerName, as I look back on our story,",
          "$partnerName, my companion through the years,",
        ];
      case 'Heartfelt':
        return [
          "From the depths of my heart to you, $partnerName,",
          "$partnerName, the keeper of my heart,",
          "With all my heart, to my $partnerName,",
        ];
      default:
        return [
          "Dear $partnerName,",
          "To my wonderful $partnerName,",
          "My lovely $partnerName,",
        ];
    }
  }

  List<String> _getBodyParagraphsByTone(
    String tone,
    String partnerName,
    String? specialMemory,
    String? formattedDate,
    String? additionalDetails,
  ) {
    final List<String> paragraphs = [];

    // First paragraph about the special memory if provided
    if (specialMemory != null && specialMemory.isNotEmpty) {
      String memoryParagraph;
      switch (tone) {
        case 'Romantic':
          memoryParagraph =
              "As I think about $specialMemory, my heart fills with warmth and love. That moment is etched in my memory like stars in the night sky, guiding me back to you whenever I feel lost.";
          break;
        case 'Playful':
          memoryParagraph =
              "Remember $specialMemory? I still laugh thinking about it! Who would have thought that moment would become one of my favorite memories? It's these silly, perfect moments that make us, well, us!";
          break;
        case 'Poetic':
          memoryParagraph =
              "The memory of $specialMemory flows through my mind like a gentle stream, carrying with it the essence of our love. In that moment, time stood still, and I saw eternity in your eyes.";
          break;
        case 'Passionate':
          memoryParagraph =
              "$specialMemory ignited something in me that burns to this day. The way you looked, the way you moved, the way you made me feel - it awakened a passion in me I never knew existed.";
          break;
        case 'Sweet':
          memoryParagraph =
              "$specialMemory brings such a sweet smile to my face. It was one of those perfect little moments that reminds me how lucky I am to have you in my life.";
          break;
        case 'Nostalgic':
          memoryParagraph =
              "I find myself drifting back to $specialMemory more often these days. It feels like yesterday and a lifetime ago all at once. That moment was the beginning of something beautiful that continues to grow.";
          break;
        case 'Heartfelt':
          memoryParagraph =
              "When I reflect on $specialMemory, I'm overwhelmed by the depth of my feelings for you. That moment revealed to me the true meaning of love - a meaning I continue to discover with you every day.";
          break;
        default:
          memoryParagraph =
              "I often think about $specialMemory and how special that moment was for us. It's one of the many beautiful memories we've created together.";
      }
      paragraphs.add(memoryParagraph);
    } else {
      // Default first paragraph when no memory is provided
      String defaultParagraph;
      switch (tone) {
        case 'Romantic':
          defaultParagraph =
              "Every day with you feels like a beautiful dream that I never want to wake up from. Your love has transformed my life in ways I never thought possible.";
          break;
        case 'Playful':
          defaultParagraph =
              "You know what's amazing? The way you make even the most ordinary days feel extraordinary. Your smile, your laugh, your silly jokes - they're the highlight of my every day!";
          break;
        case 'Poetic':
          defaultParagraph =
              "In the garden of life, your love blooms like the most exquisite flower, filling my days with beauty and my nights with sweet dreams of you.";
          break;
        case 'Passionate':
          defaultParagraph =
              "The fire you ignite in my soul burns brighter with each passing day. My desire for you is endless, a flame that will never be extinguished.";
          break;
        case 'Sweet':
          defaultParagraph =
              "Your sweetness fills my life with joy. Every moment with you is like tasting honey - pure, sweet, and completely addictive.";
          break;
        case 'Nostalgic':
          defaultParagraph =
              "As I look back on our journey together, I'm filled with gratitude for every step that led me to you. Our story is my favorite one to remember.";
          break;
        case 'Heartfelt':
          defaultParagraph =
              "From the depths of my heart, I want you to know that my love for you grows stronger with each passing day. You are the center of my world.";
          break;
        default:
          defaultParagraph =
              "I wanted to take a moment to express just how much you mean to me. Your presence in my life is a gift I cherish every day.";
      }
      paragraphs.add(defaultParagraph);
    }

    // Second paragraph about the special date if provided
    if (formattedDate != null && formattedDate.isNotEmpty) {
      String dateParagraph;
      switch (tone) {
        case 'Romantic':
          dateParagraph =
              "As $formattedDate approaches, I'm reminded of how blessed I am to have you in my life. Each day with you is a gift, but this date holds a special place in my heart.";
          break;
        case 'Playful':
          dateParagraph =
              "So $formattedDate is coming up! Should I be planning something? Am I planning something? Maybe I am, maybe I'm not... you'll just have to wait and see! (But yes, I definitely am!)";
          break;
        case 'Poetic':
          dateParagraph =
              "$formattedDate marks another chapter in our beautiful story. Like the changing seasons, our love evolves and grows more vibrant with each passing day.";
          break;
        case 'Passionate':
          dateParagraph =
              "When $formattedDate arrives, I want to celebrate every inch of you, every moment we've shared, and every breath we take together. You deserve nothing less than my complete devotion.";
          break;
        case 'Sweet':
          dateParagraph =
              "$formattedDate is going to be so special! I can't wait to see your smile and spend the day showing you just how much you mean to me.";
          break;
        case 'Nostalgic':
          dateParagraph =
              "As we approach $formattedDate, I find myself looking back on our journey. We've come so far together, creating a tapestry of memories that I cherish more than words can express.";
          break;
        case 'Heartfelt':
          dateParagraph =
              "$formattedDate isn't just another day on the calendar - it's a celebration of us, of the love we've built together, and of the blessing you are in my life.";
          break;
        default:
          dateParagraph =
              "$formattedDate is an important day for us, and I wanted to make sure you know how much I care about you and our relationship.";
      }
      paragraphs.add(dateParagraph);
    } else {
      // Default second paragraph when no date is provided
      String defaultDateParagraph;
      switch (tone) {
        case 'Romantic':
          defaultDateParagraph =
              "Every moment with you is precious. I cherish our time together and look forward to creating countless more beautiful memories in the future.";
          break;
        case 'Playful':
          defaultDateParagraph =
              "You make every day an adventure! I never know what fun we'll have next, but I know it'll be amazing because you'll be there.";
          break;
        case 'Poetic':
          defaultDateParagraph =
              "Time stands still when I'm with you, yet races by too quickly. Each second in your presence is a verse in the beautiful poem of our love.";
          break;
        case 'Passionate':
          defaultDateParagraph =
              "My desire for you knows no bounds. Every touch, every glance, every whispered word between us ignites a fire that burns eternally in my soul.";
          break;
        case 'Sweet':
          defaultDateParagraph =
              "Your kindness and warmth make every day brighter. I'm so lucky to have someone as wonderful as you to share life's journey with.";
          break;
        case 'Nostalgic':
          defaultDateParagraph =
              "As we continue writing our story together, I'm grateful for every chapter we've shared and excited for those yet to come.";
          break;
        case 'Heartfelt':
          defaultDateParagraph =
              "The love I feel for you grows deeper with each passing day. You've touched my heart in ways I never thought possible.";
          break;
        default:
          defaultDateParagraph =
              "I treasure our relationship and all the wonderful times we share. You bring so much happiness into my life.";
      }
      paragraphs.add(defaultDateParagraph);
    }

    // Third paragraph with additional details if provided
    if (additionalDetails != null && additionalDetails.isNotEmpty) {
      String detailsParagraph;
      switch (tone) {
        case 'Romantic':
          detailsParagraph =
              "I love everything about you - $additionalDetails. These are the qualities that make my heart skip a beat every time I see you.";
          break;
        case 'Playful':
          detailsParagraph =
              "You know what's awesome? You! Especially when $additionalDetails. Never stop being your amazing self!";
          break;
        case 'Poetic':
          detailsParagraph =
              "In the garden of my heart, you planted seeds of joy when $additionalDetails. They have blossomed into the most beautiful flowers, nourished by your love.";
          break;
        case 'Passionate':
          detailsParagraph =
              "I crave the way $additionalDetails. You awaken desires in me that only you can fulfill, and I want to spend a lifetime exploring them with you.";
          break;
        case 'Sweet':
          detailsParagraph =
              "You're so special to me, especially when $additionalDetails. These little things make my heart so happy!";
          break;
        case 'Nostalgic':
          detailsParagraph =
              "Through the years, I've watched you $additionalDetails. These moments have become the foundation of my deepest affections for you.";
          break;
        case 'Heartfelt':
          detailsParagraph =
              "From the bottom of my heart, I cherish how $additionalDetails. These qualities reflect the beautiful soul that I fall more in love with each day.";
          break;
        default:
          detailsParagraph =
              "I appreciate so many things about you, including $additionalDetails. These are just some of the reasons why you're so special to me.";
      }
      paragraphs.add(detailsParagraph);
    }

    return paragraphs;
  }

  List<String> _getClosingsByTone(
    String tone,
    String partnerName,
    String yourName,
  ) {
    switch (tone) {
      case 'Romantic':
        return [
          "Forever and always yours,\n$yourName",
          "With all my love and devotion,\n$yourName",
          "Loving you endlessly,\n$yourName",
        ];
      case 'Playful':
        return [
          "Yours until the pizza runs out (just kidding, forever!),\n$yourName",
          "XOXO and all that mushy stuff,\n$yourName",
          "Crazy about you,\n$yourName",
        ];
      case 'Poetic':
        return [
          "With love that flows like an endless river,\n$yourName",
          "In the poetry of life, you are my favorite verse,\n$yourName",
          "Yours across time and space,\n$yourName",
        ];
      case 'Passionate':
        return [
          "Burning for you always,\n$yourName",
          "With desire that never fades,\n$yourName",
          "Passionately yours,\n$yourName",
        ];
      case 'Sweet':
        return [
          "Sweetly yours,\n$yourName",
          "With sugar and spice and everything nice,\n$yourName",
          "Hugs and kisses,\n$yourName",
        ];
      case 'Nostalgic':
        return [
          "Through all our yesterdays and all our tomorrows,\n$yourName",
          "As always, and as it has been since the beginning,\n$yourName",
          "From then, until now, until forever,\n$yourName",
        ];
      case 'Heartfelt':
        return [
          "With my whole heart,\n$yourName",
          "From the depths of my soul,\n$yourName",
          "With every beat of my heart,\n$yourName",
        ];
      default:
        return [
          "With love,\n$yourName",
          "Yours truly,\n$yourName",
          "All my love,\n$yourName",
        ];
    }
  }

  @override
  void dispose() {
    // Remove listeners before disposing controllers
    _yourNameController.removeListener(_updateUI);
    _partnerNameController.removeListener(_updateUI);

    // Dispose controllers
    _yourNameController.dispose();
    _partnerNameController.dispose();
    _specialMemoryController.dispose();
    _additionalDetailsController.dispose();
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Cosmic Background
          CosmicBackground(
            color1: Colors.purple.shade900,
            color2: Colors.pink.shade800,
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
                            "Love Letter Generator",
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
                        "Express your feelings with beautiful words",
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
                          _showResult ? _buildResultView() : _buildInputForm(),
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

  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your Name
          _buildTextField(
            controller: _yourNameController,
            label: "Your Name",
            icon: Icons.person,
            hint: "Enter your name",
          ),
          const SizedBox(height: 16),

          // Partner's Name
          _buildTextField(
            controller: _partnerNameController,
            label: "Partner's Name",
            icon: Icons.favorite,
            hint: "Enter your partner's name",
          ),
          const SizedBox(height: 16),

          // Special Date
          _buildDatePicker(),
          const SizedBox(height: 16),

          // Special Memory
          _buildTextField(
            controller: _specialMemoryController,
            label: "Special Memory",
            icon: Icons.photo_album,
            hint: "e.g., Our first date at the beach",
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // Tone Selection
          _buildToneSelector(),
          const SizedBox(height: 16),

          // Additional Details
          _buildTextField(
            controller: _additionalDetailsController,
            label: "Additional Details (Optional)",
            icon: Icons.more_horiz,
            hint: "e.g., favorite qualities, shared experiences, future hopes",
            maxLines: 3,
          ),

          // Letter Preview
          LetterPreview(
            yourName: _yourNameController.text,
            partnerName: _partnerNameController.text,
            tone: _selectedTone,
            isVisible:
                _yourNameController.text.isNotEmpty &&
                _partnerNameController.text.isNotEmpty,
          ),
          const SizedBox(height: 20),

          // Generate Button
          Center(child: _buildGenerateButton()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(icon, color: Colors.pink.shade300),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.pink.shade300, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    final formattedDate =
        _specialDate != null
            ? DateFormat('MMMM d, y').format(_specialDate!)
            : 'Select a date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Special Date",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _specialDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.pink.shade400,
                      onPrimary: Colors.white,
                      surface: Colors.pink.shade50,
                      onSurface: Colors.black87,
                    ),
                    dialogBackgroundColor: Colors.white,
                  ),
                  child: child!,
                );
              },
            );

            if (date != null) {
              setState(() {
                _specialDate = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.pink.shade300),
                const SizedBox(width: 12),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        _specialDate != null
                            ? Colors.black87
                            : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Preferred Tone",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _toneOptions.length,
            itemBuilder: (context, index) {
              final tone = _toneOptions[index];
              final isSelected = tone == _selectedTone;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTone = tone;
                    // Force preview update when tone changes
                    _updateUI();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.pink.shade400 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected
                              ? Colors.pink.shade400
                              : Colors.grey.shade300,
                    ),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: Colors.pink.shade200.withOpacity(0.5),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : null,
                  ),
                  child: Center(
                    child: Text(
                      tone,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_animationController.value * 0.05),
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.shade400, Colors.purple.shade500],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade300.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed:
                  _isGenerating ? null : () async => await _generateLetter(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child:
                  _isGenerating
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        "Generate Love Letter",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultView() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        _showResult = false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Your Love Letter",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isSaved ? Icons.favorite : Icons.favorite_border,
                      color: _isSaved ? Colors.red : Colors.grey,
                    ),
                    onPressed: _saveLetter,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Love Letter Card
              _buildLoveLetterCard(),
              const SizedBox(height: 30),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.refresh,
                    label: "Regenerate",
                    onPressed: _generateLetter,
                    color: Colors.blue,
                  ),
                  _buildActionButton(
                    icon: Icons.copy,
                    label: "Copy",
                    onPressed: () {
                      // Copy to clipboard functionality would go here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Letter copied to clipboard!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    color: Colors.green,
                  ),
                  _buildActionButton(
                    icon: Icons.share,
                    label: "Share",
                    onPressed: () {
                      // Share functionality would go here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sharing functionality coming soon!'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoveLetterCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Custom letter background
            Positioned.fill(
              child: CustomPaint(
                painter: LetterBackground(
                  primaryColor: Colors.pink,
                  secondaryColor: Colors.purple,
                ),
              ),
            ),

            // Decorative elements
            Positioned(
              top: 10,
              right: 10,
              child: Icon(
                Icons.favorite,
                color: Colors.pink.withOpacity(0.2),
                size: 40,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Icon(
                Icons.favorite,
                color: Colors.pink.withOpacity(0.2),
                size: 40,
              ),
            ),

            // Letter content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _generatedLetter,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
