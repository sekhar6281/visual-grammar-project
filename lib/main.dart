import 'package:flutter/material.dart';

void main() {
  runApp(const VisualGrammarApp());
}

class VisualGrammarApp extends StatelessWidget {
  const VisualGrammarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainDashboard(),
    );
  }
}

// ---------------------------------------------------------
// 1. MAIN DASHBOARD
// ---------------------------------------------------------
class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visual English Guide", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Master Grammar Visually", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _topicCard(context, "Tenses", Icons.schedule, Colors.blue, "tenses"),
                _topicCard(context, "Prepositions", Icons.place, Colors.orange, "prepositions"),
                _topicCard(context, "Voice", Icons.compare_arrows, Colors.green, "voice"),
                _topicCard(context, "Parts of Speech", Icons.extension, Colors.purple, "parts"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _topicCard(BuildContext context, String title, IconData icon, Color color, String key) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LessonPage(topic: title, topicKey: key, color: color))),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. LESSON PAGE (Definitions + Animations)
// ---------------------------------------------------------
class LessonPage extends StatelessWidget {
  final String topic;
  final String topicKey;
  final Color color;

  const LessonPage({super.key, required this.topic, required this.topicKey, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$topic Lesson"), backgroundColor: color, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDefinitionSection(),
            const Divider(height: 40),
            const Text("Interactive Visualizer:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 300, 
              child: _buildAnimationSection(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(topic: topic, topicKey: topicKey, color: color))),
              child: const Text("Start Quiz (5 Questions) →", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefinitionSection() {
    if (topicKey == "tenses") {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("What are Tenses?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Text("Tenses show the time of an action. They tell us if something happened in the past, present, or future."),
        _typeTile("Past", "Happened before now.", "I walked.", Colors.red),
        _typeTile("Present", "Happening now.", "I walk.", Colors.green),
        _typeTile("Future", "Will happen later.", "I will walk.", Colors.orange),
      ]);
    } else if (topicKey == "prepositions") {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("What are Prepositions?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
        const Text("Prepositions link nouns to other words to show direction, time, or place."),
        _typeTile("Place", "Shows where.", "On, In, Under", Colors.orange),
      ]);
    } else if (topicKey == "voice") {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Active vs Passive", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
        const Text("Active: The subject DOES the action. Passive: The subject RECEIVES the action."),
        _typeTile("Active", "Subject -> Verb -> Object", "The Chef baked a cake.", Colors.blue),
        _typeTile("Passive", "Object -> Was Verbed -> By Subject", "The cake was baked by the chef.", Colors.green),
      ]);
    }
    return const Text("Every word has a role! Nouns, Verbs, and Adjectives build our sentences.");
  }

  Widget _typeTile(String t, String d, String e, Color c) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Text.rich(TextSpan(children: [
      TextSpan(text: "$t: ", style: TextStyle(fontWeight: FontWeight.bold, color: c)),
      TextSpan(text: "$d "),
      TextSpan(text: "($e)", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
    ])),
  );

  Widget _buildAnimationSection() {
    if (topicKey == "tenses") return const TenseAnimator();
    if (topicKey == "prepositions") return const PrepositionAnimator();
    if (topicKey == "voice") return const VoiceAnimator();
    return const Center(child: Text("Parts of Speech Visualizer Active"));
  }
}

// ---------------------------------------------------------
// 3. ANIMATION WIDGETS (RE-ADDED)
// ---------------------------------------------------------

class TenseAnimator extends StatefulWidget { const TenseAnimator({super.key}); @override State<TenseAnimator> createState() => _TenseAnimatorState(); }
class _TenseAnimatorState extends State<TenseAnimator> {
  int _idx = 1;
  final List<Map<String, dynamic>> _data = [
    {"l": "Past", "c": Colors.red, "a": Alignment.centerLeft, "s": "I ran yesterday."},
    {"l": "Present", "c": Colors.green, "a": Alignment.center, "s": "I am running now."},
    {"l": "Future", "c": Colors.orange, "a": Alignment.centerRight, "s": "I will run tomorrow."},
  ];
  @override Widget build(BuildContext context) => Column(children: [
    Container(height: 100, child: Stack(alignment: Alignment.center, children: [
      Container(height: 2, color: Colors.grey),
      AnimatedAlign(alignment: _data[_idx]['a'], duration: const Duration(milliseconds: 500), child: CircleAvatar(backgroundColor: _data[_idx]['c'], child: const Icon(Icons.person, color: Colors.white))),
    ])),
    Text(_data[_idx]['s'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    const Spacer(),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(3, (i) => ElevatedButton(onPressed: () => setState(() => _idx = i), child: Text(_data[i]['l']))))
  ]);
}

class PrepositionAnimator extends StatefulWidget { const PrepositionAnimator({super.key}); @override State<PrepositionAnimator> createState() => _PrepositionAnimatorState(); }
class _PrepositionAnimatorState extends State<PrepositionAnimator> {
  Alignment _align = Alignment.topCenter;
  String _t = "ON";
  @override Widget build(BuildContext context) => Column(children: [
    Text("The ball is $_t the box", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    Expanded(child: Center(child: Container(width: 150, height: 150, decoration: BoxDecoration(border: Border.all()), child: Stack(children: [
      Center(child: Container(width: 60, height: 60, color: Colors.brown)),
      AnimatedAlign(duration: const Duration(milliseconds: 300), alignment: _align, child: const CircleAvatar(radius: 12, backgroundColor: Colors.red)),
    ])))),
    Wrap(spacing: 10, children: [
      ElevatedButton(onPressed: () => setState(() { _align = const Alignment(0, -0.7); _t = "ON"; }), child: const Text("ON")),
      ElevatedButton(onPressed: () => setState(() { _align = const Alignment(0, 0); _t = "IN"; }), child: const Text("IN")),
      ElevatedButton(onPressed: () => setState(() { _align = const Alignment(0, 0.7); _t = "UNDER"; }), child: const Text("UNDER")),
    ])
  ]);
}

class VoiceAnimator extends StatefulWidget { const VoiceAnimator({super.key}); @override State<VoiceAnimator> createState() => _VoiceAnimatorState(); }
class _VoiceAnimatorState extends State<VoiceAnimator> {
  bool isPassive = false;
  @override Widget build(BuildContext context) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _box(isPassive ? "The Cake" : "The Chef", isPassive ? Colors.orange : Colors.blue),
      const Icon(Icons.arrow_forward),
      _box(isPassive ? "was baked by" : "baked", Colors.grey.shade300),
      const Icon(Icons.arrow_forward),
      _box(isPassive ? "The Chef" : "The Cake", isPassive ? Colors.blue : Colors.orange),
    ]),
    const SizedBox(height: 20),
    SwitchListTile(title: const Text("Switch to Passive Voice"), value: isPassive, onChanged: (v) => setState(() => isPassive = v)),
  ]);
  Widget _box(String t, Color c) => AnimatedContainer(duration: const Duration(milliseconds: 500), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: Text(t));
}

