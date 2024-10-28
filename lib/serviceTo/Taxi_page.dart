import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import the package
import 'package:safaricare/models/models.dart';

class TaxiOperatorsPage extends StatefulWidget {
  const TaxiOperatorsPage({Key? key}) : super(key: key);

  @override
  _TaxiOperatorsPageState createState() => _TaxiOperatorsPageState();
}

class _TaxiOperatorsPageState extends State<TaxiOperatorsPage> {
  String? selectedLocation;
  final List<String> locations = [
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

  Future<List<TaxiOperatorModel>> fetchTaxiOperators(String location) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('taxi_operators')
        .where('areaOfOperation', isEqualTo: location)
        .get();

    return querySnapshot.docs.map((doc) {
      return TaxiOperatorModel.fromMap(doc.data() as Map<String, dynamic>);
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
          'Taxi Operators',
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
        child: Column(
          children: [
            // Dropdown with search functionality
            DropdownSearch<String>(
              items: locations,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Select Location",
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: "Search location...",
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
              selectedItem: selectedLocation,
            ),
            const SizedBox(height: 16),
            // Show taxi operators only after a location is selected
            selectedLocation == null
                ? Text(
                    'Please select a location to see available taxi operators',
                    style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 18,
                    ),
                  )
                : Expanded(
                    child: FutureBuilder<List<TaxiOperatorModel>>(
                      future: fetchTaxiOperators(selectedLocation!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                              'No taxi operators found in $selectedLocation',
                              style: TextStyle(
                                  color: Colors.green[900], fontSize: 18),
                            ),
                          );
                        }
                        List<TaxiOperatorModel> taxiOperators = snapshot.data!;
                        return ListView.builder(
                          itemCount: taxiOperators.length,
                          itemBuilder: (context, index) {
                            TaxiOperatorModel taxiOperator =
                                taxiOperators[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  taxiOperator.fullName,
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  taxiOperator.phoneNumber,
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
                                          TaxiOperatorDetailsPage(
                                              taxiOperator: taxiOperator),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.call,
                                      color: Colors.green[900]),
                                  onPressed: () {
                                    _launchPhoneDialer(
                                        taxiOperator.phoneNumber);
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

class TaxiOperatorDetailsPage extends StatelessWidget {
  final TaxiOperatorModel taxiOperator;

  const TaxiOperatorDetailsPage({Key? key, required this.taxiOperator})
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
          'Taxi Operator Details',
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
              value: taxiOperator.fullName,
            ),
            _buildDetailItem(
              title: 'Phone Number',
              value: taxiOperator.phoneNumber,
              isPhoneNumber: true,
            ),
            _buildDetailItem(
              title: 'Area of Operation',
              value: taxiOperator.areaOfOperation ?? 'Not specified',
            ),
            if (taxiOperator.vehicleImageUrl != null)
              _buildDetailItem(
                title: 'Vehicle Image',
                value: taxiOperator.vehicleImageUrl!,
                isImageUrl: true,
              ),
            if (taxiOperator.driverImageUrl != null)
              _buildDetailItem(
                title: 'Driver Image',
                value: taxiOperator.driverImageUrl!,
                isImageUrl: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String value,
    bool isPhoneNumber = false,
    bool isImageUrl = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
          if (isImageUrl)
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.network(value, fit: BoxFit.cover),
            )
          else
            Text(
              value,
              style: TextStyle(
                color: isPhoneNumber ? Colors.blue : Colors.black,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }
}
