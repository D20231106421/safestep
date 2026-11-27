/// Supabase configuration for SafeStep.
///
/// Provide values either via `--dart-define`:
/// `flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key`
/// or by replacing the default placeholder values below.
class SupabaseOptions {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://emltvgqvlyxgmodvxrkm.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_tyEQdvHWNcB8zzEeZfem0w_t552silg',
  );

  static bool get isConfigured =>
      url.isNotEmpty &&
      anonKey.isNotEmpty &&
      !url.contains('YOUR_SUPABASE_URL') &&
      !anonKey.contains('YOUR_SUPABASE_ANON_KEY');
}
