import '../models/auth_result.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService([ApiClient? apiClient]) : _apiClient = apiClient ?? ApiClient();

  Future<AuthResult> register({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    final data = await _apiClient.post(
      '/auth/register',
      body: {
        'nombre': nombre,
        'correo': correo,
        'password': password,
      },
    );
    return AuthResult.fromJson(data);
  }

  Future<AuthResult> login({
    required String correo,
    required String password,
  }) async {
    final data = await _apiClient.post(
      '/auth/login',
      body: {
        'correo': correo,
        'password': password,
      },
    );
    return AuthResult.fromJson(data);
  }
}
