import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  const SettingsState({
    this.isDarkMode = false,
    this.languageCode = 'en',
    this.pushNotifications = true,
    this.emailAlerts = false,
  });

  final bool isDarkMode;
  final String languageCode;
  final bool pushNotifications;
  final bool emailAlerts;

  String get languageLabel {
    switch (languageCode) {
      case 'si': return 'Sinhala';
      case 'ta': return 'Tamil';
      default: return 'English';
    }
  }

  SettingsState copyWith({
    bool? isDarkMode,
    String? languageCode,
    bool? pushNotifications,
    bool? emailAlerts,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailAlerts: emailAlerts ?? this.emailAlerts,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void setLanguage(String code) {
    state = state.copyWith(languageCode: code);
  }

  void togglePushNotifications() {
    state = state.copyWith(pushNotifications: !state.pushNotifications);
  }

  void toggleEmailAlerts() {
    state = state.copyWith(emailAlerts: !state.emailAlerts);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
