import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/core/fcm/fcm_service.dart';

final fcmServiceProvider = Provider<FcmService>((ref) {
  final dio = ref.watch(dioProvider);
  return FcmService(dio);
});