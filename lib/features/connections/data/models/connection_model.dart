import 'package:flutter/material.dart';

enum ConnectionType { fiber, mobile, adsl }

extension ConnectionTypeExtension on ConnectionType {
  String get label {
    switch (this) {
      case ConnectionType.fiber:
        return 'Fiber';
      case ConnectionType.mobile:
        return 'Mobile';
      case ConnectionType.adsl:
        return 'ADSL';
    }
  }

  IconData get icon {
    switch (this) {
      case ConnectionType.fiber:
        return Icons.wifi_rounded;
      case ConnectionType.mobile:
        return Icons.smartphone_rounded;
      case ConnectionType.adsl:
        return Icons.router_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ConnectionType.fiber:
        return const Color(0xFF003087);
      case ConnectionType.mobile:
        return const Color(0xFF00AEEF);
      case ConnectionType.adsl:
        return const Color(0xFF6B7280);
    }
  }
}

class ConnectionModel {
  const ConnectionModel({
    required this.id,
    required this.accountNumber,
    required this.name,
    required this.type,
    required this.isActive,
    required this.planName,
  });

  final String id;
  final String accountNumber;
  final String name;
  final ConnectionType type;
  final bool isActive;
  final String planName;

  ConnectionModel copyWith({
    String? id,
    String? accountNumber,
    String? name,
    ConnectionType? type,
    bool? isActive,
    String? planName,
  }) {
    return ConnectionModel(
      id: id ?? this.id,
      accountNumber: accountNumber ?? this.accountNumber,
      name: name ?? this.name,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      planName: planName ?? this.planName,
    );
  }
}
