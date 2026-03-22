import 'dart:convert';

/// Pwofil itilizatè: tout done ki sere pou yon kont (imèl, modpas, balans, dat).
class UserProfileModel {
  final String email;
  final String password;
  final double balance;
  final DateTime createdAt;

  const UserProfileModel({
    required this.email,
    required this.password,
    required this.balance,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'balance': balance,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'];
    return UserProfileModel(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      createdAt: createdAt is String
          ? DateTime.tryParse(createdAt) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  UserProfileModel copyWith({
    String? email,
    String? password,
    double? balance,
    DateTime? createdAt,
  }) =>
      UserProfileModel(
        email: email ?? this.email,
        password: password ?? this.password,
        balance: balance ?? this.balance,
        createdAt: createdAt ?? this.createdAt,
      );
}
