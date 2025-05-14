class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String genre;
  final int publishedYear;
  final String isbn;
  final int pages;
  final String imageUrl;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.genre,
    required this.publishedYear,
    required this.isbn,
    required this.pages,
    this.imageUrl = '',
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      genre: json['genre'] ?? '',
      publishedYear: json['publishedYear'] ?? 0,
      isbn: json['isbn'] ?? '',
      pages: json['pages'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'genre': genre,
      'publishedYear': publishedYear,
      'isbn': isbn,
      'pages': pages,
      'imageUrl': imageUrl,
    };
  }
}
