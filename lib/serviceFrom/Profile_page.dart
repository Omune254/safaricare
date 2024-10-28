import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safaricare/serviceFrom/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late Future<Map<String, dynamic>?> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  void _navigateToEditProfile(
      BuildContext context, Map<String, dynamic> userData) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => EditProfilePage(userData: userData),
      ),
    )
        .then((_) {
      setState(() {
        _userData = _fetchUserData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user data'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data found'));
          } else {
            var userData = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 30),
                // User avatar or initials placeholder
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green[900],
                    child: Text(
                      _getInitials(userData['fullName'] ?? 'User'),
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    currentUser.email!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // My Details Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // User Details in Card style
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.green[900]),
                    title: const Text('Full Name'),
                    subtitle: Text(userData['fullName'] ?? 'N/A'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Icon(Icons.phone, color: Colors.green[900]),
                    title: const Text('Phone Number'),
                    subtitle: Text(userData['phoneNumber'] ?? 'N/A'),
                  ),
                ),
                // Conditional rendering based on role
                if (userData['role'] == 'Car Operator') ...[
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading:
                          Icon(Icons.directions_car, color: Colors.green[900]),
                      title: const Text('Vehicle Number'),
                      subtitle: Text(userData['vehicleNumber'] ?? 'N/A'),
                    ),
                  ),
                ] else if (userData['role'] == 'Lorry Operator') ...[
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Icon(Icons.map, color: Colors.green[900]),
                      title: const Text('Area of Operation'),
                      subtitle: Text(userData['areaOfOperation'] ?? 'N/A'),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _navigateToEditProfile(context, userData),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      backgroundColor: Colors.green[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  String _getInitials(String fullName) {
    List<String> names = fullName.split(" ");
    String initials =
        names.length > 1 ? "${names[0][0]}${names[1][0]}" : names[0][0];
    return initials.toUpperCase();
  }
}
