import 'package:flutter_riverpod/flutter_riverpod.dart';

/// MOCK implementation. Replace each method body with a call through your
/// existing Dio client once the OTP / submit endpoints are known.
class ServiceRequestRepository {
  Future<void> sendOtp() async {
    // TODO: call the "send OTP" endpoint.
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  Future<bool> verifyOtp(String code) async {
    // TODO: verify the OTP on the server. For now any 6-digit code passes.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return RegExp(r'^\d{6}$').hasMatch(code);
  }

  /// Returns the reference number of the submitted request.
  Future<String> submit({
    required String requestType,
    required String serviceId,
    required Map<String, String> details,
  }) async {
    // TODO: POST the request (and upload the documents) to the backend.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final n = (DateTime.now().millisecondsSinceEpoch % 900000) + 100000;
    return 'SR-${DateTime.now().year}-$n';
  }
}

final serviceRequestRepositoryProvider =
    Provider<ServiceRequestRepository>((ref) => ServiceRequestRepository());