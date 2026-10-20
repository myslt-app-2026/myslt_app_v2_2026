import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../data/nic_utils.dart';
import '../../providers/applicant_provider.dart';
import '../widgets/order_summary_bar.dart';

/// Step 2 of the new-connection flow: NIC photos + applicant details.
class NicUploadScreen extends ConsumerStatefulWidget {
  const NicUploadScreen({super.key});

  @override
  ConsumerState<NicUploadScreen> createState() => _NicUploadScreenState();
}

class _NicUploadScreenState extends ConsumerState<NicUploadScreen> {
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _nic;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    final saved = ref.read(applicantProvider);
    _name = TextEditingController(text: saved.fullName);
    _nic = TextEditingController(text: saved.nicNumber);
    _email = TextEditingController(text: saved.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _nic.dispose();
    _email.dispose();
    super.dispose();
  }

  void _syncDetails() {
    ref.read(applicantProvider.notifier).setDetails(
          fullName: _name.text,
          nicNumber: _nic.text,
          email: _email.text,
        );
  }

  Future<void> _chooseSource({required bool front}) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return;
      ref.read(applicantProvider.notifier).setNicImage(front: front, file: file);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the camera/gallery')),
      );
    }
  }

  bool _emailOk(String email) =>
      email.trim().isEmpty || _emailRegex.hasMatch(email.trim());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final applicant = ref.watch(applicantProvider);
    final nicInfo = NicUtils.parse(applicant.nicNumber);

    return Scaffold(
      appBar: AppBar(title: const Text('New connection')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Step 2 of 7',
                style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text('Verify your identity',
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              'Upload both sides of your NIC and confirm your details.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _NicImageTile(
                    label: 'Front side',
                    file: applicant.nicFront,
                    onTap: () => _chooseSource(front: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NicImageTile(
                    label: 'Back side',
                    file: applicant.nicBack,
                    onTap: () => _chooseSource(front: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Place the NIC on a flat surface, avoid glare and make sure all text is clear.',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Full name (as on NIC)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _syncDetails(),
              validator: (v) => (v == null || v.trim().length < 3)
                  ? 'Enter your full name'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nic,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'NIC number',
                hintText: '199754001234 or 975401234V',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _syncDetails(),
              validator: (v) => NicUtils.parse(v ?? '') == null
                  ? 'Enter a valid NIC number'
                  : null,
            ),
            if (nicInfo != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.cake_outlined, size: 16),
                    label: Text(
                        DateFormat('d MMMM yyyy').format(nicInfo.dateOfBirth)),
                    visualDensity: VisualDensity.compact,
                  ),
                  Chip(
                    avatar: Icon(
                      nicInfo.gender == NicGender.female
                          ? Icons.female
                          : Icons.male,
                      size: 16,
                    ),
                    label: Text(nicInfo.gender == NicGender.female
                        ? 'Female'
                        : 'Male'),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('Read from your NIC number',
                    style:
                        tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Email (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _syncDetails(),
              validator: (v) =>
                  _emailOk(v ?? '') ? null : 'Enter a valid email address',
            ),
          ],
        ),
      ),
      bottomNavigationBar: OrderSummaryBar(
        onContinue: () {
          final a = ref.read(applicantProvider);
          final complete = a.nicFront != null &&
              a.nicBack != null &&
              a.fullName.trim().length >= 3 &&
              NicUtils.parse(a.nicNumber) != null &&
              _emailOk(a.email);

          if (!complete) {
            _formKey.currentState?.validate();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Upload both sides of your NIC and fill in the details'),
              ),
            );
            return;
          }

          // TODO: go to the selfie step once it exists, e.g.
          // context.push(AppRoutes.newConnectionSelfie);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Next step: selfie check (coming soon)')),
          );
        },
      ),
    );
  }
}

class _NicImageTile extends StatelessWidget {
  const _NicImageTile({
    required this.label,
    required this.file,
    required this.onTap,
  });

  final String label;
  final XFile? file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AspectRatio(
      aspectRatio: 1.4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: file == null ? cs.outlineVariant : cs.primary,
              width: file == null ? 1 : 2,
            ),
            color: cs.surface,
          ),
          clipBehavior: Clip.antiAlias,
          child: file == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, color: cs.primary),
                    const SizedBox(height: 8),
                    Text(label,
                        style: tt.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text('Tap to upload',
                        style: tt.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant)),
                  ],
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    // On web the picked file is a blob URL, on mobile a file path.
                    kIsWeb
                        ? Image.network(file!.path, fit: BoxFit.cover)
                        : Image.file(File(file!.path), fit: BoxFit.cover),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Chip(
                        label: Text('$label · Change'),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: cs.surface,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}