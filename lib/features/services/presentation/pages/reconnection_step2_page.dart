import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'reconnection_step1_page.dart';
import 'reconnection_step3_page.dart';

class ReconnectionStep2Page extends StatefulWidget {
  final List<String> selectedServices;
  final double pendingBalance;

  const ReconnectionStep2Page({
    super.key,
    required this.selectedServices,
    this.pendingBalance = 0.0,
  });

  @override
  State<ReconnectionStep2Page> createState() =>
      _ReconnectionStep2PageState();
}

class _ReconnectionStep2PageState
    extends State<ReconnectionStep2Page> {
  String payment = 'online';
  bool accepted = false;
  final List<Offset?> signaturePoints = [];
  Uint8List? uploadedSignatureBytes;
  String? uploadedFileName;

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
      final validExtensions = ['.png', '.jpg', '.jpeg', '.webp'];
      final isValidExt = validExtensions.any((ext) => name.endsWith(ext));

      if (!isValidExt) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid file format. Please upload a PNG, JPG, or WEBP image.'),
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
            content: Text('File is too large. Maximum allowed size is 5 MB.'),
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

  void nextStep() {
    final hasSignature = signaturePoints.isNotEmpty || uploadedSignatureBytes != null;
    if (!accepted || !hasSignature) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Accept the agreement and provide a signature.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReconnectionStep3Page(
          selectedServices: widget.selectedServices,
          paymentMethod: payment,
          pendingBalance: widget.pendingBalance,
          signatureBytes: uploadedSignatureBytes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      appBar: AppBar(
        title: const Text('Details & Documents'),
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
                  const StepProgress(current: 2),
                  const SizedBox(height: 22),
                  const CustomerVerifiedCard(),
                  const SizedBox(height: 22),
                  const Text(
                    'Pending Balance Settlement',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: sltBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text(
                            'Pay Online Now (Recommended)',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: widget.pendingBalance > 0
                              ? Text('Rs. ${widget.pendingBalance.toStringAsFixed(2)}')
                              : const Text('Rs. 0.00'),
                          value: 'online',
                          activeColor: sltBlue,
                          groupValue: payment,
                          onChanged: (value) =>
                              setState(() => payment = value!),
                        ),
                        const Divider(height: 1),
                        RadioListTile<String>(
                          title: const Text(
                            'I have already paid',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: const Text('Verification via bank receipt or reference ID'),
                          value: 'paid',
                          activeColor: sltBlue,
                          groupValue: payment,
                          onChanged: (value) =>
                              setState(() => payment = value!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Customer Agreement',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: sltBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text(
                            'I request the reactivation of the '
                            'selected services and agree to the '
                            'applicable reconnection charges and billing policies.',
                            style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF334155)),
                          ),
                          const SizedBox(height: 6),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: accepted,
                            activeColor: sltBlue,
                            title: const Text(
                              'I accept the Terms and Conditions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (value) => setState(
                              () => accepted = value ?? false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Digital Signature *',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: sltBlue,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _pickSignatureImage,
                        icon: const Icon(Icons.upload_file_rounded, size: 18),
                        label: const Text('Upload Image'),
                        style: TextButton.styleFrom(
                          foregroundColor: sltBlue,
                          textStyle: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue.shade200,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: uploadedSignatureBytes != null
                          ? Stack(
                              children: [
                                Center(
                                  child: Image.memory(
                                    uploadedSignatureBytes!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade600,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Uploaded',
                                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : GestureDetector(
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
                                child: Center(
                                  child: signaturePoints.isEmpty
                                      ? const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.draw_outlined, color: Colors.blueGrey, size: 36),
                                            SizedBox(height: 6),
                                            Text(
                                              'Draw your signature here or upload an image',
                                              style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _clearSignature,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Clear Signature'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                      ),
                    ),
                  ),
                  const Text(
                    'Demo signature pad. The signature is validated locally and not uploaded or saved to a server.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
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
                      onPressed: nextStep,
                      child: const Text(
                        'Next Step',
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

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];

      if (start != null && end != null) {
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) {
    return true;
  }
}

