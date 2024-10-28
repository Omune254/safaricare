import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safaricare/AUTH/chat_screen.dart';
import 'package:safaricare/models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CarOperatorsPage extends StatefulWidget {
  const CarOperatorsPage({Key? key}) : super(key: key);

  @override
  State<CarOperatorsPage> createState() => _CarOperatorsPageState();
}

class _CarOperatorsPageState extends State<CarOperatorsPage> {
  String? selectedLocation;
  final List<String> _areasOfOperation = [
    "Akirang’ondu",
    "Amwathi",
    "Ankamia",
    "Antuambui",
    "Archer's Post",
    "Athwana",
    "Uringu"
  ];

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Operators'),
        backgroundColor: Colors.green[900],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownSearch<String>(
              items: _areasOfOperation,
              dropdownBuilder: (context, selectedItem) {
                return Text(selectedItem ?? 'Select Area of Operation');
              },
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
              onChanged: (newValue) {
                setState(() {
                  selectedLocation = newValue;
                });
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Area of Operation',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedLocation == null
                  ? FirebaseFirestore.instance
                      .collection('car_operators')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('car_operators')
                      .where('areaOfOperation', isEqualTo: selectedLocation)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No operators found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var carOperator = CarOperatorModel.fromMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id, // Pass the Firestore document ID
                    );

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: carOperator.driverImageUrl != null
                              ? NetworkImage(carOperator.driverImageUrl!)
                              : null,
                          child: carOperator.driverImageUrl == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(carOperator.fullName),
                        subtitle: Text(carOperator.phoneNumber),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.phone),
                              onPressed: () =>
                                  _launchPhoneDialer(carOperator.phoneNumber),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chat),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      recipientId: doc.id, // Pass Firestore ID
                                      recipientName: carOperator.fullName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
