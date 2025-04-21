import 'package:marketsapce_app/@types/role.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final Role role;
  final bool isActive;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  set id(String id) {
    this.id = id;
  }

  set name(String name) {
    this.name = name;
  }

  set email(String email) {
    this.email = email;
  }

  set phone(String? phone) {
    this.phone = phone;
  }

  set avatar(String? avatar) {
    this.avatar = avatar;
  }

  set role(Role role) {
    this.role = role;
  }

  set isActive(bool isActive) {
    this.isActive = isActive;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      role: Role.values.firstWhere(
        (e) => e.value == json['role'],
        orElse: () => Role.customer,
      ),
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
    );

    return user;
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, avatar: $avatar, role: $role, isActive: $isActive, createdAt: $createdAt)';
  }
}
