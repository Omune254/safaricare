import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:safaricare/models/models.dart';

import 'Mpesa_Payment.dart';

class MechanicOperator extends StatelessWidget {
  const MechanicOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: const Text(
          'Mechanic Operator Registration',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const MechanicOperatorForm(),
    );
  }
}

class MechanicOperatorForm extends StatefulWidget {
  const MechanicOperatorForm({super.key});

  @override
  MechanicOperatorFormState createState() => MechanicOperatorFormState();
}

class MechanicOperatorFormState extends State<MechanicOperatorForm> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _phoneNumber = '';
  String _areaOfOperation = '';
  XFile? _garageImage;
  bool _isLoading = false;

  // List of predefined areas of operation
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
          // Upload garage image to Firebase Storage
          String? garageImageUrl;
          if (_garageImage != null) {
            garageImageUrl = await _uploadImageToStorage(_garageImage!);
          }

          // Create a new mechanic operator instance
          MechanicOperatorModel mechanicOperator = MechanicOperatorModel(
            fullName: _fullName,
            phoneNumber: _phoneNumber,
            areaOfOperation: _areaOfOperation,
            garageImageUrl: garageImageUrl,
          );

          // Save form data to Firestore
          await FirebaseFirestore.instance
              .collection('mechanic_operators')
              .add(mechanicOperator.toMap());

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form submitted successfully')));

          // Clear the form
          _resetForm();
        } catch (e) {
          print('Error submitting form: $e');
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error submitting form')));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment was not successful')));
      }
    }
  }

  Future<String> _uploadImageToStorage(XFile image) async {
    File file = File(image.path);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('mechanic_operator_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _fullName = '';
      _phoneNumber = '';
      _areaOfOperation = '';
      _garageImage = null;
    });
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.green[900]),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green[900]!),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _garageImage = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: _inputDecoration('Full Name', Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) => _fullName = value!,
              ),
              const SizedBox(height: 10),
              IntlPhoneField(
                decoration: _inputDecoration('Phone Number', Icons.phone),
                initialCountryCode: 'KE', // Set to Kenya for example
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
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration:
                    _inputDecoration('Area of Operation', Icons.location_on),
                value: _areaOfOperation.isNotEmpty ? _areaOfOperation : null,
                items: _areasOfOperation.map((area) {
                  return DropdownMenuItem(
                    value: area,
                    child: Text(area),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _areaOfOperation = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your area of operation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
                ),
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text(
                  'Upload Garage Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              if (_garageImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    File(_garageImage!.path),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[900],
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
