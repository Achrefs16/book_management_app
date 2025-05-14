import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import 'book_detail_screen.dart';
import 'add_edit_book_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<BookProvider>(context, listen: false).fetchBooks();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: bookProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookProvider.errorMessage.isNotEmpty
              ? Center(child: Text(bookProvider.errorMessage))
              : ListView.builder(
                  itemCount: bookProvider.books.length,
                  itemBuilder: (ctx, i) {
                    final book = bookProvider.books[i];
                    return ListTile(
                      leading: book.imageUrl.isNotEmpty
                          ? Image.network(book.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.book, size: 40),
                      title: Text(book.title),
                      subtitle: Text(book.author),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          BookDetailScreen.routeName,
                          arguments: book.id,
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddEditBookScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 