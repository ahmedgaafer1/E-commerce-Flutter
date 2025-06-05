import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String? profileImagePath;
  String userEmail = '';
  String userPhone = '';
  String userAddress = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      profileImagePath = prefs.getString('profile_image_path');
      userEmail = prefs.getString('user_email') ?? 'Not Available';
      userPhone = prefs.getString('user_phone') ?? 'Not Available';
      userAddress = prefs.getString('user_address') ?? 'Not Available';
    });
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImagePath != null
                  ? FileImage(File(profileImagePath!)) as ImageProvider
                  : const AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              subtitle: Text(userEmail),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Phone"),
              subtitle: Text(userPhone),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Address"),
              subtitle: Text(userAddress),
            ),
            const Spacer(),
            Card(
              elevation: 2,
              child: ListTile(
                onTap: logout,
                leading: const Icon(Icons.logout, color: Colors.blueAccent),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.blueAccent),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
