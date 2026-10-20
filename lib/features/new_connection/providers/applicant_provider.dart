import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Applicant details collected in the new-connection flow.
class ApplicantState {
  const ApplicantState({
    this.nicFront,
    this.nicBack,
    this.fullName = '',
    this.nicNumber = '',
    this.email = '',
  });

  final XFile? nicFront;
  final XFile? nicBack;
  final String fullName;
  final String nicNumber;
  final String email;

  ApplicantState copyWith({
    XFile? nicFront,
    XFile? nicBack,
    String? fullName,
    String? nicNumber,
    String? email,
  }) =>
      ApplicantState(
        nicFront: nicFront ?? this.nicFront,
        nicBack: nicBack ?? this.nicBack,
        fullName: fullName ?? this.fullName,
        nicNumber: nicNumber ?? this.nicNumber,
        email: email ?? this.email,
      );
}

class ApplicantNotifier extends Notifier<ApplicantState> {
  @override
  ApplicantState build() => const ApplicantState();

  void setNicImage({required bool front, required XFile file}) {
    state = front ? state.copyWith(nicFront: file) : state.copyWith(nicBack: file);
  }

  void setDetails({String? fullName, String? nicNumber, String? email}) {
    state = state.copyWith(
      fullName: fullName,
      nicNumber: nicNumber,
      email: email,
    );
  }

  void reset() => state = const ApplicantState();
}

final applicantProvider =
    NotifierProvider<ApplicantNotifier, ApplicantState>(ApplicantNotifier.new);