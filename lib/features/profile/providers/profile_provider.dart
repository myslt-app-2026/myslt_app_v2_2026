import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/domain/entities/user_entity.dart';
import '../../../core/mock/mock_data.dart';

// ─── Profile Notifier ─────────────────────────────────────────────────────────

class ProfileNotifier extends AsyncNotifier<UserEntity> {
  @override
  Future<UserEntity> build() => _fetchProfile();

  Future<UserEntity> _fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.currentUser;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProfile);
  }

  Future<bool> updateContact({
    required String mobile,
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(mobile: mobile, email: email));
    }
    return true;
  }
}

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserEntity>(ProfileNotifier.new);
