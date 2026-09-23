import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myslt_app_2026/core/network/api_constants.dart';
import 'package:myslt_app_2026/features/home/data/repositories/banner_notification_repository.dart';

class MockBannerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Endpoint 31: Promotional Banners
    if (options.path == ApiConstants.promotionalBanners && options.method == 'GET') {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            '@type': 'CommunicationMessage',
            'communications': [
              {
                'id': 'COMM-101',
                'subject': 'Double Data Weekend Promo',
                'description': 'Enjoy 100% extra broadband data every weekend!',
                'messageType': 'Banner',
                'attachment': [
                  {'url': 'https://example.com/banner.png'}
                ],
              },
            ],
          },
        ),
      );
      return;
    }

    // Endpoint 32: Popup Banners
    if (options.path == ApiConstants.popupBanners && options.method == 'GET') {
      final subscriberID = options.queryParameters['subscriberID'];
      if (subscriberID == 'TEST_SUB') {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'isSuccess': true,
              'dataBundle': [
                {
                  'notid': 'POPUP-99',
                  'title': 'Fiber 100Mbps Speed Upgrade',
                  'message': 'Upgrade to Ultra Fiber today for free router install.',
                  'popup_URL': 'https://example.com/promo',
                  'action': 'UPGRADE_NOW',
                  'button_TITLE': 'Upgrade Now',
                  'status': 'ACTIVE',
                  'popup_TYPE': 'PROMO',
                },
              ],
            },
          ),
        );
        return;
      }
    }

    // Endpoint 33: Push Notifications
    if (options.path == ApiConstants.pushNotification && options.method == 'POST') {
      final body = options.data as Map<String, dynamic>;
      if (body['accountNo'] != null && body['NotType'] != null) {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'isSuccess': true,
              'errorMessege': null,
              'dataBundle': {
                'messageId': 'PUSH-MSG-8842',
                'state': 'Completed',
                'messageType': 'Push',
              },
            },
          ),
        );
        return;
      }
    }

    super.onRequest(options, handler);
  }
}

void main() {
  group('Banners & Notifications APIs (Endpoints 31, 32, 33) Tests', () {
    late Dio dio;
    late BannerNotificationRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
      dio.interceptors.add(MockBannerInterceptor());
      repository = BannerNotificationRepository(dio: dio);
    });

    test('Endpoint 31: successfully fetches promotional banners', () async {
      final banners = await repository.getPromotionalBanners(username: 'test@slt.lk');

      expect(banners.isNotEmpty, isTrue);
      expect(banners.first.id, 'COMM-101');
      expect(banners.first.title, 'Double Data Weekend Promo');
      expect(banners.first.imageUrl, 'https://example.com/banner.png');
    });

    test('Endpoint 32: successfully fetches home screen popup banners', () async {
      final popups = await repository.getPopupBanners(subscriberId: 'TEST_SUB');

      expect(popups.isNotEmpty, isTrue);
      expect(popups.first.id, 'POPUP-99');
      expect(popups.first.title, 'Fiber 100Mbps Speed Upgrade');
      expect(popups.first.isActive, isTrue);
      expect(popups.first.buttonTitle, 'Upgrade Now');
    });

    test('Endpoint 33: successfully posts push notification message', () async {
      final result = await repository.postPushNotification(
        accountNo: '0312241780',
        notType: 'BILL_ALERT',
        email: 'user@slt.lk',
        mobile: '0771234567',
      );

      expect(result.isSuccess, isTrue);
      expect(result.messageId, 'PUSH-MSG-8842');
      expect(result.state, 'Completed');
      expect(result.messageType, 'Push');
    });
  });
}
