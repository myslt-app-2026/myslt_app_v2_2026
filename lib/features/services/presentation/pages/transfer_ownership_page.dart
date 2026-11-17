import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/mock/mock_data.dart';
import '../../../connections/data/models/connection_model.dart';
import '../../../new_connection/data/nic_utils.dart';
import '../../data/service_request_repository.dart';
import '../widgets/request_widgets.dart';

/// Transfer ownership request: Select Service -> Details & Documents -> Checkout
class TransferOwnershipPage extends ConsumerStatefulWidget {
  const TransferOwnershipPage({super.key});

  @override
  ConsumerState<TransferOwnershipPage> createState() =>
      _TransferOwnershipPageState();
}

class _TransferOwnershipPageState extends ConsumerState<TransferOwnershipPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _nic = TextEditingController();
  final _mobile = TextEditingController();
  final _otp = TextEditingController();

  late final List<ConnectionModel> _services =
      List<ConnectionModel>.from(MockData.connections);
  ConnectionModel? _service;
  XFile? _nicFront;
  XFile? _nicBack;
  XFile? _consent;

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
    _name.dispose();
    _nic.dispose();
    _mobile.dispose();
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
      if (ok && _nicFront != null && _nicBack != null && _consent != null) {
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
        requestType: 'transfer_ownership',
        serviceId: _service!.id.toString(),
        details: {
          'newOwnerName': _name.text.trim(),
          'newOwnerNic': NicUtils.normalize(_nic.text),
          'newOwnerMobile': _mobile.text.replaceAll(' ', ''),
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
      title: 'Transfer Ownership',
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

  UploadTile _upload(String label, XFile? file, void Function(XFile) set) =>
      UploadTile(
        label: label,
        file: file,
        errorText: _showErrors && file == null ? 'Upload a document' : null,
        onTap: () async {
          final f = await pickRequestImage(context);
          if (f != null) setState(() => set(f));
        },
      );

  Widget _detailsStep() => Form(
        key: _formKey,
        child: Column(
          children: [
            RequestCard(
              title: 'New owner',
              child: Column(
                children: [
                  RequestField(
                    label: 'Full name',
                    controller: _name,
                    hint: 'As on NIC',
                    capitalization: TextCapitalization.words,
                    validator: (v) => requiredText(v, min: 3),
                    showErrors: _showErrors,
                  ),
                  RequestField(
                    label: 'NIC number',
                    controller: _nic,
                    hint: '199754001234 or 975401234V',
                    capitalization: TextCapitalization.characters,
                    validator: (v) => NicUtils.parse(v ?? '') == null
                        ? 'Enter a valid NIC number'
                        : null,
                    showErrors: _showErrors,
                  ),
                  RequestField(
                    label: 'Mobile number',
                    controller: _mobile,
                    hint: '07X XXX XXXX',
                    keyboardType: TextInputType.phone,
                    validator: mobileValidator,
                    showErrors: _showErrors,
                  ),
                ],
              ),
            ),
            RequestCard(
              title: 'Documents',
              child: Column(
                children: [
                  _upload('New owner NIC (front)', _nicFront,
                      (f) => _nicFront = f),
                  _upload('New owner NIC (back)', _nicBack,
                      (f) => _nicBack = f),
                  _upload('Signed consent form', _consent,
                      (f) => _consent = f),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _checkoutStep() => CheckoutStep(
        rows: [
          MapEntry('Service', _service?.accountNumber ?? '-'),
          const MapEntry('Request', 'Transfer ownership'),
          MapEntry('New owner', _name.text.trim()),
          MapEntry('NIC', NicUtils.normalize(_nic.text)),
          MapEntry('Mobile', _mobile.text.trim()),
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