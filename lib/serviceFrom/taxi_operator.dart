import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safaricare/models/models.dart';
import 'package:safaricare/serviceFrom/Mpesa_Payment.dart'; // Import your M-Pesa payment screen

class TaxiOperator extends StatelessWidget {
  const TaxiOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: const Text(
          'Taxi Operator Registration',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const TaxiOperatorForm(),
    );
  }
}

class TaxiOperatorForm extends StatefulWidget {
  const TaxiOperatorForm({super.key});

  @override
  TaxiOperatorFormState createState() {
    return TaxiOperatorFormState();
  }
}

class TaxiOperatorFormState extends State<TaxiOperatorForm> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _phoneNumber = '';
  String _areaOfOperation = '';
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
          // Upload images to Firebase Storage
          String? vehicleImageUrl = _vehicleImage != null
              ? await _uploadImageToStorage(_vehicleImage!)
              : null;
          String? driverImageUrl = _driverImage != null
              ? await _uploadImageToStorage(_driverImage!)
              : null;

          // Create a new taxi operator instance
          TaxiOperatorModel taxiOperator = TaxiOperatorModel(
            fullName: _fullName,
            phoneNumber: _phoneNumber,
            areaOfOperation: _areaOfOperation,
            vehicleImageUrl: vehicleImageUrl,
            driverImageUrl: driverImageUrl,
          );

          // Save form data to Firestore
          await FirebaseFirestore.instance
              .collection('taxi_operators')
              .add(taxiOperator.toFirestore());

          // Save user role and details to users collection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'fullName': _fullName,
            'phoneNumber': _phoneNumber,
            'role': 'Taxi Operator',
            'areaOfOperation': _areaOfOperation,
            'vehicleImageUrl': vehicleImageUrl,
            'driverImageUrl': driverImageUrl,
          });

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form submitted successfully')));

          // Clear the form
          _formKey.currentState!.reset();
          setState(() {
            _fullName = '';
            _phoneNumber = '';
            _areaOfOperation = '';
            _vehicleImage = null;
            _driverImage = null;
          });
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
    try {
      File file = File(image.path);
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('taxi_operator_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Image upload failed, please try again.';
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, bool isVehicleImage) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isVehicleImage) {
          _vehicleImage = pickedFile;
        } else {
          _driverImage = pickedFile;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: _inputDecoration('Full Name'),
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
                decoration: _inputDecoration('Phone Number'),
                initialCountryCode: 'US',
                validator: (value) {
                  if (value == null || value.number.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.number.length < 9) {
                    return 'Phone number is too short';
                  }
                  return null;
                },
                onSaved: (value) => _phoneNumber = value!.completeNumber,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Area of Operation'),
                items: _areasOfOperation
                    .map((area) => DropdownMenuItem(
                          value: area,
                          child: Text(area),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your area of operation';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  _areaOfOperation = value!;
                }),
                onSaved: (value) => _areaOfOperation = value!,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
                ),
                child: const Text(
                  'Upload Vehicle Picture',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (_vehicleImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(
                    File(_vehicleImage!.path),
                    height: 150,
                  ),
                ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
                ),
                child: const Text(
                  'Upload Driver Picture',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (_driverImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(
                    File(_driverImage!.path),
                    height: 150,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[900],
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
