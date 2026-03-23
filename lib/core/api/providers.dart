import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/dio_client.dart';

final dioProvider = Provider<Dio>((ref) => DioClient.createDio());
