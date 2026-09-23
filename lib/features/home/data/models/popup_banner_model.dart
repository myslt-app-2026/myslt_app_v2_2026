class PopupBannerModel {
  const PopupBannerModel({
    required this.id,
    required this.title,
    required this.message,
    required this.popupUrl,
    required this.action,
    required this.buttonTitle,
    required this.status,
    this.popupType = 'PROMO',
  });

  final String id;
  final String title;
  final String message;
  final String popupUrl;
  final String action;
  final String buttonTitle;
  final String status;
  final String popupType;

  bool get isActive => status.toUpperCase() == 'ACTIVE';

  factory PopupBannerModel.fromJson(Map<String, dynamic> json) {
    return PopupBannerModel(
      id: json['notid']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Special Announcement',
      message: json['message']?.toString() ?? '',
      popupUrl: json['popup_URL']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      buttonTitle: json['button_TITLE']?.toString() ?? 'Explore Now',
      status: json['status']?.toString() ?? 'ACTIVE',
      popupType: json['popup_TYPE']?.toString() ?? 'PROMO',
    );
  }

  Map<String, dynamic> toJson() => {
        'notid': id,
        'title': title,
        'message': message,
        'popup_URL': popupUrl,
        'action': action,
        'button_TITLE': buttonTitle,
        'status': status,
        'popup_TYPE': popupType,
      };
}
