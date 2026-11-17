import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/bill/data/models/bill_model.dart';
import '../../../../features/bill/providers/bill_provider.dart';
import '../../../../features/home/providers/home_provider.dart';
import '../../../../features/profile/providers/profile_provider.dart';
import 'reconnection_step2_page.dart';
import 'reconnection_step3_page.dart';

const sltBlue = Color(0xFF0062C6);
const sltNavy = Color(0xFF0753AD);

class ReconnectionStep1Page extends ConsumerStatefulWidget {
  const ReconnectionStep1Page({super.key});

  @override
  ConsumerState<ReconnectionStep1Page> createState() =>
      _ReconnectionStep1PageState();
}

class _ReconnectionStep1PageState extends ConsumerState<ReconnectionStep1Page> {
  int _currentStep = 1;

  // Step 1 state
  final selectedServices = <String>{'SLT Broadband Internet (ADSL/Wi-Max)'};

  final services = const [
    (
      'Voice (Telephone)',
      'Reactivate your landline service',
      Icons.call_outlined,
    ),
    (
      'PeoTV',
      'Reactivate your TV service',
      Icons.tv_outlined,
    ),
    (
      'SLT Broadband Internet (ADSL/Wi-Max)',
      'Reactivate your internet service',
      Icons.wifi_rounded,
    ),
  ];

  // Step 2 state
  String paymentMethod = 'online';
  bool acceptedAgreement = false;
  String signatureMethod = 'draw'; // 'draw' or 'upload'
  final List<Offset?> signaturePoints = [];
  Uint8List? uploadedSignatureBytes;
  String? uploadedFileName;

  // Step 3 state
  bool confirmedDeclaration = true;

  Future<void> _pickSignatureImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final name = pickedFile.name.toLowerCase();
      final validExtensions = ['.png', '.jpg', '.jpeg', '.webp', '.pdf'];
      final isValidExt = validExtensions.any((ext) => name.endsWith(ext));

