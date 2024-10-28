import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safaricare/models/models.dart'; // Ensure this imports MotorbikeOperatorModel
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:dropdown_search/dropdown_search.dart'; // Import dropdown_search

class MotorbikeOperatorsPage extends StatefulWidget {
  const MotorbikeOperatorsPage({Key? key}) : super(key: key);

  @override
  _MotorbikeOperatorsPageState createState() => _MotorbikeOperatorsPageState();
}

class _MotorbikeOperatorsPageState extends State<MotorbikeOperatorsPage> {
  String? selectedLocation; // To store the selected location
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
  ]; // Predefined list of locations

  Future<List<MotorbikeOperatorModel>> fetchMotorbikeOperators() async {
    if (selectedLocation == null) {
      return []; // Return empty list if no location is selected
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('motorbike_operators')
        .where('areaOfOperation', isEqualTo: selectedLocation)
        .get();

    return querySnapshot.docs.map((doc) {
      return MotorbikeOperatorModel.fromMap(doc.data() as Map<String, dynamic>);
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
          'Motorbike Operators',
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
            // Dropdown with search functionality for selecting location
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownSearch<String>(
                items: locations,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select Location",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                ),
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value; // Update selected location
                  });
                },
                selectedItem: selectedLocation,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<MotorbikeOperatorModel>>(
                future: fetchMotorbikeOperators(),
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
                        'No motorbike operators found in this location',
                        style:
                            TextStyle(color: Colors.green[900], fontSize: 18),
                      ),
                    );
                  }
                  List<MotorbikeOperatorModel> motorbikeOperators =
                      snapshot.data!;
                  return ListView.builder(
                    itemCount: motorbikeOperators.length,
                    itemBuilder: (context, index) {
                      MotorbikeOperatorModel motorbikeOperator =
                          motorbikeOperators[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            motorbikeOperator.fullName,
                            style: TextStyle(
                              color: Colors.green[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            motorbikeOperator.phoneNumber,
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
                                    MotorbikeOperatorDetailsPage(
                                        operator: motorbikeOperator),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.call, color: Colors.green[900]),
                            onPressed: () {
                              _makePhoneCall(motorbikeOperator.phoneNumber);
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

class MotorbikeOperatorDetailsPage extends StatelessWidget {
  final MotorbikeOperatorModel operator;

  const MotorbikeOperatorDetailsPage({Key? key, required this.operator})
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
          'Motorbike Operator Details',
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
              isPhone: true, // Added to enable call icon
            ),
            if (operator.motorbikeImageUrl != null ||
                operator.driverImageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildImageRow(context),
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.green[900],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: Colors.green[700],
            fontSize: 16,
          ),
        ),
        trailing: isPhone
            ? IconButton(
                icon: Icon(Icons.call, color: Colors.green[900]),
                onPressed: () => _makePhoneCall(value),
              )
            : null,
      ),
    );
  }

  Widget _buildImageRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (operator.motorbikeImageUrl != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        ImageDialog(imageUrl: operator.motorbikeImageUrl!),
                  );
                },
                child: Image.network(operator.motorbikeImageUrl!),
              ),
            ),
          ),
        if (operator.driverImageUrl != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        ImageDialog(imageUrl: operator.driverImageUrl!),
                  );
                },
                child: Image.network(operator.driverImageUrl!),
              ),
            ),
          ),
      ],
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  const ImageDialog({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(imageUrl),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
