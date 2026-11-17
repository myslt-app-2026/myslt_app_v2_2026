import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../connections/data/models/connection_model.dart';

// ─── Colours taken from the MySLT prototype ────────────────────────────────
const Color kReqBlue = Color(0xFF0055A2); // header, panel, buttons, text
const Color kReqPage = Color(0xFFF0F0F0); // page background
const Color kReqGreen = Color(0xFF42B244); // header stripe
const Color kReqActiveBg = Color(0xFFEAF7E5); // "Active" tag background
const Color kReqActiveFg = Color(0xFF2F7D32); // "Active" tag text
const Color kReqTint = Color(0xFFEEF5FF); // upload box background
const Color kReqLabel = Color(0xFF111827); // field labels
const Color kReqMuted = Color(0xFF6B7280); // hints
const Color kReqError = Color(0xFFB3261E);
const Color kReqDivider = Color(0xFFE5E7EB);

const List<String> kSriLankaDistricts = [
  'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo', 'Galle',
  'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara', 'Kandy', 'Kegalle',
  'Kilinochchi', 'Kurunegala', 'Mannar', 'Matale', 'Matara', 'Monaragala',
  'Mullaitivu', 'Nuwara Eliya', 'Polonnaruwa', 'Puttalam', 'Ratnapura',
  'Trincomalee', 'Vavuniya',
];

String? requiredText(String? v, {int min = 2}) =>
    (v == null || v.trim().length < min) ? 'This field is required' : null;

String? mobileValidator(String? v) {
  final s = (v ?? '').replaceAll(' ', '');
  return RegExp(r'^(?:\+94|0)7\d{8}$').hasMatch(s)
      ? null
      : 'Enter a valid mobile number';
}

// ─── Page frame: header + blue panel (step bar inside) + bottom button ─────

class RequestScaffold extends StatelessWidget {
  const RequestScaffold({
    super.key,
    required this.title,
    required this.step,
    required this.onBack,
    required this.onContinue,
    required this.buttonLabel,
    required this.child,
    this.icon, // not used any more (kept so existing pages still compile)
    this.busy = false,
  });

