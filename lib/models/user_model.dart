class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final payload = _unwrap(json);

    return UserModel(
      id: _toInt(payload['id']),
      name: payload['name']?.toString() ?? '',
      email: payload['email']?.toString() ?? '',
      role: payload['role']?.toString() ?? 'user',
      emailVerifiedAt: _toDate(payload['email_verified_at']),
      createdAt: _toDate(payload['created_at']),
      updatedAt: _toDate(payload['updated_at']),
    );
  }

  bool get isEmailVerified => emailVerifiedAt != null;

  String get initial {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '?' : trimmed.substring(0, 1).toUpperCase();
  }

  String get roleLabel {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'manager':
        return 'Manager';
      case 'user':
        return 'User';
      default:
        return role.isEmpty ? '-' : role;
    }
  }

  bool get isAdmin => role.toLowerCase() == 'admin';

  bool get isManager => role.toLowerCase() == 'manager';

  /// Beberapa endpoint membungkus data dengan `data` atau `user`.
  static Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final nestedUser = data['user'];
      if (nestedUser is Map<String, dynamic>) return nestedUser;
      return data;
    }

    final user = json['user'];
    if (user is Map<String, dynamic>) return user;

    return json;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
