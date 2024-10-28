import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safaricare/models/models.dart';

import 'Mpesa_Payment.dart';

class PickupOperator extends StatelessWidget {
  const PickupOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: const Text(
          'Pickup Operator Registration',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const PickupOperatorForm(),
    );
  }
}

class PickupOperatorForm extends StatefulWidget {
  const PickupOperatorForm({super.key});

  @override
  PickupOperatorFormState createState() {
    return PickupOperatorFormState();
  }
}

class PickupOperatorFormState extends State<PickupOperatorForm> {
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

          // Create a new pickup operator instance
          PickupOperatorModel pickupOperator = PickupOperatorModel(
            fullName: _fullName,
            phoneNumber: _phoneNumber,
            areaOfOperation: _areaOfOperation,
            vehicleImageUrl: vehicleImageUrl,
            driverImageUrl: driverImageUrl,
          );

          // Save form data to Firestore
          await FirebaseFirestore.instance
              .collection('pickup_operators')
              .add(pickupOperator.toFirestore());

          // Save user role and details to users collection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'fullName': _fullName,
            'phoneNumber': _phoneNumber,
            'role': 'Pickup Operator',
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
          .child('pickup_operator_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Image upload failed, please try again.';
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
      ),
    );
  }

  Future<void> _pickImage(bool isVehicleImage) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (isVehicleImage) {
            _vehicleImage = pickedFile;
          } else {
            _driverImage = pickedFile;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to pick image')));
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
                decoration:
                    _inputDecoration('Area of Operation', Icons.location_on),
                items: _areasOfOperation.map((String area) {
                  return DropdownMenuItem<String>(
                    value: area,
                    child: Text(area),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _areaOfOperation = value!;
                }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your area of operation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _pickImage(true),
                icon: const Icon(Icons.car_rental),
                label: const Text('Upload Vehicle Picture'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
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
              ElevatedButton.icon(
                onPressed: () => _pickImage(false),
                icon: const Icon(Icons.person),
                label: const Text('Upload Driver Picture'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
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
