import 'package:flutter/material.dart';
import 'package:safaricare/serviceTo/MyListTile.dart'; // Make sure this exists or is imported correctly.

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  final String? userName;
  final String? userEmail;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
    this.userName,
    this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1C1C1C), // Dark grey background
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0C3610),
                  Color(0xFF2E7D32)
                ], // Green gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF0C3610),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userName ?? 'Guest User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userEmail ?? 'No email provided',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white54),

          // List of tiles in the drawer
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),
          MyListTile(
            icon: Icons.person,
            text: 'P R O F I L E',
            onTap: onProfileTap,
          ),
          MyListTile(
            icon: Icons.settings,
            text: 'S E T T I N G S',
            onTap: () {
              // Add Settings Page Navigation or Functionality
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          const Divider(color: Colors.white54),

          // Sign out list tile
          MyListTile(
            icon: Icons.logout,
            text: 'L O G O U T',
            onTap: onSignOut,
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