// ---------------------------------------------------------
// 4. QUIZ PAGE (5 QUESTIONS PER TOPIC)
// ---------------------------------------------------------
class QuizPage extends StatefulWidget {
  final String topic, topicKey; final Color color;
  const QuizPage({super.key, required this.topic, required this.topicKey, required this.color});
  @override State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _idx = 0; int _score = 0; bool _answered = false; int? _sel;
  final Map<String, List<Map<String, dynamic>>> _db = {
    "tenses": [
      {"q": "I ____ a movie last night.", "o": ["watch", "watched", "watching"], "a": 1},
      {"q": "She ____ to school every day.", "o": ["goes", "go", "going"], "a": 0},
      {"q": "We ____ dinner when you called.", "o": ["are having", "were having", "had"], "a": 1},
      {"q": "They ____ for two hours now.", "o": ["have been playing", "played", "play"], "a": 0},
      {"q": "I ____ my work by tomorrow.", "o": ["finish", "will have finished", "finished"], "a": 1},
    ],
    "prepositions": [
      {"q": "The cat is ____ the table.", "o": ["at", "on", "between"], "a": 1},
      {"q": "I am going ____ London.", "o": ["to", "at", "into"], "a": 0},
      {"q": "The book is ____ the two lamps.", "o": ["among", "between", "beside"], "a": 1},
      {"q": "He jumped ____ the water.", "o": ["into", "onto", "on"], "a": 0},
      {"q": "The class starts ____ 9 AM.", "o": ["on", "in", "at"], "a": 2},
    ],
    "voice": [
      {"q": "'The ball was hit' is...", "o": ["Active", "Passive"], "a": 1},
      {"q": "Active Voice: The focus is on the...", "o": ["Subject", "Object"], "a": 0},
      {"q": "Passive: 'He wrote it' becomes...", "o": ["It is written", "It was written by him"], "a": 1},
      {"q": "'I ate the apple' is...", "o": ["Active", "Passive"], "a": 0},
      {"q": "'A song was sung' is...", "o": ["Active", "Passive"], "a": 1},
    ],
    "parts": [
      {"q": "Which is a Noun?", "o": ["Run", "Dog", "Blue"], "a": 1},
      {"q": "Which is a Verb?", "o": ["Jump", "Quickly", "Apple"], "a": 0},
      {"q": "Which is an Adjective?", "o": ["Slowly", "Small", "He"], "a": 1},
      {"q": "Which is an Adverb?", "o": ["Fastly", "Fast", "Quickly"], "a": 2},
      {"q": "Which is a Pronoun?", "o": ["She", "Her", "Both"], "a": 2},
    ],
  };

  @override
  Widget build(BuildContext context) {
    var questions = _db[widget.topicKey]!;
    var q = questions[_idx];
    return Scaffold(
      appBar: AppBar(title: Text("${widget.topic} Quiz"), backgroundColor: widget.color, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          LinearProgressIndicator(value: (_idx + 1) / 5, color: widget.color),
          const SizedBox(height: 20),
          Text(q['q'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ...List.generate(q['o'].length, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _answered ? (i == q['a'] ? Colors.green : (i == _sel ? Colors.red : Colors.white)) : Colors.white,
                foregroundColor: _answered && (i == q['a'] || i == _sel) ? Colors.white : Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () { if (!_answered) setState(() { _answered = true; _sel = i; if (i == q['a']) _score++; }); },
              child: Text(q['o'][i]),
            ),
          )),
          if (_answered) ...[
            Text(_sel == q['a'] ? "Correct! ✨" : "Wrong! Correct: ${q['o'][q['a']]}", style: TextStyle(color: _sel == q['a'] ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton(onPressed: () {
              if (_idx < 4) setState(() { _idx++; _answered = false; _sel = null; });
              else showDialog(context: context, builder: (c) => AlertDialog(title: const Text("Done!"), content: Text("Score: $_score / 5"), actions: [TextButton(onPressed: () { Navigator.pop(c); Navigator.pop(context); Navigator.pop(context); }, child: const Text("Home"))]));
            }, child: const Text("Next"))
          ]
        ]),
      ),
    );
  }
}