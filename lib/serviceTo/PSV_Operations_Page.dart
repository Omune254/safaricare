import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:safaricare/models/models.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import DropdownSearch package

class PsvOperatorsPage extends StatefulWidget {
  const PsvOperatorsPage({Key? key}) : super(key: key);

  @override
  _PsvOperatorsPageState createState() => _PsvOperatorsPageState();
}

class _PsvOperatorsPageState extends State<PsvOperatorsPage> {
  String? selectedLocation; // Store selected location
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
    "Kamweline Ndune",
    "Kangeta",
    "Kangiriene",
    "Kanuni",
    "Karama",
    "Kariene",
    "Karocho",
    "Kathangachini",
    "Kathatene",
    "Kathera",
    "Kibugua",
    "Kibutha",
    "Kibirichia",
    "Kiengu",
    "Kiereni",
    "Kiirua",
    "Kiutine",
    "Kianjai",
    "Kiguchwa",
    "Kinoru",
    "Kinna",
    "Kiorimba",
    "Kipsing",
    "Kithangani",
    "Kithare",
    "Kithoka",
    "Makutano",
    "Maili Tatu",
    "Malka Daka",
    "Mariani",
    "Marima",
    "Marimanti",
    "Marimba",
    "Matanya",
    "Meru Town",
    "Merti",
    "Miriga Mieru",
    "Mitunguu",
    "Miathene",
    "Mikinduri",
    "Modogashe",
    "Mukothima",
    "Muringene",
    "Mutuati",
    "Mwiteria",
    "Nanyuki",
    "Nchiru",
    "Ndoleli",
    "Ndagani",
    "Ndumuru",
    "Njoune",
    "Njiruine",
    "Nkubu",
    "Nkondi",
    "Ngare Mara",
    "Ngusishi",
    "Nturukuma",
    "Oldonyiro",
    "Ruiri",
    "Rwarera",
    "Sericho",
    "Tunyai",
    "Thiiri",
    "Timau",
    "Urru",
    "Uringu",
    "Uuru"
  ];

  Future<List<PsvOperatorModel>> fetchPsvOperators(String location) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('psv_operators')
        .where('areaOfOperation', isEqualTo: location)
        .get();

    return querySnapshot.docs.map((doc) {
      return PsvOperatorModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Function to launch the phone dialer
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
        title: Text(
          'PSV Operators',
          style: TextStyle(
            color: Colors.green[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Dropdown to select location with search functionality
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownSearch<String>(
              items: locations,
              selectedItem: selectedLocation,
              popupProps: PopupProps.menu(
                showSearchBox: true,
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
              onChanged: (String? newLocation) {
                setState(() {
                  selectedLocation = newLocation;
                });
              },
            ),
          ),
          // Fetch and show PSV operators based on the selected location
          Expanded(
            child: selectedLocation == null
                ? Center(
                    child: Text(
                      'Please select a location to view PSV operators.',
                      style: TextStyle(color: Colors.green[900], fontSize: 18),
                    ),
                  )
                : FutureBuilder<List<PsvOperatorModel>>(
                    future: fetchPsvOperators(selectedLocation!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 16),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No PSV operators found for $selectedLocation',
                            style: TextStyle(
                                color: Colors.green[900], fontSize: 18),
                          ),
                        );
                      }
                      List<PsvOperatorModel> psvOperators = snapshot.data!;
                      return ListView.builder(
                        itemCount: psvOperators.length,
                        itemBuilder: (context, index) {
                          PsvOperatorModel psvOperator = psvOperators[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                psvOperator.fullName,
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                psvOperator.phoneNumber,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PsvOperatorDetailsPage(
                                            psvOperator: psvOperator),
                                  ),
                                );
                              },
                              trailing: IconButton(
                                icon:
                                    Icon(Icons.call, color: Colors.green[900]),
                                onPressed: () {
                                  _launchPhoneDialer(psvOperator
                                      .phoneNumber); // Call the number
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
    );
  }
}

class PsvOperatorDetailsPage extends StatelessWidget {
  final PsvOperatorModel psvOperator;

  const PsvOperatorDetailsPage({Key? key, required this.psvOperator})
      : super(key: key);

  // Function to launch the phone dialer
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
        title: Text(
          'PSV Operator Details',
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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailItem(
              title: 'Full Name',
              value: psvOperator.fullName,
            ),
            _buildDetailItem(
              title: 'Phone Number',
              value: psvOperator.phoneNumber,
              isPhoneNumber: true, // Indicates this is a phone number
            ),
            _buildDetailItem(
              title: 'Area of Operation',
              value: psvOperator.areaOfOperation ?? 'N/A', // Handle null value
            ),
            if (psvOperator.vehicleImageUrl !=
                null) // Show vehicle image if available
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(
                  psvOperator.vehicleImageUrl!,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            if (psvOperator.driverImageUrl !=
                null) // Show driver image if available
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(
                  psvOperator.driverImageUrl!,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String value,
    bool isPhoneNumber = false, // For phone numbers, set this to true
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green[900],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[700],
                  ),
                ),
              ),
              if (isPhoneNumber)
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green[900]),
                  onPressed: () {
                    _launchPhoneDialer(value); // Call the number when pressed
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
