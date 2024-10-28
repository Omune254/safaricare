import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Users to Chat'),
        backgroundColor: Colors.green[900],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs.where((userDoc) =>
              userDoc['uid'] != FirebaseAuth.instance.currentUser!.uid);

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users.elementAt(index);
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(user['fullName']),
                subtitle: Text(user['phoneNumber']),
                onTap: () {
                  // Navigate to chat screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        recipientId: user['uid'],
                        recipientName: user['fullName'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
