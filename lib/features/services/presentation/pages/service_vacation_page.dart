import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../connections/data/models/connection_model.dart';
import '../../data/service_request_repository.dart';
import '../widgets/request_widgets.dart';

/// Service vacation request: Select Service -> Details -> Checkout & Auth
class ServiceVacationPage extends ConsumerStatefulWidget {
  const ServiceVacationPage({super.key});

  @override
  ConsumerState<ServiceVacationPage> createState() =>
      _ServiceVacationPageState();
}

class _ServiceVacationPageState extends ConsumerState<ServiceVacationPage> {
  static const _reasons = [
    'Travelling abroad',
    'Temporary relocation',
    'Financial reasons',
    'Other',
  ];

  final _otp = TextEditingController();
  late final List<ConnectionModel> _services =
      List<ConnectionModel>.from(MockData.connections);
  ConnectionModel? _service;
  DateTime? _start;
  DateTime? _end;
  String? _reason;
  XFile? _document; // optional

  int _step = 0;
  bool _showErrors = false;
  bool _busy = false;
  String? _otpError;

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

  void _back() {
    if (_step == 0) {
      context.pop();
    } else {
      setState(() => _step--);
    }
  }

  void _snack(String text) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(text)));

  String? get _endError {
    if (!_showErrors) return null;
    if (_end == null) return 'Select a date';
    if (_start != null && _end!.isBefore(_start!)) {
      return 'End date must be after the start date';
    }
    return null;
  }

  void _next() {
    if (_step == 0) {
      if (_service == null) return _snack('Select a service');
      setState(() => _step = 1);
    } else if (_step == 1) {
      setState(() => _showErrors = true);
      final ok = _start != null &&
          _end != null &&
          !_end!.isBefore(_start!) &&
          _reason != null;
      if (ok) {
        ref.read(serviceRequestRepositoryProvider).sendOtp();
        setState(() {
          _step = 2;
          _showErrors = false;
        });
      }
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    final code = _otp.text.trim();
    if (code.length != 6) {
      setState(() => _otpError = 'Enter the 6-digit code');
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
          _otpError = 'Invalid code. Please try again.';
        });
        return;
      }
      final fmt = DateFormat('yyyy-MM-dd');
      final reference = await repo.submit(
        requestType: 'service_vacation',
        serviceId: _service!.id.toString(),
        details: {
          'startDate': fmt.format(_start!),
          'endDate': fmt.format(_end!),
          'reason': _reason!,
        },
      );
      if (!mounted) return;
      setState(() => _busy = false);
      await showSubmittedDialog(context, reference);
      if (mounted) context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      _snack('Something went wrong. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RequestScaffold(
      title: 'Service Vacation',
      step: _step,
      onBack: _back,
      onContinue: _next,
      buttonLabel: _step == 2 ? 'Submit request' : 'Continue',
      busy: _busy,
      child: switch (_step) {
        0 => ServiceSelectCard(
            items: _services,
            selectedId: _service?.id.toString(),
            onSelected: (c) => setState(() => _service = c),
          ),
        1 => _detailsStep(),
        _ => _checkoutStep(),
      },
    );
  }

  Widget _detailsStep() {
    final today = DateTime.now();
    final last = today.add(const Duration(days: 730));
    return Column(
      children: [
        RequestCard(
          title: 'Vacation period',
          child: Column(
            children: [
              RequestDateField(
                label: 'Start date',
                value: _start,
                firstDate: today,
                lastDate: last,
                onPicked: (d) => setState(() => _start = d),
                errorText:
                    _showErrors && _start == null ? 'Select a date' : null,
              ),
              RequestDateField(
                label: 'End date',
                value: _end,
                firstDate: _start ?? today,
                lastDate: last,
                onPicked: (d) => setState(() => _end = d),
                errorText: _endError,
              ),
              RequestDropdown(
                label: 'Reason',
                value: _reason,
                items: _reasons,
                onChanged: (v) => setState(() => _reason = v),
                errorText:
                    _showErrors && _reason == null ? 'Select a reason' : null,
              ),
            ],
          ),
        ),
        RequestCard(
          title: 'Documents',
          child: UploadTile(
            label: 'Supporting document (optional)',
            file: _document,
            onTap: () async {
              final f = await pickRequestImage(context);
              if (f != null) setState(() => _document = f);
            },
          ),
        ),
      ],
    );
  }

  Widget _checkoutStep() {
    final fmt = DateFormat('d MMM yyyy');
    return CheckoutStep(
      rows: [
        MapEntry('Service', _service?.accountNumber ?? '-'),
        const MapEntry('Request', 'Service vacation'),
        MapEntry('Period',
            '${_start == null ? '-' : fmt.format(_start!)} to ${_end == null ? '-' : fmt.format(_end!)}'),
        MapEntry('Reason', _reason ?? '-'),
        const MapEntry('Fee', 'To be confirmed'),
      ],
      otp: _otp,
      otpError: _otpError,
      onResend: () {
        ref.read(serviceRequestRepositoryProvider).sendOtp();
        _snack('A new code has been sent');
      },
    );
  }
}