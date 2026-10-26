import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'applicant_provider.dart';

enum SelfieStatus {
  empty,
  captured,
  checking,
  verified,
  rejected,
  preview,
}

class SelfieState {
  const SelfieState({
    this.photo,
    this.bytes,
    this.status = SelfieStatus.empty,
    this.verificationId,
  });

  final XFile? photo;
  final Uint8List? bytes;
  final SelfieStatus status;
  final String? verificationId;
}

class SelfieNotifier extends Notifier<SelfieState> {
  @override
  SelfieState build() {
    // Changing NIC images or applicant details clears verification.
    ref.watch(applicantProvider);
    return const SelfieState();
  }

  void capture(XFile photo, Uint8List bytes) {
    state = SelfieState(
      photo: photo,
      bytes: bytes,
      status: SelfieStatus.captured,
    );
  }

  void setStatus(
    SelfieStatus status, {
    String? verificationId,
  }) {
    if (state.photo == null) return;

    if (status == SelfieStatus.verified &&
        (verificationId == null || verificationId.trim().isEmpty)) {
      throw ArgumentError('A server verification reference is required.');
    }

    state = SelfieState(
      photo: state.photo,
      bytes: state.bytes,
      status: status,
      verificationId: verificationId,
    );
  }

  void reset() {
    state = const SelfieState();
  }
}

final selfieProvider =
    NotifierProvider<SelfieNotifier, SelfieState>(
  SelfieNotifier.new,
);

final selfieMayContinueProvider = Provider<bool>((ref) {
  final selfie = ref.watch(selfieProvider);

  const previewMode = bool.fromEnvironment(
    'CONNECTION_PREVIEW',
    defaultValue: false,
  );

  return selfie.status == SelfieStatus.verified ||
      (previewMode && selfie.status == SelfieStatus.preview);
});
