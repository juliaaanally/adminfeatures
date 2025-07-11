import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  String message = '';
  bool isLoading = false;

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() => message = 'Please enter your email');
      return;
    }

    setState(() {
      isLoading = true;
      message = '';
    });

    final url = Uri.parse('http://10.0.2.2:8000/api/forgot-password/');
    final response = await http.post(url, body: {'email': email});

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      setState(() {
        message = 'Reset link sent to your email. Check your inbox.';
      });
    } else {
      setState(() {
        message = 'No account found with that email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : sendResetLink,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Send Reset Link'),
            ),
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  message,
                  style: TextStyle(
                      color: message.contains('sent') ? Colors.green : Colors.red),
                ),
              )
          ],
        ),
      ),
    );
  }
}
