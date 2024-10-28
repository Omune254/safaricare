import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:safaricare/AUTH/chat_screen.dart';
import 'Mpesa_Payment.dart';
import 'package:safaricare/models/models.dart';

class CarOperator extends StatelessWidget {
  const CarOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Registration and Chat
      child: Scaffold(
        backgroundColor: Colors.lightBlue[200],
        appBar: AppBar(
          title: const Text('Car Hire Operator Registration',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green[900],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Registration'),
              Tab(text: 'Chat'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CarOperatorForm(), // Registration Form tab
            ChatScreen(
              recipientId: '',
              recipientName: '',
            ), // Chat tab
          ],
        ),
      ),
    );
  }
}

class CarOperatorForm extends StatefulWidget {
  const CarOperatorForm({super.key});

  @override
  CarOperatorFormState createState() => CarOperatorFormState();
}

class CarOperatorFormState extends State<CarOperatorForm> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _phoneNumber = '';
  String? _areaOfOperation;
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
    "Uringu"
  ];

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Store context before awaiting
      BuildContext dialogContext = context;

      bool paymentSuccessful = await Navigator.push(
        dialogContext,
        MaterialPageRoute(builder: (context) => const MpesaPaymentScreen()),
      );

      if (paymentSuccessful) {
        setState(() {
          _isLoading = true;
        });

        try {
          // Upload images to Firebase Storage
          String? vehicleImageUrl;
          if (_vehicleImage != null) {
            vehicleImageUrl = await _uploadImageToStorage(_vehicleImage!);
          }

          String? driverImageUrl;
          if (_driverImage != null) {
            driverImageUrl = await _uploadImageToStorage(_driverImage!);
          }

          // Create a new car operator instance
          CarOperatorModel carOperator = CarOperatorModel(
            fullName: _fullName,
            phoneNumber: _phoneNumber,
            areaOfOperation: _areaOfOperation,
            vehicleImageUrl: vehicleImageUrl,
            driverImageUrl: driverImageUrl,
            id: '',
          );

          // Save form data to Firestore
          DocumentReference operatorRef = await FirebaseFirestore.instance
              .collection('car_operators')
              .add(carOperator.toMap());

          // Save user role and details to users collection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'fullName': _fullName,
            'phoneNumber': _phoneNumber,
            'role': 'Car Operator',
            'areaOfOperation': _areaOfOperation,
            'vehicleImageUrl': vehicleImageUrl,
            'driverImageUrl': driverImageUrl,
          });

          // Display success message
          ScaffoldMessenger.of(dialogContext).showSnackBar(
              const SnackBar(content: Text('Form submitted successfully')));

          // Navigate to chat screen after successful submission
          if (!mounted) return; // Check if widget is still in the tree
          Navigator.push(
            dialogContext,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                recipientId: operatorRef.id, // Change to recipientId
                recipientName: _fullName, // Change to recipientName
              ),
            ),
          );

          _formKey.currentState!.reset();
        } catch (e) {
          ScaffoldMessenger.of(dialogContext).showSnackBar(
              SnackBar(content: Text('Error submitting form: $e')));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(dialogContext).showSnackBar(
            const SnackBar(content: Text('Payment was not successful')));
      }
    }
  }

  Future<String> _uploadImageToStorage(XFile image) async {
    File file = File(image.path);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('car_operator_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
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
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
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
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                initialCountryCode: 'KE',
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
              ),
              const SizedBox(height: 10),
              DropdownSearch<String>(
                items: _areasOfOperation,
                dropdownBuilder: (context, selectedItem) {
                  return Text(selectedItem ?? 'Select Area of Operation');
                },
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                ),
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
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Area of Operation',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _vehicleImage = pickedFile;
                    });
                  }
                },
                child: Text(_vehicleImage == null
                    ? 'Select Vehicle Image'
                    : 'Change Vehicle Image'),
              ),
              if (_vehicleImage != null) ...[
                const SizedBox(height: 10),
                Image.file(File(_vehicleImage!.path), height: 150),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _vehicleImage = null;
                    });
                  },
                  child: const Text('Remove Vehicle Image'),
                ),
              ],
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _driverImage = pickedFile;
                    });
                  }
                },
                child: Text(_driverImage == null
                    ? 'Select Driver Image'
                    : 'Change Driver Image'),
              ),
              if (_driverImage != null) ...[
                const SizedBox(height: 10),
                Image.file(File(_driverImage!.path), height: 150),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _driverImage = null;
                    });
                  },
                  child: const Text('Remove Driver Image'),
                ),
              ],
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Center(
                    child: Text('Submit Registration'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
