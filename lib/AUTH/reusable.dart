import 'package:flutter/material.dart';

// Reusable Text Field
TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller,
    {required String? Function(dynamic value) validator}) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor:
        const Color(0xFF0072FF), // Gradient's primary color for the cursor
    style: const TextStyle(color: Colors.black), // Black text for input
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF0072FF), // Gradient primary color for icons
      ),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.black54), // Soft black label
      filled: true,
      fillColor: Colors.white, // Solid white fill for clarity
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(
          color: Color(0xFF00C6FF), // Gradient secondary color on focus
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none, // No border by default
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

// Reusable Sign In/Sign Up Button
Container SignInSignUpButton(
    BuildContext context, bool isLogin, Function onTap, bool isLoading) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 58,
    margin: const EdgeInsets.fromLTRB(0, 18, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      gradient: const LinearGradient(
        colors: [
          Color(0xFF0072FF),
          Color(0xFF00C6FF)
        ], // Gradient as per login design
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Subtle shadow for depth
          blurRadius: 10,
          offset: const Offset(2, 4),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: isLoading ? null : () => onTap(),
      style: ElevatedButton.styleFrom(
        elevation: 0, // Remove default elevation
        primary: Colors.transparent, // Transparent background to show gradient
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              isLogin ? 'LOG IN' : 'SIGN UP',
              style: const TextStyle(
                color: Colors.white, // White text for better contrast
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    ),
  );
}
