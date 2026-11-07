import 'package:flutter/material.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // Named routes as required by the exam
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
        '/projects': (context) => const ProjectsPage(),
      },
    );
  }
}

// ------------------------- HOME PAGE -------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery used to make the layout responsive
    final width = MediaQuery.of(context).size.width;
    final avatarRadius = width < 400 ? 55.0 : 70.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile image using CircleAvatar + NetworkImage
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.indigo.shade100,
                // Replace with your own photo URL
                backgroundImage: const NetworkImage(
                  'https://i.pravatar.cc/300',
                ),
              ),
              const SizedBox(height: 20),

              // Name with proper styling
              const Text(
                'Your Name',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 6),

              // Designation
              const Text(
                'B.Tech Student | Flutter Developer',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Short intro
              const Text(
                'Welcome to my personal portfolio! Explore my skills, '
                'expertise, and the projects I have built.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 40),

              // Two navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/about');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('About Me'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/projects');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('Projects'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------- ABOUT PAGE -------------------------
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Me')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Me',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'I am a 3rd year B.Tech student passionate about mobile app '
              'development, especially using Flutter. I enjoy building '
              'clean, responsive user interfaces and learning new '
              'technologies.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Skills & Areas of Expertise:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Flutter & Dart\n'
              '• UI/UX Design\n'
              '• Firebase & REST APIs\n'
              '• Java / Python\n'
              '• Git & Version Control',
              style: TextStyle(fontSize: 15, height: 1.6),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------- PROJECTS PAGE -------------------------
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  final List<Map<String, String>> projects = const [
    {
      'title': 'Weather App',
      'description':
          'A Flutter app that fetches live weather data using a REST API '
          'and displays temperature, humidity, and forecasts with a clean UI.'
    },
    {
      'title': 'E-commerce UI',
      'description':
          'A responsive shopping app UI featuring product listings, '
          'cart management, and smooth navigation between screens.'
    },
    {
      'title': 'Music Player',
      'description':
          'A simple music player app with play/pause controls, a song '
          'list, and animated transitions between tracks.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Projects')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            project['description']!,
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}