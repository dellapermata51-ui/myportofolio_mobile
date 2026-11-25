/// Base URL of the Django REST Framework backend.
///
/// Defaults to `http://10.0.2.2:8000` (IP address of your local development
/// machine that can be reached from the Android emulator).
/// Override with `--dart-define=API_BASE_URL=http://localhost:8000` if you are
/// testing on Chrome (Flutter Web) or a physical device using `adb reverse`.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
