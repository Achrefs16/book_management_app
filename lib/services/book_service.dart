import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import 'api_config.dart';

class BookService {
  final String? token;

  BookService(this.token);

  // Headers with authentication
  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // Get all books
  Future<List<Book>> getAllBooks() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.books}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] && responseData['data'] != null) {
          final List<dynamic> booksJson = responseData['data'];
          return booksJson.map((book) => Book.fromJson(book)).toList();
        }
      }
      return [];
    } catch (error) {
      throw Exception('Failed to load books: $error');
    }
  }

  // Get book by ID
  Future<Book?> getBookById(String id) async {
  
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.bookDetail(id)}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] && responseData['data'] != null) {
          return Book.fromJson(responseData['data']);
        }
      }
      return null;
    } catch (error) {
      throw Exception('Failed to load book details: $error');
    }
  }

  // Create a new book
  Future<Book?> createBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.books}'),
        headers: headers,
        body: json.encode(book.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] && responseData['data'] != null) {
          return Book.fromJson(responseData['data']);
        }
      }
      return null;
    } catch (error) {
      throw Exception('Failed to create book: $error');
    }
  }

  // Update an existing book
  Future<Book?> updateBook(String id, Book book) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.bookDetail(id)}'),
        headers: headers,
        body: json.encode(book.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] && responseData['data'] != null) {
          return Book.fromJson(responseData['data']);
        }
      }
      return null;
    } catch (error) {
      throw Exception('Failed to update book: $error');
    }
  }

  // Delete a book
  Future<bool> deleteBook(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.bookDetail(id)}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'] ?? false;
      }
      return false;
    } catch (error) {
      throw Exception('Failed to delete book: $error');
    }
  }
}