  final String title;
  final int step; // 0..2
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final String buttonLabel;
  final Widget child;
  final IconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onBack();
      },
      child: Scaffold(
        backgroundColor: kReqPage,
        body: Column(
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kReqBlue,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x2E000000),
                          blurRadius: 12,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(6, 14, 6, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: RequestStepper(step: step),
                      ),
                      const SizedBox(height: 10),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: busy ? null : onContinue,
                style: FilledButton.styleFrom(
                  backgroundColor: kReqBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                child: busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : Text(buttonLabel),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Prototype header: solid blue, ring top right, green stripe, back + title.
  Widget _header(BuildContext context) {
    return ClipRect(
      child: Container(
        width: double.infinity,
        color: kReqBlue,
        padding: EdgeInsets.fromLTRB(
            8, MediaQuery.of(context).padding.top + 6, 8, 18),
        child: Stack(
          children: [
            Positioned(
              right: 20,
              top: -40,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4), width: 12),
                ),
              ),
            ),
            Positioned(
              left: -14,
              top: 22,
              child: Transform.rotate(
                angle: -0.95,
                child: Container(
                  width: 64,
                  height: 10,
                  decoration: BoxDecoration(
                    color: kReqGreen.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    label: const Text('Back',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(right: 8),
                      minimumSize: const Size(48, 40),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Step ${step + 1} of 3',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Step bar like the Reconnection pages: circles joined by lines
/// (done = tick, current = number with a ring, next = grey) and the step
/// name under each circle.
class RequestStepper extends StatelessWidget {
  const RequestStepper({super.key, required this.step});

  final int step; // 0..2

  static const labels = [
    'Select Services',
    'Details & Documents',
    'Checkout & Auth'
  ];
  static const _grey = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (var i = 0; i < labels.length; i++) _cell(i)],
    );
  }

  Widget _cell(int i) {
    final done = i < step;
    final current = i == step;
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 32,
            child: Row(
              children: [
                Expanded(
                  child: i == 0
                      ? const SizedBox()
                      : Container(height: 2, color: i <= step ? kReqBlue : _grey),
                ),
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (done || current) ? kReqBlue : _grey,
                    boxShadow: current
                        ? [
                            BoxShadow(
                                color: kReqBlue.withValues(alpha: 0.25),
                                spreadRadius: 3),
                          ]
                        : null,
                  ),
                  child: done
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: current ? Colors.white : kReqMuted,
                          ),
                        ),
                ),
                Expanded(
                  child: i == labels.length - 1
                      ? const SizedBox()
                      : Container(height: 2, color: i < step ? kReqBlue : _grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              labels[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: current ? FontWeight.w700 : FontWeight.w500,
                color: current
                    ? kReqBlue
                    : (done ? const Color(0xFF475569) : kReqMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: kReqBlue)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// ─── Inputs ────────────────────────────────────────────────────────────────

OutlineInputBorder _border(Color c, [double w = 1.5]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: c, width: w),
    );

InputDecoration requestDecoration(String? hint, {String? error}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: kReqMuted),
      errorText: error,
      isDense: true,
      counterText: '',
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: _border(kReqBlue),
      enabledBorder: _border(kReqBlue),
      focusedBorder: _border(kReqBlue, 2),
      errorBorder: _border(kReqError),
      focusedErrorBorder: _border(kReqError, 2),
    );

Widget _label(String t) => Text(t,
    style: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600, color: kReqLabel));

class RequestField extends StatelessWidget {
  const RequestField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.capitalization = TextCapitalization.none,
    this.maxLength,
    this.showErrors = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextCapitalization capitalization;
  final int? maxLength;
  final bool showErrors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: capitalization,
            maxLength: maxLength,
            onChanged: onChanged,
            validator: validator,
            cursorColor: kReqBlue,
            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
            autovalidateMode: showErrors
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            decoration: requestDecoration(hint),
          ),
        ],
      ),
    );
  }
}

class RequestDateField extends StatelessWidget {
  const RequestDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onPicked,
    required this.firstDate,
    required this.lastDate,
    this.errorText,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPicked;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final v = value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 4),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final init =
                  (v != null && !v.isBefore(firstDate) && !v.isAfter(lastDate))
                      ? v
                      : firstDate;
              final d = await showDatePicker(
                context: context,
                initialDate: init,
                firstDate: firstDate,
                lastDate: lastDate,
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme:
                        Theme.of(ctx).colorScheme.copyWith(primary: kReqBlue),
                  ),
                  child: child!,
                ),
              );
              if (d != null) onPicked(d);
            },
            child: InputDecorator(
              decoration: requestDecoration(null, error: errorText),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      v == null
                          ? 'Select a date'
                          : DateFormat('d MMM yyyy').format(v),
                      style: TextStyle(
                          fontSize: 14,
                          color: v == null ? kReqMuted : const Color(0xFF374151)),
                    ),
                  ),
                  const Icon(Icons.calendar_today_outlined,
                      size: 18, color: kReqBlue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RequestDropdown extends StatelessWidget {
  const RequestDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            iconEnabledColor: kReqBlue,
            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
            decoration: requestDecoration('Select', error: errorText),
            items: [
              for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ─── Documents ─────────────────────────────────────────────────────────────

Future<XFile?> pickRequestImage(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined, color: kReqBlue),
            title: const Text('Take a photo'),
            onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: kReqBlue),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
  if (source == null) return null;
  try {
    return await ImagePicker()
        .pickImage(source: source, maxWidth: 1600, imageQuality: 85);
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the camera/gallery')),
      );
    }
    return null;
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(12)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(
            metric.extractPath(d, math.min(d + 5, metric.length)), paint);
        d += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color;
}

