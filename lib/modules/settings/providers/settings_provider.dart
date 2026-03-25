import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool notificationsEnabled;
  final List<int> notificationDaysBefore;
  final String language; // 'en' | 'ru'

  const SettingsState({
    this.notificationsEnabled = true,
    this.notificationDaysBefore = const [3],
    this.language = 'en',
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    List<int>? notificationDaysBefore,
    String? language,
  }) =>
      SettingsState(
        notificationsEnabled:
        notificationsEnabled ?? this.notificationsEnabled,
        notificationDaysBefore:
        notificationDaysBefore ?? this.notificationDaysBefore,
        language: language ?? this.language,
      );
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void toggleDay(int day) {
    final current = List<int>.from(state.notificationDaysBefore);
    if (current.contains(day)) {
      if (current.length == 1) return; // минимум 1 день должен быть выбран
      current.remove(day);
    } else {
      current.add(day);
      current.sort();
    }
    state = state.copyWith(notificationDaysBefore: current);
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
  }
}

final settingsProvider =
NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);