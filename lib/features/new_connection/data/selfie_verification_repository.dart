import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SelfieVerificationResult {
  const SelfieVerificationResult({
    required this.verified,
    this.verificationId,
  });

  final bool verified;
  final String? verificationId;
}

class SelfieVerificationUnavailable implements Exception {}

class SelfieVerificationRepository {
  Future<SelfieVerificationResult> verify({
    required XFile selfie,
    required XFile nicFront,
    required XFile nicBack,
    required String nicNumber,
  }) async {
    // Simulate verification check
    await Future.delayed(const Duration(milliseconds: 1000));
    return const SelfieVerificationResult(
      verified: true,
      verificationId: 'SLT-VERIF-SUCCESS-2026',
    );
  }
}

final selfieVerificationRepositoryProvider =
    Provider<SelfieVerificationRepository>((ref) {
  return SelfieVerificationRepository();
});