class UploadTile extends StatelessWidget {
  const UploadTile({
    super.key,
    required this.label,
    required this.file,
    required this.onTap,
    this.errorText,
  });

  final String label;
  final XFile? file;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final f = file;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 4),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: CustomPaint(
              foregroundPainter: _DashedBorderPainter(
                  errorText != null ? kReqError : kReqBlue),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: kReqTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      f == null ? Icons.upload_file_outlined : Icons.check_circle,
                      color: f == null ? kReqBlue : kReqActiveFg,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        f == null ? 'Tap to upload or take a photo' : f.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: kReqBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(errorText!,
                  style: const TextStyle(fontSize: 12, color: kReqError)),
            ),
        ],
      ),
    );
  }
}

// ─── Step 1: choose the service ────────────────────────────────────────────

class ServiceSelectCard extends StatelessWidget {
  const ServiceSelectCard({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelected,
  });

  final List<ConnectionModel> items;
  final String? selectedId;
  final ValueChanged<ConnectionModel> onSelected;

  @override
  Widget build(BuildContext context) {
    return RequestCard(
      title: 'Select the service',
      child: Column(
        children: [
          for (final c in items)
            Builder(builder: (context) {
              final selected = c.id.toString() == selectedId;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onSelected(c),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? kReqBlue : kReqDivider,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: kReqBlue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.accountNumber,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: kReqBlue)),
                            Text(c.planName,
                                style: const TextStyle(
                                    fontSize: 13, color: kReqBlue)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

// ─── OTP: six boxes (a hidden text field sits on top and takes the input) ──

class OtpBoxes extends StatefulWidget {
  const OtpBoxes({super.key, required this.controller, this.errorText});

  final TextEditingController controller;
  final String? errorText;

  @override
  State<OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller,
              builder: (context, v, _) => Row(
                children: [
                  for (var i = 0; i < 6; i++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: hasError ? kReqError : kReqBlue,
                              width: (_focus.hasFocus && i == v.text.length)
                                  ? 2.5
                                  : 1.5,
                            ),
                          ),
                          child: Text(
                            i < v.text.length ? v.text[i] : '',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: kReqBlue),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(counterText: ''),
                ),
              ),
            ),
          ],
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(widget.errorText!,
                style: const TextStyle(fontSize: 12, color: kReqError)),
          ),
      ],
    );
  }
}

// ─── Step 3: summary + OTP ─────────────────────────────────────────────────

class CheckoutStep extends StatelessWidget {
  const CheckoutStep({
    super.key,
    required this.rows,
    required this.otp,
    required this.otpError,
    required this.onResend,
  });

  final List<MapEntry<String, String>> rows;
  final TextEditingController otp;
  final String? otpError;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RequestCard(
          title: 'Request summary',
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: i == rows.length - 1
                        ? null
                        : const Border(
                            bottom: BorderSide(color: kReqDivider)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(rows[i].key,
                            style: const TextStyle(
                                fontSize: 13, color: kReqBlue)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(rows[i].value,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: kReqBlue)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        RequestCard(
          title: 'Authorise',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter the 6-digit code sent to your registered mobile number',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kReqLabel),
              ),
              const SizedBox(height: 10),
              OtpBoxes(controller: otp, errorText: otpError),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onResend,
                  style: TextButton.styleFrom(foregroundColor: kReqBlue),
                  child: const Text('Resend code'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> showSubmittedDialog(BuildContext context, String reference) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: const Icon(Icons.check_circle, color: kReqActiveFg, size: 48),
      title: const Text('Request submitted'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Your reference number'),
          const SizedBox(height: 4),
          SelectableText(reference,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: kReqBlue)),
          const SizedBox(height: 8),
          const Text(
            'We will update you by SMS once your request is processed.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(),
          style: FilledButton.styleFrom(backgroundColor: kReqBlue),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}