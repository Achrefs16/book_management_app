class ApiConfig {
  static const String baseUrl = 'http://localhost:5000/api'; // For Android emulator
  
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  
  // Book endpoints
  static const String books = '/books';
  static String bookDetail(String id) => '/books/$id';
}