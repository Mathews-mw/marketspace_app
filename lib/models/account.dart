import 'package:marketsapce_app/@types/account_provider.dart';

class Account {
  final String id;
  final String userId;
  final AccountProvider provider;
  final String providerAccountId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Account({
    required this.id,
    required this.userId,
    required this.provider,
    required this.providerAccountId,
    required this.createdAt,
    required this.updatedAt,
  });

  set id(String id) {
    this.id = id;
  }

  set userId(String userId) {
    this.userId = userId;
  }

  set provider(AccountProvider provider) {
    this.provider = provider;
  }

  set providerAccountId(String? providerAccountId) {
    this.providerAccountId = providerAccountId;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  set updatedAt(DateTime? updatedAt) {
    this.updatedAt = updatedAt;
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      userId: json['user_id'],
      provider: AccountProvider.values.firstWhere(
        (e) => e.value == json['provider'],
        orElse: () => AccountProvider.credentials,
      ),
      providerAccountId: json['provider_account_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }
}
