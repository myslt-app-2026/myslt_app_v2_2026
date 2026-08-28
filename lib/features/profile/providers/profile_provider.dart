import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/providers/auth_state_provider.dart';
import '../../../features/auth/domain/entities/user_entity.dart';

// ─── Profile Notifier ─────────────────────────────────────────────────────────

class ProfileNotifier extends AsyncNotifier<UserEntity> {
  @override
  Future<UserEntity> build() => _fetchProfile();

  Future<UserEntity> _fetchProfile() async {
    final repo = ref.read(authRepositoryProvider);
    return repo.getUserInfo();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProfile);
  }

  Future<bool> updateContact({
    required String mobile,
    required String email,
  }) async {
    final current = state.valueOrNull ?? MockData.currentUser;
    state = AsyncData(current.copyWith(mobile: mobile, email: email));
    return true;
  }
}

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserEntity>(ProfileNotifier.new);

