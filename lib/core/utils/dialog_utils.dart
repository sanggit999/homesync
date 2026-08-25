import 'package:flutter/material.dart';

/// Hiển thị Dialog từ Root Navigator để chắc chắn che phủ toàn màn hình
/// (bao gồm cả BottomNavigationBar của ShellRoute).
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
}) {
  return showDialog<T>(
    context: context,
    useRootNavigator: true, // Mặc định luôn sử dụng Root Navigator
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    builder: builder,
  );
}
