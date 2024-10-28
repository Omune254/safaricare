import 'package:flutter/material.dart';
import 'package:safaricare/serviceFrom/Lorry_operator.dart';
import 'package:safaricare/serviceFrom/Profile_page.dart';
import 'package:safaricare/serviceFrom/car_operator.dart';
import 'package:safaricare/serviceFrom/drawer.dart';
import 'package:safaricare/serviceFrom/mechanic_operator.dart';
import 'package:safaricare/serviceFrom/motorbike_operator.dart';
import 'package:safaricare/serviceFrom/pickUp_operator.dart';
import 'package:safaricare/serviceFrom/psv_operator.dart';
import 'package:safaricare/serviceFrom/taxi_operator.dart';
import 'package:safaricare/serviceFrom/tractor_operator.dart';

class ServiceFrom extends StatelessWidget {
  const ServiceFrom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void goToProfilePage() {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapema',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        backgroundColor: const Color(0xFF0C3610), // Deep green color
        elevation: 0,
      ),
      drawer: myDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: () {},
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue[100]!, Colors.lightBlue[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose the Service You Would Like to Offer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0C3610),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    ServiceCard(
                      title: 'Motorbike',
                      icon: Icons.motorcycle, // Motorbike icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MotorbikeOperator()),
                        );
                      },
                    ),
                    ServiceCard(
                      title: 'Taxi',
                      icon: Icons.local_taxi, // Taxi icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaxiOperator()),
                        );
                      },
                    ),
                    ServiceCard(
                      title: 'PSV Operations',
                      icon: Icons.directions_bus, // Bus icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PsvOperator()),
                        );
                      },
                    ),
                    ServiceCard(
                      title: 'Pickup',
                      icon: Icons.local_shipping, // Pickup truck icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PickupOperator()),
                        );
                      },
                    ),
                    ServiceCard(
                      title: 'Lorry',
                      icon: Icons.local_shipping_rounded, // Lorry icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LorryOperator()),
                        );
                      },
                    ),
                    ServiceCard(
                      title: 'Tractor',
                      icon: Icons.agriculture, // Tractor icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TractorOperator()),
                        );
                      },
                    ),
                    ServiceCard(
                      title: 'Car Hire',
                      icon: Icons.directions_car, // Car hire icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CarOperator()),
                        );
                      },
                    ),
                    ServiceCard(
                      title: 'Mechanics',
                      icon: Icons.build, // Mechanic tools icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MechanicOperator()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      shadowColor: Colors.black38,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: const Color(0xFF0C3610), // Green color for icons
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C3610), // Green color for text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
