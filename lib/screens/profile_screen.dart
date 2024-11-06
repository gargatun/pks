// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            tooltip: 'Редактировать профиль',
          ),
        ],
      ),
      body: Consumer<UserModel>(
        builder: (context, user, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(user.avatarPath),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('${user.firstName} ${user.lastName}'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(user.phone),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(user.email),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
