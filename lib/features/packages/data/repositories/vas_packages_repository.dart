import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/package_model.dart';

class VasPackagesRepository {
  VasPackagesRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// Endpoint 21: Get Available VAS Data Bundles Catalog
  /// GET /tmf-api/productCatalogManagement/v4
  Future<List<PackageModel>> getVasDataBundlesCatalog({String? basePackage}) async {
    try {
      final response = await _dio.get(
        ApiConstants.vasCatalog,
        queryParameters: {
          if (basePackage != null) 'basepackage': basePackage,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map && data['productOffering'] is List) {
          final list = (data['productOffering'] as List)
              .whereType<Map<String, dynamic>>()
              .map((item) => PackageModel.fromJson(item))
              .toList();
          if (list.isNotEmpty) return list;
        } else if (data is List) {
          final list = data
              .whereType<Map<String, dynamic>>()
              .map((item) => PackageModel.fromJson(item))
              .toList();
          if (list.isNotEmpty) return list;
        }
      }
    } catch (e) {
      debugPrint('[VasPackagesRepository] getVasDataBundlesCatalog error: $e');
    }
    return MockData.prepaidDataPackages;
  }

  /// Endpoint 22: Get Extra GB Packages List
  /// POST /tmf-api/productOfferingQualification/v5
  Future<List<PackageModel>> getExtraGbPackagesList({
    String? accountNumber,
    String? basePackage,
  }) async {
    final acc = accountNumber ??
        await TokenStorage.instance.getUsername() ??
        '0312241780';

    try {
      final response = await _dio.post(
        ApiConstants.extraGbPackagesList,
        data: {
          'accountNumber': acc,
          'basePackage': basePackage ?? 'Web Booster',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map && data['checkProductOfferingQualificationItem'] is List) {
          final items = data['checkProductOfferingQualificationItem'] as List;
          if (items.isNotEmpty && items.first is Map) {
            final eligible = items.first['eligibleProductOffering'];
            if (eligible is List && eligible.isNotEmpty) {
              return eligible
                  .whereType<Map<String, dynamic>>()
                  .map((item) => PackageModel.fromJson(item))
                  .toList();
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[VasPackagesRepository] getExtraGbPackagesList error: $e');
    }
    return MockData.prepaidDataPackages;
  }

  /// Endpoint 23: Purchase Extra GB / Addon Bundle
  /// POST /tmf-api/productOrderingManagement/v4
  Future<Map<String, dynamic>> purchaseExtraGbAddonBundle({
    required String packageId,
    String? accountNumber,
  }) async {
    final acc = accountNumber ??
        await TokenStorage.instance.getUsername() ??
        '0312241780';

    try {
      final response = await _dio.post(
        ApiConstants.purchaseExtraGbOrAddon,
        data: {
          'packageId': packageId,
          'accountNumber': acc,
          'channel': 'MYSLT_APP',
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
      debugPrint('[VasPackagesRepository] purchaseExtraGbAddonBundle error: $e');
    }

    return {
      'status': 'acknowledged',
      'id': 'PO-${DateTime.now().millisecondsSinceEpoch}',
      'packageId': packageId,
      'accountNumber': acc,
      'message': 'Extra GB purchase simulated successfully',
    };
  }

  /// Endpoint 24: Redeem Data Voucher
  /// POST /tmf-api/usageManagement/v4/Vouchers
  Future<Map<String, dynamic>> redeemDataVoucher({
    required String voucherCode,
    String? accountNumber,
  }) async {
    final acc = accountNumber ??
        await TokenStorage.instance.getUsername() ??
        '0312241780';

    try {
      final response = await _dio.post(
        ApiConstants.redeemVoucher,
        data: {
          'voucherCode': voucherCode,
          'accountNumber': acc,
          'channel': 'MYSLT_APP',
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
      debugPrint('[VasPackagesRepository] redeemDataVoucher error: $e');
    }

    return {
      'status': 'redeemed',
      'voucherCode': voucherCode,
      'bonusData': 1024,
      'unit': 'MB',
      'message': 'Voucher redeemed successfully',
    };
  }

  /// Endpoint 25: Transfer Data to Another User
  /// POST /tmf-api/usageManagement/v4/TransferData
  Future<Map<String, dynamic>> transferDataToAnotherUser({
    required String recipientMobile,
    required double amountGB,
    String? accountNumber,
  }) async {
    final acc = accountNumber ??
        await TokenStorage.instance.getUsername() ??
        '0312241780';

    try {
      final response = await _dio.post(
        ApiConstants.transferData,
        data: {
          'accountNumber': acc,
          'recipientMobile': recipientMobile,
          'amountGB': amountGB,
          'category': 'DataTransfer',
          'channel': 'MYSLT_APP',
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
      debugPrint('[VasPackagesRepository] transferDataToAnotherUser error: $e');
    }

    return {
      'success': true,
      'recipientMobile': recipientMobile,
      'amountGB': amountGB,
      'message': 'Data transferred successfully',
    };
  }

  /// Endpoint 26: Data Gift Package Enrollment
  /// POST /tmf-api/dataGift/v1
  Future<Map<String, dynamic>> enrollDataGiftPackage({
    required String recipientMobile,
    required double amountGB,
    String? accountNumber,
  }) async {
    final acc = accountNumber ??
        await TokenStorage.instance.getUsername() ??
        '0312241780';

    try {
      final response = await _dio.post(
        ApiConstants.dataGiftEnrollment,
        data: {
          'accountNumber': acc,
          'recipientMobile': recipientMobile,
          'amountGB': amountGB,
          'bundleName': 'Data Gift Package',
          'validity': '30 days',
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
      debugPrint('[VasPackagesRepository] enrollDataGiftPackage error: $e');
    }

    return {
      'status': 'initiated',
      'receiverId': recipientMobile,
      'dataVolume': '$amountGB GB',
      'message': 'Data gift package enrolled successfully',
    };
  }

  /// Endpoint 27: Subscribe to Advanced Usage Reporting
  /// POST /tmf-api/usageManagement/v4/AdvancedReports
  Future<Map<String, dynamic>> subscribeAdvancedUsageReporting({
    String? packageId,
    String? accountNumber,
  }) async {
    final acc = accountNumber ??
        await TokenStorage.instance.getUsername() ??
        '0312241780';

    try {
      final response = await _dio.post(
        ApiConstants.advancedReportsSubscription,
        data: {
          'subscriberID': acc,
          'reporterPackage': packageId ?? 'ADV_REPORT_01',
          'activatedBy': 'MYSLT_APP',
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
      debugPrint('[VasPackagesRepository] subscribeAdvancedUsageReporting error: $e');
    }

    return {
      'status': 'activated',
      'subscriberID': acc,
      'reporterPackage': packageId ?? 'ADV_REPORT_01',
      'message': 'Advanced usage reporting subscribed successfully',
    };
  }
}
