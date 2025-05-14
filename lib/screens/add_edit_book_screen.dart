import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

class AddEditBookScreen extends StatefulWidget {
  static const routeName = '/add-edit-book';
  const AddEditBookScreen({Key? key}) : super(key: key);

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'title': '',
    'author': '',
    'description': '',
    'genre': '',
    'publishedYear': '',
    'isbn': '',
    'pages': '',
    'imageUrl': '',
  };
  bool _isLoading = false;
  String? _error;
  Book? _editingBook;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg != null && _editingBook == null && arg is Book) {
      _editingBook = arg;
      _formData['title'] = arg.title;
      _formData['author'] = arg.author;
      _formData['description'] = arg.description;
      _formData['genre'] = arg.genre;
      _formData['publishedYear'] = arg.publishedYear.toString();
      _formData['isbn'] = arg.isbn;
      _formData['pages'] = arg.pages.toString();
      _formData['imageUrl'] = arg.imageUrl;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() { _isLoading = true; _error = null; });
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final book = Book(
      id: _editingBook?.id ?? '',
      title: _formData['title'],
      author: _formData['author'],
      description: _formData['description'],
      genre: _formData['genre'],
      publishedYear: int.tryParse(_formData['publishedYear']) ?? 0,
      isbn: _formData['isbn'],
      pages: int.tryParse(_formData['pages']) ?? 0,
      imageUrl: _formData['imageUrl'],
      createdBy: _editingBook?.createdBy ?? '',
      createdAt: _editingBook?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    bool success;
    if (_editingBook == null) {
      success = await bookProvider.addBook(book);
    } else {
      success = await bookProvider.updateBook(book.id, book);
    }
    setState(() { _isLoading = false; });
    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() { _error = bookProvider.errorMessage; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingBook == null ? 'Add Book' : 'Edit Book'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    if (_error != null) ...[
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                    ],
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      onSaved: (v) => _formData['title'] = v ?? '',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _formData['author'],
                      decoration: const InputDecoration(labelText: 'Author'),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      onSaved: (v) => _formData['author'] = v ?? '',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      onSaved: (v) => _formData['description'] = v ?? '',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _formData['genre'],
                      decoration: const InputDecoration(labelText: 'Genre'),
                      onSaved: (v) => _formData['genre'] = v ?? '',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _formData['publishedYear'],
                      decoration: const InputDecoration(labelText: 'Published Year'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      onSaved: (v) => _formData['publishedYear'] = v ?? '',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _formData['isbn'],
                      decoration: const InputDecoration(labelText: 'ISBN'),
                      onSaved: (v) => _formData['isbn'] = v ?? '',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _formData['pages'],
                      decoration: const InputDecoration(labelText: 'Pages'),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => _formData['pages'] = v ?? '',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _formData['imageUrl'],
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      onSaved: (v) => _formData['imageUrl'] = v ?? '',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(_editingBook == null ? 'Add Book' : 'Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 