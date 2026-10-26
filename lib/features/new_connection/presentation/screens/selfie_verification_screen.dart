import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/nic_utils.dart';
import '../../data/selfie_verification_repository.dart';
import '../../providers/applicant_provider.dart';
import '../../providers/selfie_provider.dart';
import '../widgets/order_summary_bar.dart';

const _previewMode = bool.fromEnvironment(
  'CONNECTION_PREVIEW',
  defaultValue: false,
);

class SelfieVerificationScreen extends ConsumerStatefulWidget {
  const SelfieVerificationScreen({super.key});

  @override
  ConsumerState<SelfieVerificationScreen> createState() =>
      _SelfieVerificationScreenState();
}

class _SelfieVerificationScreenState
    extends ConsumerState<SelfieVerificationScreen> {
  final ImagePicker _picker = ImagePicker();

  bool _capturing = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    // Allow retry if the user left during an earlier verification.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (ref.read(selfieProvider).status == SelfieStatus.checking) {
        ref
            .read(selfieProvider.notifier)
            .setStatus(SelfieStatus.captured);
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _takeSelfie() async {
    final mobilePlatform =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    if (kIsWeb || !mobilePlatform) {
      _showMessage(
        'Use the Android or iOS app to take a camera-only selfie.',
      );
      return;
    }

    final applicantBefore = ref.read(applicantProvider);

    setState(() {
      _capturing = true;
      _error = null;
    });

    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
        maxWidth: 1600,
      );

      // Cancelling keeps the previous photo.
      if (photo == null) return;

      final bytes = await photo.readAsBytes();

      if (!mounted) return;

      if (!identical(
        applicantBefore,
        ref.read(applicantProvider),
      )) {
        _showMessage(
          'Your NIC details changed. Please take your selfie again.',
        );
        return;
      }

      if (bytes.isEmpty) {
        throw StateError('Empty photo');
      }

      // Taking a new photo clears the earlier verification result.
      ref.read(selfieProvider.notifier).capture(photo, bytes);
    } on PlatformException catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.code.toLowerCase().contains('access')
            ? 'Camera access is unavailable. Check camera permission '
                'in your phone settings and try again.'
            : 'Could not open the camera. Please try again.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = 'Could not read the selfie. Please take another photo.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _capturing = false;
        });
      }
    }
  }

  Future<void> _verifySelfie() async {
    final selfie = ref.read(selfieProvider);
    final applicant = ref.read(applicantProvider);

    if (selfie.photo == null ||
        applicant.nicFront == null ||
        applicant.nicBack == null) {
      return;
    }

    setState(() {
      _error = null;
    });

    if (_previewMode) {
      // This is only for testing the UI and navigation.
      // It does NOT mark the identity as verified.
      ref
          .read(selfieProvider.notifier)
          .setStatus(SelfieStatus.preview);
      return;
    }

    ref
        .read(selfieProvider.notifier)
        .setStatus(SelfieStatus.checking);

    try {
      final result = await ref
          .read(selfieVerificationRepositoryProvider)
          .verify(
            selfie: selfie.photo!,
            nicFront: applicant.nicFront!,
            nicBack: applicant.nicBack!,
            nicNumber: applicant.nicNumber,
          )
          .timeout(const Duration(seconds: 30));

      if (!mounted) return;

      // Ignore results for an old photo or changed applicant.
      if (!identical(applicant, ref.read(applicantProvider)) ||
          !identical(selfie.photo, ref.read(selfieProvider).photo)) {
        return;
      }

      final accepted = result.verified &&
          (result.verificationId?.trim().isNotEmpty ?? false);

      ref.read(selfieProvider.notifier).setStatus(
            accepted
                ? SelfieStatus.verified
                : SelfieStatus.rejected,
            verificationId:
                accepted ? result.verificationId : null,
          );
    } catch (error) {
      if (!mounted) return;

      if (!identical(applicant, ref.read(applicantProvider)) ||
          !identical(selfie.photo, ref.read(selfieProvider).photo)) {
        return;
      }

      ref
          .read(selfieProvider.notifier)
          .setStatus(SelfieStatus.captured);

      setState(() {
        _error = error is SelfieVerificationUnavailable
            ? 'Selfie verification is not connected yet. '
                'Your photo has not been verified.'
            : 'Verification could not finish. Please try again.';
      });
    }
  }

  Widget _notice(String message, IconData icon) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.onSecondaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colors.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _instruction({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: colors.primary.withOpacity(0.08),
        child: Icon(icon, color: colors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final selfie = ref.watch(selfieProvider);
    final applicant = ref.watch(applicantProvider);

    final nicComplete = applicant.nicFront != null &&
        applicant.nicBack != null &&
        applicant.fullName.trim().length >= 3 &&
        NicUtils.parse(applicant.nicNumber) != null;

    final checking = selfie.status == SelfieStatus.checking;
    final busy = checking || _capturing;

    final canContinue = !busy &&
        nicComplete &&
        ref.watch(selfieMayContinueProvider);

    String? statusMessage;

    if (selfie.status == SelfieStatus.verified) {
      statusMessage =
          'Identity verified. You can continue to availability.';
    } else if (selfie.status == SelfieStatus.preview) {
      statusMessage =
          'Preview ready. Face matching was NOT performed.';
    } else if (selfie.status == SelfieStatus.rejected) {
      statusMessage =
          'We could not verify this selfie. Check your NIC photos '
          'and take another selfie.';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New connection'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Step 3 of 7',
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(
            value: 3 / 7,
            minHeight: 4,
          ),
          const SizedBox(height: 20),
          Text(
            'Verify your selfie',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take a clear selfie to compare with the photo on your NIC.',
          ),
          const SizedBox(height: 16),

          if (_previewMode) ...[
            _notice(
              'UI preview only. No face matching or liveness '
              'check will be performed.',
              Icons.info_outline,
            ),
            const SizedBox(height: 16),
          ],

          if (!nicComplete) ...[
            _notice(
              'Go back and complete your NIC photos and details first.',
              Icons.badge_outlined,
            ),
            const SizedBox(height: 16),
          ],

          Center(
            child: Container(
              width: 240,
              height: 290,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(120),
                border: Border.all(
                  color: colors.primary,
                  width: 2,
                ),
              ),
              child: selfie.bytes == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.face_outlined,
                          size: 100,
                          color: colors.primary,
                        ),
                        const SizedBox(height: 12),
                        const Text('Your selfie appears here'),
                      ],
                    )
                  : Image.memory(
                      selfie.bytes!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Center(
                          child: Text('Please retake this photo.'),
                        );
                      },
                    ),
            ),
          ),

          const SizedBox(height: 20),

          _instruction(
            icon: Icons.light_mode_outlined,
            title: 'Face a light source',
            subtitle: 'Avoid shadows and bright light behind you.',
          ),
          _instruction(
            icon: Icons.face_outlined,
            title: 'Keep your face clearly visible',
            subtitle: 'Remove sunglasses and look at the camera.',
          ),
          _instruction(
            icon: Icons.phone_android_outlined,
            title: 'Hold your phone steady',
            subtitle: 'Keep your full face inside the photo.',
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: nicComplete && !busy ? _takeSelfie : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(
              _capturing
                  ? 'Opening camera…'
                  : selfie.photo == null
                      ? 'Take selfie'
                      : 'Retake selfie',
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: nicComplete && selfie.photo != null && !busy
                ? _verifySelfie
                : null,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            icon: checking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.verified_user_outlined),
            label: Text(
              checking
                  ? 'Verifying…'
                  : _previewMode
                      ? 'Use photo for UI preview'
                      : 'Verify selfie',
            ),
          ),

          if (statusMessage != null) ...[
            const SizedBox(height: 16),
            _notice(
              statusMessage,
              selfie.status == SelfieStatus.verified
                  ? Icons.check_circle_outline
                  : Icons.info_outline,
            ),
          ],

          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _error!,
                style: TextStyle(color: colors.error),
              ),
            ),

          const SizedBox(height: 20),
          const Text(
            'Taking a photo alone does not verify your identity.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: OrderSummaryBar(
        onContinue: () {
          if (!canContinue) {
            _showMessage(
              _previewMode
                  ? 'Take a selfie and select '
                      '“Use photo for UI preview” first.'
                  : 'Verify your selfie before continuing.',
            );
            return;
          }

          context.push('/new-connection/availability');
        },
      ),
    );
  }
}