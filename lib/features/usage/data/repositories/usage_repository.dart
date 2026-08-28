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
  /// The endpoint returns daily usage records for the billing month.
  /// We map each day record to an HourlyUsageModel so the bar chart
  /// renders one bar per record (hour slot = day index % 24).
  Future<List<HourlyUsageModel>> getDailyHourlyUsage({
    String? subscriberId,
    DateTime? date,
  }) async {
    final targetDate = date ?? DateTime.now();
    final billDate =
        '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';

    try {
      final response = await _dio.get(
        ApiConstants.currentMonthDailyUsage,
        queryParameters: {'billDate': billDate},
      );

      if (response.statusCode == 200 && response.data != null) {
        final body = response.data as Map<String, dynamic>;
        final list = body['data'];

        if (list is List && list.isNotEmpty) {
          // Sort by createdAt ascending so chart shows chronological order
          final sorted = List<Map<String, dynamic>>.from(
            list.map((e) => e as Map<String, dynamic>),
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

            // volume field is in MB
            final vol = (item['volume'] is num)
                ? (item['volume'] as num).toDouble()
                : 0.0;

            // Use createdAt hour if available, else spread evenly
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
      debugPrint('[UsageRepository] getCurrentMonthDailyUsage error: $e');
    }

    // Fallback to mock data if API unavailable
    return MockData.todayHourlyUsage;
  }


  /// Fetch monthly usage breakdown
  Future<List<DailyUsageModel>> getMonthlyUsage({String? subscriberId}) async {
    final effectiveId = subscriberId ??
        await TokenStorage.instance.getUsername() ??
        'customer-123';

    try {
      final response = await _dio.get(
        ApiConstants.previousMonthUsage,
        queryParameters: {'id': effectiveId},
      );

      if (response.statusCode == 200 && response.data != null) {
        final list = response.data;
        if (list is List && list.isNotEmpty) {
          return list.map((item) {
            final vol = (item['volume'] is num)
                ? (item['volume'] as num).toDouble()
                : 2500.0;
            final dateStr = item['usageDate'] ?? item['createdAt'];
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
    } catch (_) {}

    return MockData.monthlyUsage;
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
