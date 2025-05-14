import 'user.dart';

class AuthResponse {
  final bool success;
  final String token;
  final User? user;
  final String message;

  AuthResponse({
    required this.success,
    required this.token,
    this.user,
    required this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      message: json['message'] ?? '',
    );
  }
}