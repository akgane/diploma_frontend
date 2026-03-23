import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/core/storage/token_storage.dart';
import 'package:food_tracker/modules/auth/data/auth_api.dart';
import 'package:food_tracker/modules/auth/data/auth_models.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApi(dio);
});

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final token = await TokenStorage.read();
    return token != null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(authApiProvider);
      final response = await api.login(LoginRequest(email: email, password: password));
      await TokenStorage.save(response.accessToken);
      return true;
    });
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(authApiProvider);
      final response = await api.register(RegisterRequest(name: name, email: email, password: password));
      await TokenStorage.save(response.accessToken);
      return true;
    });
  }

  Future<void> logout() async {
    await TokenStorage.delete();
    state = const AsyncData(false);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);