import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/bill_model.dart';

class BillRepository {
  BillRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// Endpoint 16: Check User E-Bill Status
  /// GET /tmf-api/customerBillManagement/v5
  Future<Map<String, dynamic>> checkEBillStatus({String? accountNo}) async {
    final acc = accountNo ?? await TokenStorage.instance.getUsername() ?? '0312241780';

    try {
      final response = await _dio.get(
        ApiConstants.eBillStatus,
        queryParameters: {'accountNo': acc},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('[BillRepository] checkEBillStatus error: $e');
    }

    return {
      'status': 'ACTIVE',
      'eBillType': 'PDF',
      'accountNumber': acc,
    };
  }

  /// Endpoint 17: Download Monthly PDF Bill
  /// GET /tmf-api/customerBillManagement/v5/BillDownload
  Future<Map<String, dynamic>> downloadBillPdf({String? billId}) async {
    final effectiveBillId = billId ?? 'BILL-2026-07';

    try {
      final response = await _dio.get(
        ApiConstants.billDownload,
        queryParameters: {'billId': effectiveBillId},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('[BillRepository] downloadBillPdf error: $e');
    }

    return {
      'success': true,
      'billId': effectiveBillId,
      'pdfUrl': 'http://localhost:3000/bills/$effectiveBillId.pdf',
      'message': 'Bill PDF generated successfully'
    };
  }

  /// Endpoint 19: Get Payment History & Bill Status
  /// GET /tmf-api/customerBillManagement/v5/BillStatusRequest
  Future<List<BillModel>> getPaymentHistoryAndBillStatus({String? accountNo}) async {
    final acc = accountNo ?? await TokenStorage.instance.getUsername() ?? '0312241780';

    try {
      final response = await _dio.get(
        ApiConstants.billStatusRequest,
        queryParameters: {'accountNo': acc},
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        final rawList = resData is Map && resData.containsKey('data')
            ? resData['data']
            : resData;

        if (rawList is List && rawList.isNotEmpty) {
          return rawList.whereType<Map>().map((item) {
            final map = Map<String, dynamic>.from(item);
            final statusStr = map['status']?.toString().toLowerCase() ?? 'paid';
            BillStatus status = BillStatus.paid;
            if (statusStr.contains('unpaid')) status = BillStatus.unpaid;
            if (statusStr.contains('overdue')) status = BillStatus.overdue;

            return BillModel(
              billId: map['billId']?.toString() ?? 'BILL-${map['period'] ?? '01'}',
              amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : 4850.0,
              dueDate: DateTime.tryParse(map['dueDate']?.toString() ?? '') ?? DateTime(2026, 9, 16),
              issueDate: DateTime.tryParse(map['issueDate']?.toString() ?? '') ?? DateTime(2026, 7, 1),
              period: map['period']?.toString() ?? 'July 2026',
              status: status,
              accountNumber: acc,
              paidDate: map['paidDate'] != null ? DateTime.tryParse(map['paidDate'].toString()) : null,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('[BillRepository] getPaymentHistoryAndBillStatus error: $e');
    }

    return MockData.billHistory;
  }

  /// Fetch current active bill
  Future<BillModel> getCurrentBill({String? accountNo}) async {
    try {
      final history = await getPaymentHistoryAndBillStatus(accountNo: accountNo);
      final unpaid = history.firstWhere(
        (b) => b.status == BillStatus.unpaid || b.status == BillStatus.overdue,
        orElse: () => MockData.currentBill,
      );
      return unpaid;
    } catch (_) {
      return MockData.currentBill;
    }
  }
}
