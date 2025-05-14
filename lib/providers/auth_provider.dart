import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/auth_response.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _user;
  DateTime? _expiryDate;
  Timer? _authTimer;
  final AuthService _authService = AuthService();

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  User? get user {
    return _user;
  }

  // Authenticate user (login or register)
  Future<bool> authenticate(String email, String password, {bool isLogin = true}) async {
    AuthResponse authResponse;

    if (isLogin) {
      authResponse = await _authService.login(email, password);
    } else {
      authResponse = await _authService.register('', email, password);
    }

    if (authResponse.success && authResponse.token.isNotEmpty) {
      _token = authResponse.token;
      _user = authResponse.user;
      
      // Set token expiry date (assuming JWT with 24 hours validity)
      _expiryDate = DateTime.now().add(const Duration(hours: 24));
      
      // Save token to local storage
      await _authService.saveToken(_token!);
      
      // Set auto logout timer
      _autoLogout();
      
      notifyListeners();
      return true;
    }
    
    return false;
  }

  // Register user
  Future<bool> register(String name, String email, String password) async {
    final authResponse = await _authService.register(name, email, password);

    if (authResponse.success && authResponse.token.isNotEmpty) {
      _token = authResponse.token;
      _user = authResponse.user;
      
      // Set token expiry date (assuming JWT with 24 hours validity)
      _expiryDate = DateTime.now().add(const Duration(hours: 24));
      
      // Save token to local storage
      await _authService.saveToken(_token!);
      
      // Set auto logout timer
      _autoLogout();
      
      notifyListeners();
      return true;
    }
    
    return false;
  }

  // Try auto login from stored token
  Future<bool> tryAutoLogin() async {
    final storedToken = await _authService.getToken();
    
    if (storedToken == null) {
      return false;
    }
    
    // Here you might want to validate the token with the server
    // For simplicity, we'll just set the token and assume it's valid
    _token = storedToken;
    _expiryDate = DateTime.now().add(const Duration(hours: 24));
    
    // Set auto logout timer
    _autoLogout();
    
    notifyListeners();
    return true;
  }

  // Logout user
  Future<void> logout() async {
    _token = null;
    _user = null;
    _expiryDate = null;
    
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    
    await _authService.clearToken();
    notifyListeners();
  }

  // Auto logout when token expires
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}