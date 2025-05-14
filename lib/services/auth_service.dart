import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_response.dart';
import 'api_config.dart';

class AuthService {
  // Login user
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      return AuthResponse.fromJson(responseData);
    } catch (error) {
      return AuthResponse(
        success: false,
        token: '',
        message: 'Authentication failed. Please try again later.',
      );
    }
  }

  // Register user
  Future<AuthResponse> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      return AuthResponse.fromJson(responseData);
    } catch (error) {
      return AuthResponse(
        success: false,
        token: '',
        message: 'Registration failed. Please try again later.',
      );
    }
  }

  // Save token to local storage
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Get token from local storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Clear token from local storage (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}