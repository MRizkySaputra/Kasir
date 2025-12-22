class UserModel {
  final int id;
  final String name;
  final String email;
  final String? password;
  final String role;
  final String address;
  final String phone;
  final String avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.address,
    required this.phone,
    required this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw Exception("User id is null");
    }
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "address": address,
      "phone": phone,
      "avatar": avatar,
    };
  }
}
