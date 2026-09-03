/// Định nghĩa tập trung toàn bộ đường dẫn (Route Paths & Route Names) của HomeSync
class AppRoutes {
  AppRoutes._();

  // Splash & Onboarding
  static const String splash = '/';
  static const String welcome = '/welcome';

  // 4 Main Shell Tabs
  static const String home = '/home';
  static const String items = '/items';
  static const String maintenance = '/maintenance';
  static const String profile = '/profile';

  // Sub-routes for Items Feature
  static const String itemsAdd = '/items/add';
  static const String itemsEdit = '/items/edit/:id';
  static const String itemDetail = '/items/detail/:id';
  static const String receiptViewer = '/items/receipt-viewer';

  // Helper sinh đường dẫn động kèm ID
  static String itemDetailPath(String id) => '/items/detail/$id';
  static String itemEditPath(String id) => '/items/edit/$id';

  // Sub-routes for Maintenance & Service Logs Feature
  static const String maintenanceAdd = '/maintenance/add';
  static const String maintenanceAddLog = '/maintenance/add-log';
  static const String maintenanceDetail = '/maintenance/detail/:id';
  static const String maintenanceEdit = '/maintenance/edit/:id';

  static String maintenanceDetailPath(String id) => '/maintenance/detail/$id';
  static String maintenanceEditPath(String id) => '/maintenance/edit/$id';

  // Sub-routes for Dashboard & Export Feature
  static const String pdfPreview = '/pdf-preview';

  // Sub-routes for Profile & Family Feature
  static const String familyMembers = '/profile/family';
  static const String qrShare = '/profile/qr-share';
}
