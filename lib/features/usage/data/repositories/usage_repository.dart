import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../home/data/models/account_summary_model.dart';
import '../models/broadband_usage_model.dart';
import '../models/usage_model.dart';

class UsageRepository {
  UsageRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// Endpoint 9: Fetch live account usage summary (Used, Total, Bonus, Minutes, Expiry)
  /// GET /api/ISP_SOA/dashboard/summary?subscriberID=...
  Future<AccountSummaryModel> getAccountSummary({String? subscriberId}) async {
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        '0112345678';

    try {
      final response = await _dio.get(
        ApiConstants.dashboardSummary,
        queryParameters: {'subscriberID': effectiveId},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final payload = data['data'] ?? data;

        if (payload is Map<String, dynamic>) {
          return _mapJsonToSummary(payload, effectiveId);
        } else if (payload is List && payload.isNotEmpty) {
          final first = payload.first;
          if (first is Map<String, dynamic>) {
            return _mapJsonToSummary(first, effectiveId);
          }
        }
      }
    } catch (e) {
      debugPrint('[UsageRepository] getAccountSummary error: $e');
      // Secondary fallback attempt via daily usage endpoint
      try {
        final fallbackRes = await _dio.get(
          '${ApiConstants.dailyUsage}/$effectiveId',
        );
        if (fallbackRes.statusCode == 200 && fallbackRes.data != null) {
          final data = fallbackRes.data;
          final volume = (data['volume'] is num)
              ? (data['volume'] as num).toDouble()
              : 62000.0;
          return AccountSummaryModel(
            accountNumber: effectiveId,
            planName: 'SLT Fiber Max 100',
            totalDataMB: 100000,
            usedDataMB: volume,
            bonusDataMB: 5000,
            nightDataMB: 40000,
            nightDataUsedMB: 25000,
            freeMinutes: 100,
            usedMinutes: 25,
            expiryDate: DateTime.now().add(const Duration(days: 17)),
            accountType: 'Postpaid Fiber',
            isActive: true,
          );
        }
      } catch (_) {}
    }

    // Graceful fallback with realistic defaults
    return MockData.accountSummary;
  }

  /// Endpoint 10: Fetch current broadband data usage
  /// GET /tmf-api/usageManagement/v4/usage
  Future<BroadbandUsageModel> getCurrentBroadbandUsage({String? subscriberId}) async {
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        '0112345678';

    try {
      // 1. Try GET /tmf-api/usageManagement/v4/usage/:id
      try {
        final response = await _dio.get('${ApiConstants.currentUsage}/$effectiveId');
        if (response.statusCode == 200 && response.data != null) {
          final json = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : Map<String, dynamic>.from(response.data as Map);
          return BroadbandUsageModel.fromJson(json);
        }
      } catch (_) {}

      // 2. Try GET /tmf-api/usageManagement/v4/usage?subscriberID=...
      final response = await _dio.get(
        ApiConstants.currentUsage,
        queryParameters: {'subscriberID': effectiveId},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return BroadbandUsageModel.fromJson(data);
        } else if (data is List && data.isNotEmpty) {
          return BroadbandUsageModel.fromJson(Map<String, dynamic>.from(data.first as Map));
        }
      }
    } catch (e) {
      debugPrint('[UsageRepository] getCurrentBroadbandUsage error: $e');
    }

