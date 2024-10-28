import 'package:flutter/material.dart';
import 'package:safaricare/AUTH/log_In.dart';
import 'package:safaricare/AUTH/login_screen.dart';
import 'home_page.dart'; // Import your home page file
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async'; // To use the Timer for splash screen delay

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapema',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue[50], // Light blue background
        hintColor: Colors.green, // Green accent color
      ),
      // Define named routes
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => SplashScreen(), // Splash screen as the initial route
        '/home': (context) => HomePage(), // Home page route
        '/login1': (context) => MyLoginScreen(),
        '/login2': (context) => LoginScreen(), // Login screen route

        // Add more routes as needed
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Step 1: Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 3), // Duration of the animation
      vsync: this,
    );

    // Step 2: Define opacity animation (fade in)
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Step 3: Define scale animation (grow text)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Step 4: Start the animation
    _controller.forward();

    // Step 5: Navigate to HomePage after animation completes
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacementNamed('/home'); // Use named route for navigation
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller to free up resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Step 6: Build the animated word (fade and scale)
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation, // Apply scaling to the text
          child: FadeTransition(
            opacity: _opacityAnimation, // Apply fading to the text
            child: const Text(
              'Welcome', // Your animated word
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Customize the color as needed
              ),
            ),
          ),
        ),
      ),
    );
  }
}
