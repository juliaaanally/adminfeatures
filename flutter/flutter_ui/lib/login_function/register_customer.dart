import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class RegisterCustomer extends StatefulWidget {
  const RegisterCustomer({super.key});

  @override
  State<RegisterCustomer> createState() => _RegisterCustomerState();
}

class _RegisterCustomerState extends State<RegisterCustomer> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  String errorMsg = '';
  String successMsg = '';
  bool isLoading = false;

  Future<void> registerCustomer() async {
    setState(() {
      isLoading = true;
      errorMsg = '';
      successMsg = '';
    });

    final url = Uri.parse('http://10.0.2.2:8000/api/register/');
    final response = await http.post(url, body: {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'name': nameController.text.trim(),
    });

    setState(() => isLoading = false);

    if (response.statusCode == 201) {
      setState(() {
        successMsg = 'Registered successfully! You may now log in.';
        emailController.clear();
        passwordController.clear();
        nameController.clear();
      });
    } else {
      final data = json.decode(response.body);
      setState(() {
        errorMsg = data.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: isLoading ? null : registerCustomer,
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('Register'),
          ),
          if (successMsg.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(successMsg,
                  style: const TextStyle(color: Colors.green)),
            ),
          if (errorMsg.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child:
                  Text(errorMsg, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}
