part of 'app_config_cubit.dart';

class AppConfigState {
  final Locale currentLocale;
  const AppConfigState({
    this.currentLocale = const Locale('en'),
  });

  AppConfigState copyWith({
    Locale? currentLocale,
  }) {
    return AppConfigState(
      currentLocale: currentLocale ?? this.currentLocale,
    );
  }
}
