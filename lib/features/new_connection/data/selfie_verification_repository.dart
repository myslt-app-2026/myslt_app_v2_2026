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
    // Connect your real digital-identity API here.
    //
    // Your project defines:
    // ApiConstants.verifyDigitalIdentity
    //
    // Its request fields and response format must be confirmed first.
    // A successful image upload alone is NOT identity verification.

    throw SelfieVerificationUnavailable();
  }
}

final selfieVerificationRepositoryProvider =
    Provider<SelfieVerificationRepository>((ref) {
  return SelfieVerificationRepository();
});