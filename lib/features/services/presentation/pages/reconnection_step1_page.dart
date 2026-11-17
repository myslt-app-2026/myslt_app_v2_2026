import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../connections/data/models/connection_model.dart';
import '../../data/service_request_repository.dart';
import '../widgets/request_widgets.dart';

/// Reconnection request – 3-step flow:
///   0  Select the service
///   1  Payment & Agreement
///   2  Checkout & Auth (OTP)
///
/// UI mirrors the Relocation / Transfer Ownership pages so every
/// service-request flow looks identical (RequestScaffold + RequestCard +
/// ServiceSelectCard + CheckoutStep).
class ReconnectionStep1Page extends ConsumerStatefulWidget {
  const ReconnectionStep1Page({super.key});

  @override
  ConsumerState<ReconnectionStep1Page> createState() =>
      _ReconnectionStep1PageState();
}

class _ReconnectionStep1PageState
    extends ConsumerState<ReconnectionStep1Page> {
  // ── connection list (from MockData, same source as Relocation) ──────────
  late final List<ConnectionModel> _services =
      List<ConnectionModel>.from(MockData.connections);
  ConnectionModel? _service;

  // ── step 0 ───────────────────────────────────────────────────────────────
  bool _reconnectAll = false;

  // ── step 1 ───────────────────────────────────────────────────────────────
  String _payment = 'online'; // 'online' | 'paid'
  bool _accepted = false;

  // ── step 2 ───────────────────────────────────────────────────────────────
  final _otp = TextEditingController();
  String? _otpError;
  bool _busy = false;

  int _step = 0;

  @override
  void initState() {
    super.initState();
    _service = _services.where((c) => c.isActive).firstOrNull ??
        (_services.isNotEmpty ? _services.first : null);
  }

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  void _back() {
    if (_step == 0) {
      if (GoRouter.maybeOf(context)?.canPop() ?? false) {
        context.pop();
      } else {
        context.go(AppRoutes.services);
      }
    } else {
      setState(() => _step--);
    }
  }

  void _next() {
    if (_step == 0) {
      if (_service == null) return _snack('Please select a service to reconnect.');
      setState(() => _step = 1);
    } else if (_step == 1) {
      if (!_accepted) {
        return _snack('Please accept the Terms and Conditions to continue.');
      }
      ref.read(serviceRequestRepositoryProvider).sendOtp();
      setState(() => _step = 2);
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    final code = _otp.text.trim();
    if (code.length != 6) {
      setState(() => _otpError = 'Enter the 6-digit code sent to your mobile.');
      return;
    }
    setState(() {
      _busy = true;
      _otpError = null;
    });
    final repo = ref.read(serviceRequestRepositoryProvider);
    try {
      if (!await repo.verifyOtp(code)) {
        if (!mounted) return;
        setState(() {
          _busy = false;
          _otpError = 'Incorrect code. Please try again.';
        });
        return;
      }
      final reference = await repo.submit(
        requestType: 'reconnection',
        serviceId: _service!.id.toString(),
        details: {
          'payment': _payment,
          'reconnectAll': '$_reconnectAll',
        },
      );
      if (!mounted) return;
      setState(() => _busy = false);
      await showSubmittedDialog(context, reference);
      if (mounted) context.go(AppRoutes.services);
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      _snack('Something went wrong. Please try again.');
    }
  }

  // ── button label changes per step ───────────────────────────────────────
  String get _buttonLabel {
    if (_step == 2) return 'Submit request';
    return 'Continue';
  }

  @override
  Widget build(BuildContext context) {
    return RequestScaffold(
      title: 'Reconnection',
      step: _step,
      onBack: _back,
      onContinue: _next,
      buttonLabel: _buttonLabel,
      busy: _busy,
      child: switch (_step) {
        0 => _selectStep(),
        1 => _paymentStep(),
        _ => _checkoutStep(),
      },
    );
  }

  // ── Step 0: Select the service ──────────────────────────────────────────
  Widget _selectStep() => Column(
        children: [
          ServiceSelectCard(
            items: _services,
            selectedId: _service?.id.toString(),
            onSelected: (c) => setState(() => _service = c),
          ),
          RequestCard(
            title: 'Scope',
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeTrackColor: kReqBlue,
              title: const Text('Reconnect all services on this account'),
              value: _reconnectAll,
              onChanged: (v) => setState(() => _reconnectAll = v),
            ),
          ),
        ],
      );

  // ── Step 1: Payment method + agreement ─────────────────────────────────
  Widget _paymentStep() => Column(
        children: [
          RequestCard(
            title: 'Pending Balance Settlement',
            child: Column(
              children: [
                _paymentOption(
                  value: 'online',
                  label: 'Pay Online Now',
                  subtitle: 'Recommended — settle your outstanding balance now',
                  icon: Icons.credit_card_rounded,
                ),
                const SizedBox(height: 8),
                _paymentOption(
                  value: 'paid',
                  label: 'I have already paid',
                  subtitle: 'Verification via bank receipt or reference ID',
                  icon: Icons.check_circle_outline_rounded,
                ),
              ],
            ),
          ),
          RequestCard(
            title: 'Customer Agreement',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'I request the reactivation of the selected service and agree '
                  'to the applicable reconnection charges and billing policies.',
                  style: TextStyle(
                    fontSize: 13,
                    color: kReqMuted,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => _accepted = !_accepted),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _accepted,
                        activeColor: kReqBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        onChanged: (v) =>
                            setState(() => _accepted = v ?? false),
                      ),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'I accept the ',
                            style: TextStyle(
                                fontSize: 13, color: kReqLabel),
                            children: [
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: TextStyle(
                                    color: kReqBlue,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _paymentOption({
    required String value,
    required String label,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _payment == value;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _payment = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEEF5FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? kReqBlue : kReqDivider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: kReqBlue, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: kReqBlue)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: kReqMuted)),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: kReqBlue,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ── Step 2: Checkout & Auth ─────────────────────────────────────────────
  Widget _checkoutStep() => CheckoutStep(
        rows: [
          MapEntry('Service', _service?.accountNumber ?? '-'),
          MapEntry('Plan', _service?.planName ?? '-'),
          const MapEntry('Request', 'Reconnection'),
          MapEntry(
            'Payment',
            _payment == 'online' ? 'Pay Online Now' : 'Already Paid',
          ),
          MapEntry(
            'Scope',
            _reconnectAll ? 'All services on account' : 'This service only',
          ),
          const MapEntry('Fee', 'To be confirmed'),
        ],
        otp: _otp,
        otpError: _otpError,
        onResend: () {
          ref.read(serviceRequestRepositoryProvider).sendOtp();
          _snack('A new code has been sent to your registered mobile.');
        },
      );
}

// ── Shared StepProgress widget (kept here for backward-compat references) ──

class StepProgress extends StatelessWidget {
  final int current;
  const StepProgress({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    const titles = [
      'Select Services',
      'Details & Documents',
      'Checkout & Auth',
    ];

    return Row(
      children: List.generate(3, (index) {
        final step = index + 1;
        final completed = step < current;
        final active = step == current;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == 0
                          ? Colors.transparent
                          : (step <= current
                              ? kReqBlue
                              : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: step <= current
                        ? kReqBlue
                        : const Color(0xFFE2E8F0),
                    child: completed
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 16)
                        : Text(
                            '$step',
                            style: TextStyle(
                              color: active ? Colors.white : Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == 2
                          ? Colors.transparent
                          : (step < current
                              ? kReqBlue
                              : const Color(0xFFE2E8F0)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                titles[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      active ? FontWeight.bold : FontWeight.normal,
                  color: active ? kReqBlue : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ── CustomerVerifiedCard (kept for any external imports) ───────────────────

class CustomerVerifiedCard extends StatelessWidget {
  const CustomerVerifiedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        border: Border.all(color: const Color(0xFFBBF7D0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFF16A34A),
            child: Icon(Icons.check, color: Colors.white, size: 14),
          ),
          SizedBox(width: 10),
          Text(
            'Customer Information Verified',
            style: TextStyle(
              color: Color(0xFF15803D),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
