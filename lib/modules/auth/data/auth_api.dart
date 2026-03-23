import 'package:dio/dio.dart';
import 'package:food_tracker/modules/auth/data/auth_models.dart';

class AuthApi {
  final Dio _dio;

  AuthApi(this._dio);

  Future<TokenResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '/api/v1/auth/login',
      data: request.toJson()
    );

    return TokenResponse.fromJson(response.data);
  }

  Future<TokenResponse> register(RegisterRequest request) async {
    final response = await _dio.post(
      '/api/v1/auth/register',
      data: request.toJson()
    );
    return TokenResponse.fromJson(response.data);
  }
}