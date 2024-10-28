import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safaricare/models/models.dart'; // Ensure models path is correct
import 'package:url_launcher/url_launcher.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import the package

class TractorOperatorsPage extends StatefulWidget {
  const TractorOperatorsPage({Key? key}) : super(key: key);

  @override
  _TractorOperatorsPageState createState() => _TractorOperatorsPageState();
}

class _TractorOperatorsPageState extends State<TractorOperatorsPage> {
  String? selectedLocation;
  List<String> availableLocations = [
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

  Future<List<TractorOperatorModel>> fetchTractorOperatorsByLocation(
      String location) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('tractor_operators')
        .where('areaOfOperation', isEqualTo: location)
        .get();

    return querySnapshot.docs.map((doc) {
      return TractorOperatorModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
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
          'Tractor Operators',
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
            // DropdownSearch to select a location with search functionality
            DropdownSearch<String>(
              items: availableLocations,
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
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue;
                });
              },
              selectedItem: selectedLocation,
            ),
            const SizedBox(height: 20),

            // Show operators based on the selected location
            selectedLocation == null
                ? Center(
                    child: Text(
                      'Please select a location to see available operators',
                      style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 18,
                      ),
                    ),
                  )
                : Expanded(
                    child: FutureBuilder<List<TractorOperatorModel>>(
                      future: fetchTractorOperatorsByLocation(
                          selectedLocation!), // Pass the selected location
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
                              'No tractor operators found in $selectedLocation',
                              style: TextStyle(
                                color: Colors.green[900],
                                fontSize: 18,
                              ),
                            ),
                          );
                        }
                        List<TractorOperatorModel> operators = snapshot.data!;
                        return ListView.builder(
                          itemCount: operators.length,
                          itemBuilder: (context, index) {
                            TractorOperatorModel operator = operators[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  operator.fullName,
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  operator.phoneNumber,
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
                                          TractorOperatorDetailsPage(
                                              operator: operator),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.call,
                                      color: Colors.green[900]),
                                  onPressed: () {
                                    _makePhoneCall(operator.phoneNumber);
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

class TractorOperatorDetailsPage extends StatelessWidget {
  final TractorOperatorModel operator;

  const TractorOperatorDetailsPage({Key? key, required this.operator})
      : super(key: key);

  Future<void> _makePhoneCall(String phoneNumber) async {
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
          'Tractor Operator Details',
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
              value: operator.fullName,
            ),
            _buildDetailItem(
              title: 'Phone Number',
              value: operator.phoneNumber,
              isPhone: true,
            ),
            _buildDetailItem(
              title: 'Area of Operation',
              value: operator.areaOfOperation,
            ),
            _buildDetailItem(
              title: 'Vehicle Number',
              value: operator.vehicleNumber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String value,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          if (isPhone)
            IconButton(
              icon: Icon(Icons.call, color: Colors.green[900]),
              onPressed: () => _makePhoneCall(value),
            ),
        ],
      ),
    );
  }
}
