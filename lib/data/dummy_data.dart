import 'package:marketsapce_app/@types/role.dart';
import 'package:marketsapce_app/models/user.dart';

class MockUserData extends User {
  String password;

  MockUserData({
    required this.password,
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.avatar,
    required super.role,
    required super.isActive,
    required super.createdAt,
  });
}

List<MockUserData> mockUsers = [
  MockUserData(
    id: '1',
    name: 'Maria Gomes',
    password: 'maria@123',
    email: 'maria.gomes@gmail.com',
    phone: '92988283298',
    avatar: '',
    role: Role.customerSeller,
    isActive: true,
    createdAt: DateTime.now(),
  ),
];
