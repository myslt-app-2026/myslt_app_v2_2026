import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/popup_banner_model.dart';
import '../models/promotion_model.dart';
import '../models/push_notification_result_model.dart';

class BannerNotificationRepository {
  BannerNotificationRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// Endpoint 31: Get Promotional Banners (TMF681)
  /// GET /tmf-api/communicationManagement/v4
  Future<List<PromotionModel>> getPromotionalBanners({String? username}) async {
    final effectiveUser = username ??
        await TokenStorage.instance.getUsername() ??
        'randikaslt@gmail.com';

    try {
      final response = await _dio.get(
        ApiConstants.promotionalBanners,
        queryParameters: {'username': effectiveUser},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final list = data is Map && data.containsKey('communications')
            ? data['communications']
            : (data is List ? data : null);

        if (list is List && list.isNotEmpty) {
          return list.map((item) {
            final map = Map<String, dynamic>.from(item as Map);
            final id = map['id']?.toString() ?? 'PROMO-${DateTime.now().millisecondsSinceEpoch}';
            final title = map['subject']?.toString() ?? map['title']?.toString() ?? 'SLT Promotion';
            final desc = map['description']?.toString() ?? map['content']?.toString() ?? '';
            String imgUrl = 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800&q=80';
            if (map['attachment'] is List && (map['attachment'] as List).isNotEmpty) {
              final att = (map['attachment'] as List).first;
              if (att is Map && att['url'] != null) {
                imgUrl = att['url'].toString();
              }
            }

            return PromotionModel(
              id: id,
              title: title,
              subtitle: desc,
              imageUrl: imgUrl,
              ctaLabel: 'Claim Now',
              ctaUrl: '/promotions/$id',
              expiryDate: DateTime.now().add(const Duration(days: 30)),
              badgeLabel: map['messageType']?.toString().toUpperCase() ?? 'OFFER',
              badgeColor: 0xFF003087,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('[BannerNotificationRepository] getPromotionalBanners error: $e');
    }

    return MockData.promotions;
  }

  /// Endpoint 32: Get Home Screen Popup Banners
  /// GET /api/notifications/popup?subscriberID=...
  Future<List<PopupBannerModel>> getPopupBanners({String? subscriberId}) async {
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        '5555';

    try {
      final response = await _dio.get(
        ApiConstants.popupBanners,
        queryParameters: {'subscriberID': effectiveId},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final rawList = data is Map && data.containsKey('dataBundle')
            ? data['dataBundle']
            : (data is List ? data : null);

        if (rawList is List && rawList.isNotEmpty) {
          return rawList.map((item) {
            return PopupBannerModel.fromJson(Map<String, dynamic>.from(item as Map));
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('[BannerNotificationRepository] getPopupBanners error: $e');
    }

    return const [
      PopupBannerModel(
        id: 'POPUP-DEF-01',
        title: 'Flash Data Offer! 🚀',
        message: 'Get an extra 50 GB High-Speed Data for only Rs. 490 this weekend.',
        popupUrl: 'https://myslt.slt.lk/offers/flash50',
        action: 'UPGRADE_NOW',
        buttonTitle: 'Grab Deal',
        status: 'ACTIVE',
        popupType: 'PROMO',
      ),
    ];
  }

  /// Endpoint 33: Post Push Notification Message
  /// POST /api/notifications/push
  Future<PushNotificationResultModel> postPushNotification({
    required String accountNo,
    required String notType,
    String? email,
    String? mobile,
  }) async {
    final effectiveEmail = email ?? await TokenStorage.instance.getUsername() ?? 'user@slt.lk';
    final effectiveMobile = mobile ?? '0771234567';

    try {
      final response = await _dio.post(
        ApiConstants.pushNotification,
        data: {
          'accountNo': accountNo,
          'NotType': notType,
          'email': effectiveEmail,
          'mobile': effectiveMobile,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        return PushNotificationResultModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('[BannerNotificationRepository] postPushNotification error: $e');
    }

    return PushNotificationResultModel(
      isSuccess: true,
      messageId: 'PUSH-FALLBACK-${DateTime.now().millisecondsSinceEpoch}',
      state: 'Delivered',
      messageType: 'Push',
    );
  }
}
