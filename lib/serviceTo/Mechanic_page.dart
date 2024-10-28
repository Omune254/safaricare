import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safaricare/models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import the correct package

class MechanicOperatorsPage extends StatefulWidget {
  const MechanicOperatorsPage({Key? key}) : super(key: key);

  @override
  _MechanicOperatorsPageState createState() => _MechanicOperatorsPageState();
}

class _MechanicOperatorsPageState extends State<MechanicOperatorsPage> {
  List<String> locations = [
    "Akirang’ondu",
    "Amwathi",
    "Ankamia",
    "Antuambui",
    "Archer's Post",
    "Athwana",
    "Bisan Biliqo",
    "Chabuene",
    "Chari",
    "Chiakariga",
    "Chogoria",
    "Chuka Town",
    "Garbatulla",
    "Gakoromone",
    "Ganga",
    "Gatunga",
    "Giaki",
    "Gitugini",
    "Githongo",
    "Igambang'ombe",
    "Igembe",
    "Igoji",
    "Isiolo Town",
    "Itugururu",
    "Kaaga",
    "Kaanwa",
    "Kaelo",
    "Kafoka",
    "Kajuki",
    "Kalithiria",
    "Kamachege",
    "Kamanyaki",
    "Kamweline",
    "Kangeta",
    "Kanuni",
    "Karama",
    "Kariene",
    "Karocho",
    "Kathangachini",
    "Kathera",
    "Kibutha",
    "Kibirichia",
    "Kiengu",
    "Kiirua",
    "Kiutine",
    "Kianjai",
    "Kinoru",
    "Kinna",
    "Merti",
    "Meru Town",
    "Modogashe",
    "Mukothima",
    "Mitunguu",
    "Mutuati",
    "Nanyuki",
    "Nkubu",
    "Ruiri",
    "Sericho",
    "Timau",
    "Urru",
    "Uringu"
  ]; // Predefined list of locations

  String? selectedLocation;

  Future<List<MechanicOperatorModel>> fetchMechanicOperators(
      String? location) async {
    if (location == null || location.isEmpty) return [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('mechanic_operators')
        .where('location', isEqualTo: location)
        .get();

    return querySnapshot.docs.map((doc) {
      return MechanicOperatorModel.fromFirestore(doc);
    }).toList();
  }

  void _launchCaller(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $phoneNumber')),
        );
      }
    } catch (e) {
      print(e); // Handle errors appropriately in production apps
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mechanic Operators',
          style: TextStyle(
            color: Colors.green[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
      ),
      body: Container(
        color: Colors.lightBlue[200],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownSearch<String>(
                items: locations,
                selectedItem: selectedLocation,
                popupProps: PopupProps.menu(
                  showSearchBox:
                      true, // Ensure this parameter is used correctly
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Search Location',
                    ),
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Select Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<MechanicOperatorModel>>(
                future: fetchMechanicOperators(selectedLocation),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No mechanic operators found',
                        style: TextStyle(color: Colors.green[900]),
                      ),
                    );
                  }
                  List<MechanicOperatorModel> mechanicOperators =
                      snapshot.data!;
                  return ListView.builder(
                    itemCount: mechanicOperators.length,
                    itemBuilder: (context, index) {
                      MechanicOperatorModel mechanicOperator =
                          mechanicOperators[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            mechanicOperator.fullName,
                            style: TextStyle(
                              color: Colors.green[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            mechanicOperator.phoneNumber,
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 16,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.call, color: Colors.green[900]),
                            onPressed: () {
                              _launchCaller(mechanicOperator.phoneNumber);
                            },
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
      ),
    );
  }
}
