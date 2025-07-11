import 'package:flutter/material.dart';
import '../main.dart';

class CustomerView extends StatelessWidget {
  const CustomerView({super.key});

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ToggleLoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text('This is the customer view'),
      ),
    );
  }
}
