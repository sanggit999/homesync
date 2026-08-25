/// Cấu hình toàn cục môi trường cho HomeSync
class AppConfig {
  AppConfig._();

  /// URL Dự án Supabase (Được ghi đè qua --dart-define hoặc biến môi trường)
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://hbxpqqzhsfazggadkzrl.supabase.co',
  );

  /// Anon Key Supabase
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_6HF2v2T6sZteK0IKV2_4Uw_QMCJ0XHQ',
  );

  /// OneSignal App ID
  static const String oneSignalAppId = String.fromEnvironment(
    'ONESIGNAL_APP_ID',
    defaultValue: 'your-onesignal-app-id',
  );

  /// Tên ứng dụng
  static const String appName = 'HomeSync';

  /// Storage Bucket name cho hóa đơn & chứng từ
  static const String receiptsBucket = 'receipts';
}
