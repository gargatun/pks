// lib/models/user_model.dart

import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String firstName;
  String lastName;
  String phone;
  String email;
  String avatarPath; // Путь к изображению аватара

  UserModel({
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.email = '',
    this.avatarPath = 'assets/default_avatar.png',
  });

  void updateUser({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? avatarPath,
  }) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
    if (phone != null) this.phone = phone;
    if (email != null) this.email = email;
    if (avatarPath != null) this.avatarPath = avatarPath;
    notifyListeners();
  }
}
