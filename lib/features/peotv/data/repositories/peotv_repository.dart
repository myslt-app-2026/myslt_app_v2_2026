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
    } catch (e) {
      debugPrint('[PeoTvRepository] getSubscribedPeoTvPackages error: $e');
    }

    return MockData.peoTVPackages;
  }
}
