/// Casing helpers shared across the app.
extension StringCasing on String {
  /// 'red' -> 'Red'. Empty strings stay empty.
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
