class PushNotificationResultModel {
  const PushNotificationResultModel({
    required this.isSuccess,
    this.messageId,
    this.state,
    this.messageType,
    this.errorMessage,
  });

  final bool isSuccess;
  final String? messageId;
  final String? state;
  final String? messageType;
  final String? errorMessage;

  factory PushNotificationResultModel.fromJson(Map<String, dynamic> json) {
    final bundle = json['dataBundle'];
    final data = bundle is Map<String, dynamic>
        ? bundle
        : (bundle is Map ? Map<String, dynamic>.from(bundle) : null);

    return PushNotificationResultModel(
      isSuccess: json['isSuccess'] == true || json['statusCode'] == 200,
      messageId: data?['messageId']?.toString(),
      state: data?['state']?.toString() ?? 'Delivered',
      messageType: data?['messageType']?.toString() ?? 'Push',
      errorMessage: json['errorMessege']?.toString() ?? json['errorMessage']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'messageId': messageId,
        'state': state,
        'messageType': messageType,
        if (errorMessage != null) 'errorMessage': errorMessage,
      };
}
