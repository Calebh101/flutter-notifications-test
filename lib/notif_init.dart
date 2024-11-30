import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Global instance of FlutterLocalNotificationsPlugin
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> notificationInitState() async {
  // Initialize the global flutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Android initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  // iOS and macOS initialization settings
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  // Linux initialization settings
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');

  // Consolidated initialization settings
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );

  // Initialize with settings and callback
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
}

// Callback for notification response
void onDidReceiveNotificationResponse(NotificationResponse response) {
  // Handle the notification response
  print('Notification clicked: ${response.payload}');
}

// Request permissions for iOS/macOS
Future<bool> requestPermissions() async {
  if (Platform.isIOS) {
    // Request permissions for iOS
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result ?? false;
  } else if (Platform.isMacOS) {
    // Request permissions for macOS
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result ?? false;
  }
  return true; // No permissions required for other platforms
}
