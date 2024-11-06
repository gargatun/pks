// lib/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String phone;
  late String email;
  String? avatarPath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        avatarPath = image.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserModel>(context, listen: false);
    firstName = user.firstName;
    lastName = user.lastName;
    phone = user.phone;
    email = user.email;
    avatarPath = user.avatarPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Редактировать профиль"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Увеличили отступы
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: avatarPath != null
                        ? (avatarPath!.startsWith('assets/')
                        ? AssetImage(avatarPath!) as ImageProvider
                        : FileImage(File(avatarPath!)))
                        : const AssetImage('assets/default_avatar.png'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: firstName,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  prefixIcon: Icon(Icons.person),
                ),
                style: GoogleFonts.openSans(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите имя';
                  }
                  return null;
                },
                onSaved: (value) {
                  firstName = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: lastName,
                decoration: const InputDecoration(
                  labelText: 'Фамилия',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                style: GoogleFonts.openSans(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите фамилию';
                  }
                  return null;
                },
                onSaved: (value) {
                  lastName = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(
                  labelText: 'Телефон',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                style: GoogleFonts.openSans(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите телефон';
                  }
                  return null;
                },
                onSaved: (value) {
                  phone = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(
                  labelText: 'Почта',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.openSans(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите почту';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Пожалуйста, введите корректную почту';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<UserModel>(context, listen: false).updateUser(
                      firstName: firstName,
                      lastName: lastName,
                      phone: phone,
                      email: email,
                      avatarPath: avatarPath,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Профиль обновлен')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Сохранить"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
