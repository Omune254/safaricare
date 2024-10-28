import 'package:flutter/material.dart';
import 'package:safaricare/serviceTo/Mechanic_page.dart';
import 'package:safaricare/serviceTo/Motorbike_page.dart';
import 'package:safaricare/serviceTo/MyDrawer.dart';
import 'package:safaricare/serviceTo/PSV_Operations_Page.dart';
import 'package:safaricare/serviceTo/Pickup_Page.dart';
import 'package:safaricare/serviceTo/Taxi_page.dart';
import 'package:safaricare/serviceTo/Tractor_Page.dart';
import 'package:safaricare/serviceTo/car_operators_page.dart';
import 'package:safaricare/serviceTo/lorry_page.dart';

class ServiceTo extends StatelessWidget {
  const ServiceTo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapema',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        backgroundColor: const Color(0xFF0C3610), // Deep green AppBar
        elevation: 0,
        centerTitle: true,
      ),
      // Adding Drawer here
      drawer: MyDrawer(
        onProfileTap: () {
          // Add logic to navigate to the profile page
          Navigator.pushNamed(context, '/profile');
        },
        onSignOut: () {
          // Add sign-out logic here
          Navigator.pushReplacementNamed(context, '/login');
        },
        userName: 'John Doe', // Pass actual user name
        userEmail: 'john.doe@example.com', // Pass actual user email
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue[100]!, Colors.lightBlue[200]!],
          ),
        ),
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Icon(
                  Icons.directions_car,
                  size: 100,
                  color: Color(0xFF0C3610), // Green Icon
                ),
                SizedBox(height: 20),
                Text(
                  'Choose a Service You Would Like to be Offered',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C3610),
                  ),
                ),
                SizedBox(height: 30),
                ServiceGrid(), // Grid of Services
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ServiceCard(
          title: 'Motorbike',
          icon: Icons.motorcycle,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MotorbikeOperatorsPage(),
              ),
            );
          },
        ),
        ServiceCard(
          title: 'Taxi',
          icon: Icons.local_taxi,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TaxiOperatorsPage(),
              ),
            );
          },
        ),
        ServiceCard(
          title: 'PSV Operations',
          icon: Icons.directions_bus,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PsvOperatorsPage(),
              ),
            );
          },
        ),
        ServiceCard(
          title: 'Pickup',
          icon: Icons.local_shipping,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PickupOperatorsPage(),
              ),
            );
          },
        ),
        ServiceCard(
          title: 'Lorry',
          icon: Icons.local_shipping_rounded,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LorryOperatorsPage(),
              ),
            );
          },
        ),
        ServiceCard(
          title: 'Tractor',
          icon: Icons.agriculture,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TractorOperatorsPage(),
              ),
            );
          },
        ),
        ServiceCard(
          title: 'Car Hire',
          icon: Icons.directions_car,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CarOperatorsPage(),
              ),
            );
          },
        ),
        ServiceCard(
          title: 'Mechanic',
          icon: Icons.build,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MechanicOperatorsPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      shadowColor: Colors.black38,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: const Color(0xFF0C3610),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C3610),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
