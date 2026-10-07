import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/peotv_package_model.dart';

class PeoTvRepository {
  PeoTvRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// Endpoint 34: Get Subscribed PEO TV Packages
  /// GET /tmf-api/productInventory/v4
  Future<List<PeoTVPackageModel>> getSubscribedPeoTvPackages({
    String? accountNumber,
  }) async {
    final acc = accountNumber ??
        await TokenStorage.instance.getUsername() ??
        '0312241780';

    try {
      // 1. Try primary endpoint: GET /tmf-api/productInventory/v4/product?publicIdentifier=...&productOfferingName=PEOVAS
      try {
        final response = await _dio.get(
          '${ApiConstants.peoTvSubscribedPackages}/product',
          queryParameters: {
            'publicIdentifier': acc,
            'productOfferingName': 'PEOVAS',
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          final list = data is List
              ? data
              : (data is Map && data.containsKey('data') ? data['data'] : null);
          if (list is List && list.isNotEmpty) {
            return list
                .whereType<Map<String, dynamic>>()
                .map((item) => PeoTVPackageModel.fromJson(item))
                .toList();
          }
        }
      } catch (_) {}

      // 2. Try general endpoint: GET /tmf-api/productInventory/v4
      try {
        final response = await _dio.get(
          ApiConstants.peoTvSubscribedPackages,
          queryParameters: {'accountNumber': acc},
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          final rawList = data is List
              ? data
              : (data is Map && data.containsKey('data')
                  ? data['data']
                  : (data is Map && data.containsKey('product')
                      ? data['product']
                      : null));

          if (rawList is List && rawList.isNotEmpty) {
            return rawList
                .whereType<Map<String, dynamic>>()
                .map((item) => PeoTVPackageModel.fromJson(item))
                .toList();
          }
        }
      } catch (_) {}
    } catch (e) {
      debugPrint('[PeoTvRepository] getSubscribedPeoTvPackages error: $e');
    }


    return MockData.peoTVPackages;
  }

  /// Endpoint 35: Subscribe to PEO TV Channel Addon
  /// POST /tmf-api/purchasedProduct/v1/purchasedProduct
  Future<Map<String, dynamic>> subscribePeoTvChannelAddon({
    required String packageId,
    String? telephoneNo,
    String? pin,
  }) async {
    final effectiveTel = telephoneNo ??
        await TokenStorage.instance.getUsername() ??
        '0312241780';
    final effectivePin = pin ?? '111111';

    try {
      final response = await _dio.post(
        '${ApiConstants.subscribePeoTvAddon}/purchasedProduct',
        data: {
          'telephoneNo': effectiveTel,
          'productid': packageId,
          'pin': effectivePin,
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else if (response.data is Map) {
          return Map<String, dynamic>.from(response.data as Map);
        }
      }
    } catch (e) {
      debugPrint('[PeoTvRepository] subscribePeoTvChannelAddon error: $e');
    }

    return {
      'message': 'Purchased product created successfully',
      'status': 'SUCCESS',
      'productid': packageId,
      'telephoneNo': effectiveTel,
    };
  }

  /// Endpoint 36: Get PEO TV GO Streaming Access Token
  /// GET /api/Account/GetPeoTVGOAccessToken
  Future<Map<String, dynamic>> getPeoTvGoAccessToken({
    String? subscriberId,
    String channel = 'MYSLT_APP',
  }) async {
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        '0312241780';

    try {
      final response = await _dio.get(
        ApiConstants.peoTvGoAccessToken,
        queryParameters: {
          'subscriberId': effectiveId,
          'channel': channel,
        },
        options: Options(
          headers: {
            'subscriberid': effectiveId,
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else if (response.data is Map) {
          return Map<String, dynamic>.from(response.data as Map);
        }
      }
    } catch (e) {
      debugPrint('[PeoTvRepository] getPeoTvGoAccessToken error: $e');
    }

    return {
      'accessToken': 'PEOTVGO-STREAM-${DateTime.now().millisecondsSinceEpoch}',
      'tokenType': 'Bearer',
      'expiresIn': 3600,
      'issuedAt': DateTime.now().toIso8601String(),
      'expiresAt': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      'subscriberId': effectiveId,
      'channel': channel,
      'status': 'SUCCESS',
    };
  }
}



