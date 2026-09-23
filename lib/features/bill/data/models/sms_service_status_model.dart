class SmsServiceStatusModel {
  const SmsServiceStatusModel({
    required this.isSuccess,
    required this.accountNo,
    required this.tpNo,
    required this.smsServiceStatus,
    required this.status,
    this.errorMessage,
  });

  final bool isSuccess;
  final String accountNo;
  final String tpNo;
  final String smsServiceStatus; // "ACTIVE" or "INACTIVE"
  final String status;           // "active" or other
  final String? errorMessage;

  bool get isActive =>
      smsServiceStatus.toUpperCase() == 'ACTIVE' ||
      status.toLowerCase() == 'active';

  factory SmsServiceStatusModel.fromJson(Map<String, dynamic> json) {
    return SmsServiceStatusModel(
      isSuccess: json['isSuccess'] == true || json['status'] != null,
      accountNo: json['accountNo']?.toString() ?? '',
      tpNo: json['tpNo']?.toString() ?? '',
      smsServiceStatus: json['smsServiceStatus']?.toString().toUpperCase() ?? 'INACTIVE',
      status: json['status']?.toString() ?? 'active',
      errorMessage: json['errorMessage']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'accountNo': accountNo,
        'tpNo': tpNo,
        'smsServiceStatus': smsServiceStatus,
        'status': status,
        if (errorMessage != null) 'errorMessage': errorMessage,
      };

  SmsServiceStatusModel copyWith({
    bool? isSuccess,
    String? accountNo,
    String? tpNo,
    String? smsServiceStatus,
    String? status,
    String? errorMessage,
  }) {
    return SmsServiceStatusModel(
      isSuccess: isSuccess ?? this.isSuccess,
      accountNo: accountNo ?? this.accountNo,
      tpNo: tpNo ?? this.tpNo,
      smsServiceStatus: smsServiceStatus ?? this.smsServiceStatus,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
