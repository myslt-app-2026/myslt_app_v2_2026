/// Core user entity for the mySLT domain layer.
/// Pure Dart, no Flutter or external dependencies.
class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.nic,
    required this.mobile,
    required this.email,
    required this.accountNumber,
    this.token,
    this.refreshToken,
    this.tokenExpiry,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String nic;
  final String mobile;
  final String email;
  final String accountNumber;
  final String? token;
  final String? refreshToken;
  final DateTime? tokenExpiry;
  final String? avatarUrl;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  bool get hasValidToken {
    if (token == null) return false;
    if (tokenExpiry == null) return true;
    return tokenExpiry!.isAfter(DateTime.now());
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? nic,
    String? mobile,
    String? email,
    String? accountNumber,
    String? token,
    String? refreshToken,
    DateTime? tokenExpiry,
    String? avatarUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nic: nic ?? this.nic,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      accountNumber: accountNumber ?? this.accountNumber,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
