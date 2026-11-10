import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import 'reconnection_step1_page.dart';

class ReconnectionStep3Page extends StatefulWidget {
  final List<String> selectedServices;
  final String paymentMethod;
  final double pendingBalance;
  final Uint8List? signatureBytes;

  const ReconnectionStep3Page({
    super.key,
    required this.selectedServices,
    required this.paymentMethod,
    this.pendingBalance = 0.0,
    this.signatureBytes,
  });

  @override
  State<ReconnectionStep3Page> createState() =>
      _ReconnectionStep3PageState();
}

class _ReconnectionStep3PageState
    extends State<ReconnectionStep3Page> {
  bool confirmed = false;

  void continueRequest() {
    if (!confirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm the declaration.'),
        ),
      );
      return;
    }

    // Demo only. Replace with backend OTP verification,
    // payment validation and request submission when APIs are integrated.
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Request Received', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your reconnection request for the selected services has been registered successfully.',
              style: TextStyle(fontSize: 14, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services: ${widget.selectedServices.join(', ')}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Payment: ${widget.paymentMethod == 'online' ? 'Pay Online' : 'Already Paid'}',
                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Reference: REC-2026-09418',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: sltBlue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Note: This is demo confirmation mode. Live backend order submission applies in production.',
              style: TextStyle(fontSize: 11, color: Colors.blueGrey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: sltBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.services);
            },
            child: const Text('Return to Services'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      appBar: AppBar(
        title: const Text('Checkout & Auth'),
        backgroundColor: sltBlue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const StepProgress(current: 3),
                  const SizedBox(height: 32),

                  // Demo state: not real OTP verification.
                  const Center(
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: Color(0xFFE1F5EC),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Verification Preview',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF087C51),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Mobile verification must be completed '
                      'before submitting your request.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                color: sltBlue,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Digital Receipt',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          const Text(
                            'Selected Services',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...widget.selectedServices.map(
                            (service) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(service, style: const TextStyle(fontSize: 14))),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 28),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Pending Dues Balance', style: TextStyle(fontSize: 14)),
                              Text(
                                'Rs. ${widget.pendingBalance.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Selected Payment Option', style: TextStyle(fontSize: 14)),
                              Flexible(
                                child: Text(
                                  widget.paymentMethod == 'online'
                                      ? 'Pay Online'
                                      : 'Already Paid',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    color: sltBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Demo balance and receipt only',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: CheckboxListTile(
                      value: confirmed,
                      activeColor: sltBlue,
                      title: const Text('Declaration', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text(
                        'I confirm that the information is '
                        'correct and request reactivation '
                        'of the selected services.',
                      ),
                      onChanged: (value) => setState(
                        () => confirmed = value ?? false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: sltBlue,
                      side: const BorderSide(color: sltBlue),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sltBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: continueRequest,
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

