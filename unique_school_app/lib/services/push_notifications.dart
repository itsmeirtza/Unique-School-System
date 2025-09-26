import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Top-level background handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    debugPrint('[FCM][BG] Title: ${message.notification?.title}, Body: ${message.notification?.body}');
  }
}

class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  late final AndroidNotificationChannel _channel;

  Future<void> initialize() async {
    // iOS/macOS permission request; Android 13+ permission will be handled by the system dialog
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (kDebugMode) {
      debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');
    }

    // Create Android notification channel for foreground notifications
    _channel = const AndroidNotificationChannel(
      'high_importance',
      'High Importance Notifications',
      description: 'Used for important notifications.',
      importance: Importance.high,
    );

    await _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        // Handle tap on local notification
      },
    );

    await _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Foreground message handling -> show local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      final android = message.notification?.android;
      if (notification != null && (Platform.isAndroid ? android != null : true)) {
        await _local.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(),
          ),
          payload: message.data.isNotEmpty ? message.data.toString() : null,
        );
      }
      if (kDebugMode) {
        debugPrint('[FCM][FG] ${notification?.title} - ${notification?.body}');
      }
    });

    // When notification is tapped and app opens
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('[FCM][OPEN] ${message.data}');
      }
    });

    // Get and log FCM token
    final token = await _messaging.getToken();
    if (kDebugMode) {
      debugPrint('[FCM] Token: $token');
    }

    // Optional: listen for token refresh
    _messaging.onTokenRefresh.listen((t) {
      if (kDebugMode) {
        debugPrint('[FCM] Token refreshed: $t');
      }
    });
  }

  // Subscribe to a class topic (normalized)
  Future<void> subscribeToClass(String className) async {
    final topic = _topicFromClass(className);
    await _messaging.subscribeToTopic(topic);
    // persist state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_topicKey(topic), true);
    await prefs.setString('last_class', className);
    if (kDebugMode) debugPrint('[FCM] Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromClass(String className) async {
    final topic = _topicFromClass(className);
    await _messaging.unsubscribeFromTopic(topic);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_topicKey(topic), false);
    if (kDebugMode) debugPrint('[FCM] Unsubscribed from topic: $topic');
  }

  // Helper to explicitly set subscription and persist
  Future<void> setSubscriptionForClass(String className, bool enabled) async {
    if (enabled) {
      await subscribeToClass(className);
    } else {
      await unsubscribeFromClass(className);
    }
  }

  // Read persisted subscription state
  Future<bool> isSubscribedToClass(String className) async {
    final topic = _topicFromClass(className);
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_topicKey(topic)) ?? false;
  }

  String _topicFromClass(String s) => 'class_${s.toLowerCase().replaceAll(RegExp(r"[^a-z0-9]+"), '_')}';
  String _topicKey(String topic) => 'subscribed_$topic';
}
