import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  final String? token;
  late BookService _bookService;
  List<Book> _books = [];
  bool _isLoading = false;
  String _errorMessage = '';

  BookProvider(this.token) {
    _bookService = BookService(token);
  }

  List<Book> get books {
    return [..._books];
  }

  bool get isLoading {
    return _isLoading;
  }

  String get errorMessage {
    return _errorMessage;
  }

  // Fetch all books
  Future<void> fetchBooks() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final fetchedBooks = await _bookService.getAllBooks();
      _books = fetchedBooks;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch books. Please try again.';
      notifyListeners();
      throw error;
    }
  }

  // Get book by ID
  Future<Book?> getBookById(String id) async {
    try {
      return await _bookService.getBookById(id);
    } catch (error) {
      _errorMessage = 'Failed to fetch book details. Please try again.';
      notifyListeners();
      return null;
    }
  }

  // Add new book
  Future<bool> addBook(Book book) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final newBook = await _bookService.createBook(book);
      
      if (newBook != null) {
        _books.add(newBook);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = 'Failed to add book. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Failed to add book. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // Update existing book
  Future<bool> updateBook(String id, Book updatedBook) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final book = await _bookService.updateBook(id, updatedBook);
      
      if (book != null) {
        final bookIndex = _books.indexWhere((book) => book.id == id);
        
        if (bookIndex >= 0) {
          _books[bookIndex] = book;
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = 'Failed to update book. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Failed to update book. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // Delete book
  Future<bool> deleteBook(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final success = await _bookService.deleteBook(id);
      
      if (success) {
        _books.removeWhere((book) => book.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = 'Failed to delete book. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Failed to delete book. Please try again.';
      notifyListeners();
      return false;
    }
  }
}