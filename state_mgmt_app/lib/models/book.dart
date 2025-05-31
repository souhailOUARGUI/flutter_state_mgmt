class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String genre;
  final int pages;
  final double rating;
  final bool isRead;
  final DateTime dateAdded;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.genre,
    required this.pages,
    this.rating = 0.0,
    this.isRead = false,
    required this.dateAdded,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? genre,
    int? pages,
    double? rating,
    bool? isRead,
    DateTime? dateAdded,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      pages: pages ?? this.pages,
      rating: rating ?? this.rating,
      isRead: isRead ?? this.isRead,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'genre': genre,
      'pages': pages,
      'rating': rating,
      'isRead': isRead,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      genre: json['genre'],
      pages: json['pages'],
      rating: json['rating']?.toDouble() ?? 0.0,
      isRead: json['isRead'] ?? false,
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: $author, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
