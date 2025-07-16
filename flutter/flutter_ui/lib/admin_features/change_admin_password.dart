import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeAdminPasswordPage extends StatefulWidget {
  final String email;

  const ChangeAdminPasswordPage({super.key, required this.email});

  @override
  State<ChangeAdminPasswordPage> createState() => _ChangeAdminPasswordPageState();
}

class _ChangeAdminPasswordPageState extends State<ChangeAdminPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPwController = TextEditingController();
  final TextEditingController newPwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final url = Uri.parse('http://10.0.2.2:8000/api/admin/change-password/');
    final body = json.encode({
      'email': widget.email,
      'current_password': currentPwController.text.trim(),
      'new_password': newPwController.text.trim(),
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully!')),
          );
          Navigator.pop(context);
        }
      } else {
        final data = json.decode(response.body);
        setState(() {
          errorMessage = data['error'] ?? 'Something went wrong';
        });
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        errorMessage = 'Something went wrong';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    currentPwController.dispose();
    newPwController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    TextFormField(
                      controller: currentPwController,
                      decoration: const InputDecoration(labelText: 'Current Password'),
                      obscureText: true,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter current password' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: newPwController,
                      decoration: const InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                      validator: (value) =>
                          value == null || value.length < 5 ? 'Minimum 5 characters' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: confirmPwController,
                      decoration: const InputDecoration(labelText: 'Confirm New Password'),
                      obscureText: true,
                      validator: (value) => value != newPwController.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _changePassword,
                      child: const Text('Change Password'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
