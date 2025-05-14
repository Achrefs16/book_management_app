import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';
import 'add_edit_book_screen.dart';

class BookDetailScreen extends StatefulWidget {
  static const routeName = '/book-detail';
  const BookDetailScreen({super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Book? _book;
  bool _isLoading = true;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bookId = ModalRoute.of(context)!.settings.arguments as String;
    print('BookDetailScreen: bookId received = $bookId');
    Provider.of<BookProvider>(context, listen: false)
        .getBookById(bookId)
        .then((book) {
      setState(() {
        _book = book;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _error = 'Failed to load book details.';
        _isLoading = false;
      });
    });
  }

  void _deleteBook(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      final success = await Provider.of<BookProvider>(context, listen: false).deleteBook(id);
      if (success) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete book.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _book == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error ?? 'Book not found.')),
      );
    }
    final book = _book!;
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddEditBookScreen.routeName,
                arguments: book,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteBook(book.id),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (book.imageUrl.isNotEmpty)
              Center(
                child: Image.network(book.imageUrl, height: 200, fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),
            Text('Title: ${book.title}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Author: ${book.author}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Genre: ${book.genre}'),
            const SizedBox(height: 8),
            Text('Published: ${book.publishedYear}'),
            const SizedBox(height: 8),
            Text('ISBN: ${book.isbn}'),
            const SizedBox(height: 8),
            Text('Pages: ${book.pages}'),
            const SizedBox(height: 16),
            Text('Description:', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(book.description),
          ],
        ),
      ),
    );
  }
} 