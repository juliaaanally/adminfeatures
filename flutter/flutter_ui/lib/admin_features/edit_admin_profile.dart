import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditAdminProfilePage extends StatefulWidget {
  final String email;

  EditAdminProfilePage({required this.email});

  @override
  _EditAdminProfilePageState createState() => _EditAdminProfilePageState();
}

class _EditAdminProfilePageState extends State<EditAdminProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAdminData();
  }

  void fetchAdminData() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/admin/profile/?email=${widget.email}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nameController.text = data['name'] ?? '';
        contactController.text = data['contact_num'] ?? '';
        emailController.text = data['email'] ?? '';
        roleController.text = data['role'] ?? 'admin';
        isLoading = false;
      });
    } else {
      print('Failed to load admin data: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveProfile() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/admin/profile/');
    final body = json.encode({
      'email': emailController.text.trim(),
      'name': nameController.text.trim(),
      'contact_num': contactController.text.trim(),
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Name"),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: contactController,
                      decoration: InputDecoration(labelText: "Contact"),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: roleController,
                      decoration: InputDecoration(labelText: "Role"),
                      readOnly: true,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: "Email"),
                      readOnly: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveProfile();
                        }
                      },
                      child: Text("Save Changes"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
