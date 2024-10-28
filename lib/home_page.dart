import 'package:flutter/material.dart';
import 'package:safaricare/AUTH/log_In.dart';
import 'package:safaricare/serviceTo/service_to.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          'Mapema',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            const Color(0xFF0072FF), // Uniform color from login screen
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'hero-image',
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/transport.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Welcome to Mapema',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0072FF), // Uniform color
                shadows: [
                  Shadow(
                    offset: Offset(3.0, 3.0),
                    blurRadius: 4.0,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Premier transportation services for safe and reliable travel.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildServiceButton(
              context,
              'Offer a Service',
              const MyLoginScreen(),
              const Icon(Icons.directions_car, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildServiceButton(
              context,
              'Receive a Service',
              null, // We'll handle navigation logic manually
              const Icon(Icons.local_taxi, color: Colors.white),
              isReceiveService: true,
            ),
            const SizedBox(height: 40),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 40,
              endIndent: 40,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Connecting you to safe, efficient, and affordable transportation services.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Reusable button builder with modern design
  Widget _buildServiceButton(
    BuildContext context,
    String label,
    Widget? page,
    Icon icon, {
    bool isReceiveService = false,
  }) {
    return ElevatedButton.icon(
      onPressed: () async {
        // Show a loading indicator while waiting
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissing the dialog
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        // Simulate a delay for loading
        await Future.delayed(const Duration(seconds: 2));

        // Dismiss the loading indicator
        Navigator.pop(context);

        // Logic for "Receive a Service" button
        if (isReceiveService) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            // User is not logged in, navigate to LoginScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyLoginScreen()),
            );
          } else {
            // User is logged in, navigate to ServiceTo page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ServiceTo()),
            );
          }
        } else {
          // Navigate to the target page for other buttons
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page!));
        }
      },
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 10,
        primary: const Color(
            0xFF0072FF), // Updated primary button color to match login
        shadowColor: Colors.black45, // Subtle shadow for modern feel
      ),
    );
  }
}
