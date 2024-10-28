import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:safaricare/models/models.dart';

import 'Mpesa_Payment.dart';

class LorryOperator extends StatelessWidget {
  const LorryOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100], // Slightly lighter background
      appBar: AppBar(
        title: const Text(
          'Lorry Operator Registration',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            Colors.green[800], // Slightly darker green for contrast
        elevation: 5, // Add shadow for a modern look
        centerTitle: true, // Center the title
      ),
      body: const LorryOperatorForm(),
    );
  }
}

class LorryOperatorForm extends StatefulWidget {
  const LorryOperatorForm({super.key});

  @override
  _LorryOperatorFormState createState() => _LorryOperatorFormState();
}

class _LorryOperatorFormState extends State<LorryOperatorForm> {
  final _formKey = GlobalKey<FormState>();

  String _fullName = '';
  String _phoneNumber = '';
  String? _areaOfOperation; // Changed to nullable to handle dropdown selection
  XFile? _vehicleImage;
  XFile? _driverImage;
  bool _isLoading = false;

  final List<String> _areasOfOperation = [
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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Navigate to M-Pesa Payment Screen
      bool paymentSuccessful = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MpesaPaymentScreen()),
      );

      if (paymentSuccessful) {
        setState(() {
          _isLoading = true;
        });

        try {
          String? vehicleImageUrl;
          if (_vehicleImage != null) {
            vehicleImageUrl = await _uploadImageToStorage(_vehicleImage!);
          }

          String? driverImageUrl;
          if (_driverImage != null) {
            driverImageUrl = await _uploadImageToStorage(_driverImage!);
          }

          LorryOperatorModel lorryOperator = LorryOperatorModel(
            fullName: _fullName,
            phoneNumber: _phoneNumber,
            areaOfOperation: _areaOfOperation!,
            vehicleImageUrl: vehicleImageUrl,
            driverImageUrl: driverImageUrl,
          );

          await FirebaseFirestore.instance
              .collection('lorry_operators')
              .add(lorryOperator.toMap());

          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'fullName': _fullName,
            'phoneNumber': _phoneNumber,
            'role': 'Lorry Operator',
            'areaOfOperation': _areaOfOperation,
            'vehicleImageUrl': vehicleImageUrl,
            'driverImageUrl': driverImageUrl,
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Form submitted successfully')));

          _formKey.currentState!.reset();
          setState(() {
            _fullName = '';
            _phoneNumber = '';
            _areaOfOperation = null;
            _vehicleImage = null;
            _driverImage = null;
          });
        } catch (e) {
          print('Error submitting form: $e');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error submitting form')));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment was not successful')));
      }
    }
  }

  Future<String> _uploadImageToStorage(XFile image) async {
    File file = File(image.path);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('lorry_operator_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50], // Slightly softer blue background
        borderRadius:
            BorderRadius.circular(20), // Rounded corners for a modern look
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(
                label: 'Full Name',
                onSaved: (value) => _fullName = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildPhoneField(),
              const SizedBox(height: 10),
              _buildAreaOfOperationDropdown(),
              const SizedBox(height: 10),
              _buildImageUploadButton(
                label: 'Upload Vehicle Picture',
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _vehicleImage = pickedFile;
                    });
                  }
                },
                image: _vehicleImage,
              ),
              const SizedBox(height: 10),
              _buildImageUploadButton(
                label: 'Upload Driver Picture',
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _driverImage = pickedFile;
                    });
                  }
                },
                image: _driverImage,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded button
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green[800]!),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildPhoneField() {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green[800]!),
        ),
      ),
      initialCountryCode: 'KE', // Changed to 'KE' for Kenya
      validator: (value) {
        if (value == null || value.number.isEmpty) {
          return 'Please enter your phone number';
        }
        if (value.number.length != 9) {
          return 'Phone number must be exactly 9 characters long';
        }
        return null;
      },
      onSaved: (value) => _phoneNumber = value!.completeNumber,
    );
  }

  Widget _buildAreaOfOperationDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Area of Operation',
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green[800]!),
        ),
      ),
      value: _areaOfOperation,
      items: _areasOfOperation.map((area) {
        return DropdownMenuItem(
          value: area,
          child: Text(area),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _areaOfOperation = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an area of operation';
        }
        return null;
      },
      onSaved: (value) {
        _areaOfOperation = value;
      },
    );
  }

  Widget _buildImageUploadButton({
    required String label,
    required VoidCallback onPressed,
    XFile? image,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[800],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        if (image != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Image selected: ${image.name}',
              style: TextStyle(color: Colors.green[800]),
            ),
          ),
      ],
    );
  }
}
