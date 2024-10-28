import 'package:flutter/material.dart';

class MpesaPaymentScreen extends StatelessWidget {
  const MpesaPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Pesa Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Payment Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Mocking a successful payment for demonstration purposes
                bool paymentSuccessful = true;

                Navigator.pop(context, paymentSuccessful);
              },
              child: const Text('Complete Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
