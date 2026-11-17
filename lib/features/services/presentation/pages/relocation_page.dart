import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../connections/data/models/connection_model.dart';
import '../../data/service_request_repository.dart';
import '../widgets/request_widgets.dart';

/// Relocation request: Select Service -> Details & Documents -> Checkout & Auth
class RelocationPage extends ConsumerStatefulWidget {
  const RelocationPage({super.key});

  @override
  ConsumerState<RelocationPage> createState() => _RelocationPageState();
}

class _RelocationPageState extends ConsumerState<RelocationPage> {
  final _formKey = GlobalKey<FormState>();
  final _street = TextEditingController();
  final _city = TextEditingController();
  final _otp = TextEditingController();

  late final List<ConnectionModel> _services =
      List<ConnectionModel>.from(MockData.connections);
  ConnectionModel? _service;
  bool _moveAll = true;
  String? _district;
  DateTime? _date;
  XFile? _proof;

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
    _street.dispose();
    _city.dispose();
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

  void _next() {
    if (_step == 0) {
      if (_service == null) return _snack('Select a service');
      setState(() => _step = 1);
    } else if (_step == 1) {
      setState(() => _showErrors = true);
      final ok = _formKey.currentState?.validate() ?? false;
      if (ok && _district != null && _date != null && _proof != null) {
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
      final reference = await repo.submit(
        requestType: 'relocation',
        serviceId: _service!.id.toString(),
        details: {
          'street': _street.text.trim(),
          'city': _city.text.trim(),
          'district': _district!,
          'preferredDate': DateFormat('yyyy-MM-dd').format(_date!),
          'allServices': '$_moveAll',
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
      title: 'Relocation',
      step: _step,
      onBack: _back,
      onContinue: _next,
      buttonLabel: _step == 2 ? 'Submit request' : 'Continue',
      busy: _busy,
      child: switch (_step) {
        0 => _selectStep(),
        1 => _detailsStep(),
        _ => _checkoutStep(),
      },
    );
  }

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
              title: const Text('Relocate all services on this account'),
              value: _moveAll,
              onChanged: (v) => setState(() => _moveAll = v),
            ),
          ),
        ],
      );

  Widget _detailsStep() {
    final today = DateTime.now();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          RequestCard(
            title: 'New location',
            child: Column(
              children: [
                RequestField(
                  label: 'House no. and street',
                  controller: _street,
                  validator: (v) => requiredText(v, min: 3),
                  showErrors: _showErrors,
                ),
                RequestField(
                  label: 'City / town',
                  controller: _city,
                  validator: requiredText,
                  showErrors: _showErrors,
                ),
                RequestDropdown(
                  label: 'District',
                  value: _district,
                  items: kSriLankaDistricts,
                  onChanged: (v) => setState(() => _district = v),
                  errorText:
                      _showErrors && _district == null ? 'Select a district' : null,
                ),
                RequestDateField(
                  label: 'Preferred relocation date',
                  value: _date,
                  firstDate: today.add(const Duration(days: 1)),
                  lastDate: today.add(const Duration(days: 365)),
                  onPicked: (d) => setState(() => _date = d),
                  errorText:
                      _showErrors && _date == null ? 'Select a date' : null,
                ),
              ],
            ),
          ),
          RequestCard(
            title: 'Documents',
            child: UploadTile(
              label: 'Proof of new address',
              file: _proof,
              errorText:
                  _showErrors && _proof == null ? 'Upload a document' : null,
              onTap: () async {
                final f = await pickRequestImage(context);
                if (f != null) setState(() => _proof = f);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkoutStep() => CheckoutStep(
        rows: [
          MapEntry('Service', _service?.accountNumber ?? '-'),
          const MapEntry('Request', 'Relocation'),
          MapEntry('New address',
              '${_street.text.trim()}, ${_city.text.trim()}, $_district'),
          MapEntry('Preferred date',
              _date == null ? '-' : DateFormat('d MMM yyyy').format(_date!)),
          MapEntry('Scope', _moveAll ? 'All services' : 'This service only'),
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