      if (!isValidExt) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Accepted file types: JPG, PNG, PDF (Max 5 MB)'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final bytes = await pickedFile.readAsBytes();
      if (bytes.lengthInBytes > 5 * 1024 * 1024) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File size exceeds 5 MB limit.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        uploadedSignatureBytes = bytes;
        uploadedFileName = pickedFile.name;
        signaturePoints.clear();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signature uploaded: ${pickedFile.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick signature image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearSignature() {
    setState(() {
      signaturePoints.clear();
      uploadedSignatureBytes = null;
      uploadedFileName = null;
    });
  }

  void _handleBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      if (GoRouter.maybeOf(context)?.canPop() ?? false) {
        context.pop();
      } else if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        context.go(AppRoutes.services);
      }
    }
  }

  void _goToStep2() {
    if (selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one service to reactivate.')),
      );
      return;
    }
    setState(() => _currentStep = 2);
  }

  void _goToStep3() {
    final hasSignature = signaturePoints.isNotEmpty || uploadedSignatureBytes != null;
    if (!acceptedAgreement || !hasSignature) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the agreement and provide your signature.'),
        ),
      );
      return;
    }
    setState(() => _currentStep = 3);
  }

  void _submitReconnection() {
    if (!confirmedDeclaration) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please confirm the declaration to proceed.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Request Submitted', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your reconnection request has been successfully submitted.',
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
                    'Services: ${selectedServices.join(', ')}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Payment: ${paymentMethod == 'online' ? 'Pay Online Now' : 'I have already paid'}',
                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Reference ID: REC-2026-90418',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: sltNavy),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: sltNavy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.services);
            },
            child: const Text('Back to Services'),
          ),
        ],
      ),
    );
  }

  String get _subtitleForStep {
    switch (_currentStep) {
      case 1:
        return 'Reactivate your disconnected SLT services';
      case 2:
        return 'Details & Documents';
      case 3:
      default:
        return 'Checkout & Auth';
    }
  }

  @override
  Widget build(BuildContext context) {
    final billAsync = ref.watch(billProvider);
    final pendingBalance = (billAsync.valueOrNull?.status == BillStatus.unpaid ||
            billAsync.valueOrNull?.status == BillStatus.overdue)
        ? (billAsync.valueOrNull?.amount ?? 0.0)
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          // ── Curved Blue Header ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [sltNavy, sltBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: _handleBack,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reconnection',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _subtitleForStep,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.sync_rounded, color: Colors.white, size: 22),
                        onPressed: () {
                          ref.invalidate(profileProvider);
                          ref.invalidate(homeProvider);
                          ref.invalidate(billProvider);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Scrollable Body per Step ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                StepProgress(current: _currentStep),
                const SizedBox(height: 20),

                if (_currentStep == 1) ...[
                  _buildStep1Content(pendingBalance),
                ] else if (_currentStep == 2) ...[
                  _buildStep2Content(pendingBalance),
                ] else ...[
                  _buildStep3Content(pendingBalance),
                ],
              ],
            ),
          ),

          // ── Fixed Bottom Actions Bar ──
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStep1Content(double pendingBalance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomerVerifiedCard(),
        const SizedBox(height: 24),
        const Text(
          'Select Services to Reactivate',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        ...services.map((service) {
          final isSelected = selectedServices.contains(service.$1);
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedServices.remove(service.$1);
                } else {
                  selectedServices.add(service.$1);
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? sltNavy : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.8 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(service.$3, color: sltNavy, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.$1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          service.$2,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? sltNavy : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? sltNavy : const Color(0xFF94A3B8),
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep2Content(double pendingBalance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomerVerifiedCard(),
        const SizedBox(height: 20),

        // ── Pending Balance Settlement Card ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.credit_card_outlined, color: sltNavy, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Pending Balance Settlement',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Option 1: Pay Online Now
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => paymentMethod = 'online'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: paymentMethod == 'online' ? const Color(0xFFF0F7FF) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: paymentMethod == 'online' ? sltNavy : const Color(0xFFE2E8F0),
                      width: paymentMethod == 'online' ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card_rounded, color: sltNavy, size: 22),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Pay Online Now\n(Recommended)',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.3),
                        ),
                      ),
                      Icon(
                        paymentMethod == 'online' ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: paymentMethod == 'online' ? sltNavy : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Option 2: I have already paid
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => paymentMethod = 'paid'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: paymentMethod == 'paid' ? const Color(0xFFF0F7FF) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: paymentMethod == 'paid' ? sltNavy : const Color(0xFFE2E8F0),
                      width: paymentMethod == 'paid' ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: sltNavy, size: 22),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'I have already paid',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                      Icon(
                        paymentMethod == 'paid' ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: paymentMethod == 'paid' ? sltNavy : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // ── Customer Agreement Card ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.description_outlined, color: sltNavy, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Customer Agreement',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'I request the reactivation of the selected services and agree to the applicable reconnection charges.',
                style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => setState(() => acceptedAgreement = !acceptedAgreement),
                child: Row(
                  children: [
                    Checkbox(
                      value: acceptedAgreement,
                      activeColor: sltNavy,
                      onChanged: (v) => setState(() => acceptedAgreement = v ?? false),
                    ),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I accept the ',
                          style: TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                          children: [
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(color: sltNavy, fontWeight: FontWeight.bold),
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

        const SizedBox(height: 18),

        // ── Signature Method Card ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.edit_outlined, color: sltNavy, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Signature Method',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => signatureMethod = 'draw'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: signatureMethod == 'draw' ? const Color(0xFFF0F7FF) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: signatureMethod == 'draw' ? sltNavy : const Color(0xFFCBD5E1),
                            width: signatureMethod == 'draw' ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              signatureMethod == 'draw' ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: signatureMethod == 'draw' ? sltNavy : const Color(0xFF94A3B8),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Draw Signature',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => signatureMethod = 'upload'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: signatureMethod == 'upload' ? const Color(0xFFF0F7FF) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: signatureMethod == 'upload' ? sltNavy : const Color(0xFFCBD5E1),
                            width: signatureMethod == 'upload' ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              signatureMethod == 'upload' ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: signatureMethod == 'upload' ? sltNavy : const Color(0xFF94A3B8),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Upload Signature',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // ── Digital Signature Canvas / Upload Box ──
        const Text(
          'Digital Signature *',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 8),
        Container(
          height: 190,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF93C5FD), style: BorderStyle.solid),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: signatureMethod == 'draw'
                ? Stack(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (details) => setState(() {
                          signaturePoints.add(details.localPosition);
                        }),
                        onPanUpdate: (details) => setState(() {
                          signaturePoints.add(details.localPosition);
                        }),
                        onPanEnd: (_) => setState(() {
                          signaturePoints.add(null);
                        }),
                        child: CustomPaint(
                          painter: SignaturePainter(signaturePoints),
                          size: Size.infinite,
                          child: Center(
                            child: signaturePoints.isEmpty
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit_note_rounded, color: Colors.blueGrey),
                                      SizedBox(width: 8),
                                      Text(
                                        'Draw your signature here',
                                        style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: OutlinedButton.icon(
                          onPressed: _clearSignature,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: sltNavy,
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          icon: const Icon(Icons.delete_outline_rounded, size: 16),
                          label: const Text('Clear', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: uploadedSignatureBytes != null
                        ? Stack(
                            children: [
                              Center(child: Image.memory(uploadedSignatureBytes!, fit: BoxFit.contain)),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: TextButton.icon(
                                  onPressed: _clearSignature,
                                  icon: const Icon(Icons.close_rounded, size: 16),
                                  label: const Text('Remove'),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload_outlined, color: sltNavy, size: 40),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: sltNavy,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: _pickSignatureImage,
                                child: const Text('Choose File'),
                              ),
                            ],
                          ),
                  ),
          ),
        ),

        const SizedBox(height: 12),

        // Info box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: sltNavy, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Accepted file types (for Upload Signature): JPG, PNG, PDF (Max 5 MB)',
                  style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Content(double pendingBalance) {
    return Column(
      children: [
        // ── Mobile Verified Hero Badge ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, color: Color(0xFF0284C7), size: 42),
                  ),
                  const Positioned(
                    top: 0,
                    right: 4,
                    child: Icon(Icons.auto_awesome, color: Color(0xFF38BDF8), size: 18),
                  ),
                  const Positioned(
                    bottom: 2,
                    left: 2,
                    child: Icon(Icons.auto_awesome, color: Color(0xFF38BDF8), size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Mobile Verified!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your request is ready to be submitted.',
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ── Payment Summary Card ──
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.credit_card_rounded, color: sltNavy, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Payment Summary',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.layers_outlined, color: sltNavy, size: 20),
                  const SizedBox(width: 8),
                  const Text('Pending Dues Balance', style: TextStyle(fontSize: 14, color: Color(0xFF334155))),
                  const Spacer(),
                  Text(
                    'Rs. ${pendingBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF16A34A),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.payment_rounded, color: sltNavy, size: 20),
                  const SizedBox(width: 8),
                  const Text('Payment Method', style: TextStyle(fontSize: 14, color: Color(0xFF334155))),
                  const Spacer(),
                  Text(
                    pendingBalance == 0.0
                        ? 'No Payment Required'
                        : (paymentMethod == 'online' ? 'Pay Online Now' : 'Already Paid'),
                    style: const TextStyle(
                      color: sltNavy,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Declaration Card ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: sltNavy, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Declaration',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => setState(() => confirmedDeclaration = !confirmedDeclaration),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: confirmedDeclaration,
                      activeColor: sltNavy,
                      onChanged: (v) => setState(() => confirmedDeclaration = v ?? false),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'I confirm that the above information is correct and request to reactivate the selected service(s).',
                          style: TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
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
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: _currentStep == 1
            ? SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sltNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: selectedServices.isEmpty ? null : _goToStep2,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Next: Details & Documents', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: sltNavy,
                          side: const BorderSide(color: sltNavy),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _handleBack,
                        child: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sltNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _currentStep == 2 ? _goToStep3 : _submitReconnection,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentStep == 2 ? 'Next Step' : 'Continue',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

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
                          : (step <= current ? sltNavy : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: step <= current ? sltNavy : const Color(0xFFE2E8F0),
                    child: completed
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
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
                          : (step < current ? sltNavy : const Color(0xFFE2E8F0)),
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
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  color: active ? sltNavy : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class CustomerVerifiedCard extends ConsumerWidget {
  const CustomerVerifiedCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final homeAsync = ref.watch(homeProvider);

    final customerName = profileAsync.valueOrNull?.name.isNotEmpty == true
        ? profileAsync.valueOrNull!.name
        : 'Kasun Samantha Perera';

    const registeredAddress = 'No. 45, Galle Road,\nKollupitiya, Colombo 03';

    final telephoneNumber = profileAsync.valueOrNull?.mobile.isNotEmpty == true
        ? profileAsync.valueOrNull!.mobile
        : '0112345678';

    final currentPackage = homeAsync.valueOrNull?.planName.isNotEmpty == true
        ? homeAsync.valueOrNull!.planName
        : '300 Mbps Fibre Broadband';

    final isActive = homeAsync.valueOrNull?.isActive ?? true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        border: Border.all(color: const Color(0xFFBBF7D0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Customer Information Verified',
                  style: TextStyle(
                    color: Color(0xFF15803D),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildInfoRow(Icons.person_outline_rounded, 'Customer Name', customerName),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.location_on_outlined, 'Registered Address', registeredAddress),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.phone_outlined, 'Telephone Number', telephoneNumber),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.layers_outlined, 'Current Package', currentPackage),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.show_chart_rounded, color: Colors.blueGrey, size: 18),
              const SizedBox(width: 10),
              const SizedBox(
                width: 120,
                child: Text('Status', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: isActive ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueGrey, size: 18),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }
}
