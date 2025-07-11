import 'package:flutter/material.dart';
import 'login_function/login_customer.dart';
import 'login_function/login_staff.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capstone App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ToggleLoginScreen(),
    );
  }
}

class ToggleLoginScreen extends StatefulWidget {
  const ToggleLoginScreen({super.key});
  @override
  State<ToggleLoginScreen> createState() => _ToggleLoginScreenState();
}

class _ToggleLoginScreenState extends State<ToggleLoginScreen> {
  bool showCustomerLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => setState(() => showCustomerLogin = true),
                child: const Text('Customer'),
              ),
              TextButton(
                onPressed: () => setState(() => showCustomerLogin = false),
                child: const Text('Staff? Click here'),
              ),
            ],
          ),
          Expanded(
          // child: showCustomerLogin ?  LoginCustomer() :  LoginStaff(),
          child: showCustomerLogin
            ? LoginCustomer()
            : LoginStaff(),
          )
        ],
      ),
    );
  }
}
