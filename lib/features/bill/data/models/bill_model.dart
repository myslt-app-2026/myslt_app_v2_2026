import 'package:flutter/material.dart';

enum BillStatus { paid, unpaid, overdue }

extension BillStatusExtension on BillStatus {
  String get label {
    switch (this) {
      case BillStatus.paid:
        return 'Paid';
      case BillStatus.unpaid:
        return 'Unpaid';
      case BillStatus.overdue:
        return 'Overdue';
    }
  }

  Color get color {
    switch (this) {
      case BillStatus.paid:
        return const Color(0xFF22C55E);
      case BillStatus.unpaid:
        return const Color(0xFFF59E0B);
      case BillStatus.overdue:
        return const Color(0xFFEF4444);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case BillStatus.paid:
        return const Color(0xFFDCFCE7);
      case BillStatus.unpaid:
        return const Color(0xFFFEF3C7);
      case BillStatus.overdue:
        return const Color(0xFFFEE2E2);
    }
  }
}

class BillModel {
  const BillModel({
    required this.billId,
    required this.amount,
    required this.dueDate,
    required this.issueDate,
    required this.period,
    required this.status,
    required this.accountNumber,
    this.paidDate,
  });

  final String billId;
  final double amount;
  final DateTime dueDate;
  final DateTime issueDate;
  final String period;
  final BillStatus status;
  final String accountNumber;
  final DateTime? paidDate;

  bool get isOverdue =>
      status == BillStatus.unpaid && dueDate.isBefore(DateTime.now());
}
