import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safaricare/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultLoginScreen extends StatefulWidget {
  const DefaultLoginScreen({Key? key}) : super(key: key);

  @override
  State<DefaultLoginScreen> createState() => _DefaultLoginScreenState();
}

class _DefaultLoginScreenState extends State<DefaultLoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  String selectedUserType = 'customer'; // Default user type
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // To manage loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: MediaQuery.of(context).size.height * 0.15,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Login to your account',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 30),
                // Dropdown for user type selection
                DropdownButtonFormField<String>(
                  value: selectedUserType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUserType = newValue!;
                    });
                  },
                  items: <String>['customer', 'tenant']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Select User Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Email",
                  Icons.email,
                  false,
                  _emailTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // The SignInSignUpButton with proper arguments
                SignInSignUpButton(
                  context: context,
                  isLogin: true, // It's a login button
                  onTap: _login, // Your login function
                  isLoading: isLoading, // Control loading state
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Login function
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return; // Only proceed if the form is valid
    }

    setState(() {
      isLoading = true; // Start loading
    });

    // After login, store the user type in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', selectedUserType);

    // Perform login logic here
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
      );

      // Navigate to the appropriate screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(), // Replace with your home page
        ),
      );
    } catch (e) {
      print('Login error: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }
}

// Reusable button for sign in and sign up
Container SignInSignUpButton({
  required BuildContext context,
  required bool isLogin,
  required Function onTap,
  required bool isLoading,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 58,
    margin: const EdgeInsets.fromLTRB(0, 18, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
    child: ElevatedButton(
      onPressed: isLoading ? null : () => onTap(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.green[800]; // Darker green when pressed
          }
          return Colors.green[900]; // Default green color
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              isLogin ? 'LOG IN' : 'SIGN UP',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    ),
  );
}

// Reusable text field
Widget reusableTextField(
  String hintText,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller, {
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    validator: validator,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white),
      labelText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}