    // Default fallback usage model
    return BroadbandUsageModel(
      id: 'USG-DEFAULT',
      subscriberId: effectiveId,
      volume: 47104.0,
      unit: 'MB',
      category: 'Broadband',
      status: 'active',
      usageDate: DateTime.now(),
      maxAmount: 102400.0,
      remainingAmount: 55296.0,
    );
  }

  /// Fetch broadband data usage for the current month via
  /// GET /api/ISP_SOA/CurrentMonthDailyUsage?billDate=YYYY-MM-DD
  ///
  /// Endpoint 11: Get Current Month Daily Usage Breakdown
  /// GET /tmf-api/usageManagement/v4/daily
  Future<List<HourlyUsageModel>> getDailyHourlyUsage({
    String? subscriberId,
    DateTime? date,
  }) async {
    final targetDate = date ?? DateTime.now();
    final billDate =
        '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        '0112345678';

    try {
      final response = await _dio.get(
        ApiConstants.dailyUsage,
        queryParameters: {'billDate': billDate, 'subscriberID': effectiveId},
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        final rawList = resData is Map && resData.containsKey('data')
            ? resData['data']
            : resData;

        if (rawList is List && rawList.isNotEmpty) {
          final sorted = List<Map<String, dynamic>>.from(
            rawList.whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
          )..sort((a, b) {
              final ta = DateTime.tryParse(a['createdAt']?.toString() ?? '') ??
                  DateTime(0);
              final tb = DateTime.tryParse(b['createdAt']?.toString() ?? '') ??
                  DateTime(0);
              return ta.compareTo(tb);
            });

          return sorted.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;

            final vol = (item['volume'] is num)
                ? (item['volume'] as num).toDouble()
                : 0.0;

            final createdAt =
                DateTime.tryParse(item['createdAt']?.toString() ?? '');
            final hour = createdAt?.hour ?? (idx % 24);

            return HourlyUsageModel(
              hour: hour,
              usedMB: vol,
              downloadMB: vol * 0.8,
              uploadMB: vol * 0.2,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('[UsageRepository] getDailyHourlyUsage error: $e');
    }

    return MockData.todayHourlyUsage;
  }

  /// Endpoint 12: Get Previous Month Daily Usage Details
  /// GET /tmf-api/usageManagement/v4/PreviousMonth
  Future<List<DailyUsageModel>> getMonthlyUsage({String? subscriberId}) async {
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        '0112345678';

    try {
      final response = await _dio.get(
        ApiConstants.previousMonthUsage,
        queryParameters: {'subscriberID': effectiveId},
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        final rawList = resData is Map && resData.containsKey('data')
            ? resData['data']
            : resData;

        if (rawList is List && rawList.isNotEmpty) {
          return rawList.whereType<Map>().map((item) {
            final map = Map<String, dynamic>.from(item);
            final vol = (map['volume'] is num)
                ? (map['volume'] as num).toDouble()
                : 2500.0;
            final dateStr = map['usageDate'] ?? map['createdAt'];
            final parsedDate = dateStr != null
                ? DateTime.tryParse(dateStr.toString()) ?? DateTime.now()
                : DateTime.now();
            return DailyUsageModel(
              date: parsedDate,
              usedMB: vol,
              streamingMB: vol * 0.4,
              browsingMB: vol * 0.3,
              socialMB: vol * 0.15,
              gamingMB: vol * 0.1,
              otherMB: vol * 0.05,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('[UsageRepository] getMonthlyUsage error: $e');
    }

    return MockData.monthlyUsage;
  }

  /// Endpoint 13: Get Free Data Bonus Balance
  /// GET /api/ISP_SOA/dashboard/free_data
  Future<Map<String, dynamic>> getFreeDataBonus({String? subscriberId}) async {
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        '0112345678';

    try {
      final response = await _dio.get(
        ApiConstants.freeData,
        queryParameters: {'subscriberID': effectiveId},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('[UsageRepository] getFreeDataBonus error: $e');
    }

    return {'success': true, 'freeDataMB': 5120, 'status': 'ACTIVE'};
  }

  /// Endpoint 14: Get Extra Bonus Data Allocation
  /// GET /api/ISP_SOA/dashboard/bonus_data
  Future<Map<String, dynamic>> getExtraBonusData({String? subscriberId}) async {
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        '0112345678';

    try {
      final response = await _dio.get(
        ApiConstants.bonusData,
        queryParameters: {'subscriberID': effectiveId},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('[UsageRepository] getExtraBonusData error: $e');
    }

    return {'success': true, 'bonusDataMB': 10240, 'status': 'ACTIVE'};
  }

  /// Endpoint 15: Get Active Internet Package Details
  /// GET /api/ISP_SOA/dashboard/mypackage
  Future<Map<String, dynamic>> getActiveInternetPackage({String? subscriberId}) async {
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        '0112345678';

    try {
      final response = await _dio.get(
        ApiConstants.myPackage,
        queryParameters: {'subscriberID': effectiveId},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('[UsageRepository] getActiveInternetPackage error: $e');
    }

    return {
      'success': true,
      'packageName': 'SLT Fiber Max 100',
      'speed': '100 Mbps',
      'status': 'ACTIVE'
    };
  }

  AccountSummaryModel _mapJsonToSummary(
    Map<String, dynamic> json,
    String defaultAccNum,
  ) {
    final accNum = json['accountNumber']?.toString() ??
        json['subscriberID']?.toString() ??
        defaultAccNum;
    final plan = json['planName']?.toString() ??
        json['name']?.toString() ??
        'SLT Fiber Max 100';
    final total = (json['totalDataMB'] as num?)?.toDouble() ??
        (json['total'] as num?)?.toDouble() ??
        102400.0;
    final used = (json['usedDataMB'] as num?)?.toDouble() ??
        (json['volume'] as num?)?.toDouble() ??
        (json['used'] as num?)?.toDouble() ??
        63488.0;
    final bonus = (json['bonusDataMB'] as num?)?.toDouble() ??
        (json['freeData'] as num?)?.toDouble() ??
        5120.0;
    final nightTotal = (json['nightDataMB'] as num?)?.toDouble() ?? 40960.0;
    final nightUsed = (json['nightDataUsedMB'] as num?)?.toDouble() ?? 10240.0;
    final freeMin = (json['freeMinutes'] as num?)?.toInt() ?? 75;
    final usedMin = (json['usedMinutes'] as num?)?.toInt() ?? 0;

    DateTime expiry = DateTime.now().add(const Duration(days: 17));
    if (json['expiryDate'] != null) {
      final parsed = DateTime.tryParse(json['expiryDate'].toString());
      if (parsed != null) expiry = parsed;
    }

    return AccountSummaryModel(
      accountNumber: accNum,
      planName: plan,
      totalDataMB: total,
      usedDataMB: used,
      bonusDataMB: bonus,
      nightDataMB: nightTotal,
      nightDataUsedMB: nightUsed,
      freeMinutes: freeMin,
      usedMinutes: usedMin,
      expiryDate: expiry,
      accountType: json['accountType']?.toString() ?? 'Postpaid Fiber',
      isActive: json['status']?.toString().toLowerCase() != 'inactive',
    );
  }
}
