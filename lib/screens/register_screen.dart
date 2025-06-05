import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? selectedGender;
  DateTime? selectedDate;
  File? profileImage;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => profileImage = File(pickedFile.path));
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> registerUser() async {
    if (profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a profile image')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    try {
      final uri = Uri.parse('https://ib.jamalmoallart.com/api/v2/register');
      final response = await http.post(
        uri,
        headers: {'Accept': 'application/json'},
        body: {
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
      );

      final decoded = json.decode(response.body);
      debugPrint("Register Response: ${response.body}");

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', firstNameController.text.trim());
        await prefs.setString('user_email', emailController.text.trim());
        await prefs.setString('user_phone', phoneController.text.trim());
        await prefs.setString('user_address', addressController.text.trim());
        await prefs.setString('profile_image_path', profileImage!.path);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful. Please login.')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(decoded['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      debugPrint("Register Error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      labelStyle: TextStyle(color: Colors.blueAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!) as ImageProvider
                      : null,
                  child: profileImage == null
                      ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
                      : null,
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: firstNameController,
                decoration: fieldDecoration('First Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your first name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                decoration: fieldDecoration('Last Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your last name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: fieldDecoration('Phone'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your phone' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: fieldDecoration('Address'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: fieldDecoration('Email'),
                validator: (v) =>
                    v == null || !v.contains('@') ? 'Enter valid email' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: fieldDecoration('Password'),
                validator: (v) =>
                    v == null || v.length < 6 ? 'Min 6 chars' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: fieldDecoration('Confirm Password'),
                validator: (v) => v != passwordController.text
                    ? 'Passwords do not match'
                    : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: fieldDecoration("Gender"),
                items: ['Male', 'Female'].map((g) {
                  return DropdownMenuItem(value: g, child: Text(g));
                }).toList(),
                onChanged: (val) => setState(() => selectedGender = val),
                validator: (v) => v == null ? 'Choose gender' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    selectedDate != null
                        ? selectedDate!.toLocal().toString().split(' ')[0]
                        : 'Select Date of Birth',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: pickDate,
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
