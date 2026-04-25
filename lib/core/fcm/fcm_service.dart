import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  final Dio _dio;

  FcmService(this._dio);

  Future<void> registerToken() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      await _sendToken(token);
    } catch (e) {
      debugPrint('FCM registerToken error: $e');
    }
  }

  void listenTokenRefresh() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.onTokenRefresh.listen((newToken) async {
      await _sendToken(newToken);
    });
  }

  Future<void> _sendToken(String token) async {
    try {
      await _dio.patch(
        '/api/v1/auth/fcm-token',
        data: {'fcm_token': token},
      );
      debugPrint('FCM token sent: ${token.substring(0, 20)}...');
    } catch (e) {
      debugPrint('FCM token send error: $e');
    }
  }
}