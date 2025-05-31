import 'package:flutter/foundation.dart';
import '../models/book.dart';

class BookProvider extends ChangeNotifier {
  final List<Book> _books = [];
  String _searchQuery = '';
  String _selectedGenre = 'Tous';
  bool _showOnlyUnread = false;

  // Getters
  List<Book> get books => _books;
  String get searchQuery => _searchQuery;
  String get selectedGenre => _selectedGenre;
  bool get showOnlyUnread => _showOnlyUnread;

  // Getter pour les livres filtrés
  List<Book> get filteredBooks {
    List<Book> filtered = _books;

    // Filtrer par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((book) {
        return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filtrer par genre
    if (_selectedGenre != 'Tous') {
      filtered = filtered.where((book) => book.genre == _selectedGenre).toList();
    }

    // Filtrer par statut de lecture
    if (_showOnlyUnread) {
      filtered = filtered.where((book) => !book.isRead).toList();
    }

    return filtered;
  }

  // Getter pour les genres disponibles
  List<String> get availableGenres {
    final genres = _books.map((book) => book.genre).toSet().toList();
    genres.sort();
    return ['Tous', ...genres];
  }

  // Statistiques
  int get totalBooks => _books.length;
  int get readBooks => _books.where((book) => book.isRead).length;
  int get unreadBooks => _books.where((book) => !book.isRead).length;
  double get averageRating {
    if (_books.isEmpty) return 0.0;
    final ratedBooks = _books.where((book) => book.rating > 0);
    if (ratedBooks.isEmpty) return 0.0;
    return ratedBooks.map((book) => book.rating).reduce((a, b) => a + b) / ratedBooks.length;
  }

  BookProvider() {
    _loadSampleData();
  }

  // Charger des données d'exemple
  void _loadSampleData() {
    final sampleBooks = [
      Book(
        id: '1',
        title: 'Le Petit Prince',
        author: 'Antoine de Saint-Exupéry',
        description: 'Un conte poétique et philosophique sous l\'apparence d\'un conte pour enfants.',
        genre: 'Fiction',
        pages: 96,
        rating: 4.5,
        isRead: true,
        dateAdded: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Book(
        id: '2',
        title: 'Clean Code',
        author: 'Robert C. Martin',
        description: 'Un guide pour écrire du code propre et maintenable.',
        genre: 'Technique',
        pages: 464,
        rating: 4.8,
        isRead: false,
        dateAdded: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Book(
        id: '3',
        title: '1984',
        author: 'George Orwell',
        description: 'Un roman dystopique sur la surveillance et le totalitarisme.',
        genre: 'Science-Fiction',
        pages: 328,
        rating: 4.7,
        isRead: true,
        dateAdded: DateTime.now().subtract(const Duration(days: 45)),
      ),
      Book(
        id: '4',
        title: 'Sapiens',
        author: 'Yuval Noah Harari',
        description: 'Une brève histoire de l\'humanité.',
        genre: 'Histoire',
        pages: 512,
        rating: 4.6,
        isRead: false,
        dateAdded: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    _books.addAll(sampleBooks);
    notifyListeners();
  }

  // Ajouter un livre
  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  // Mettre à jour un livre
  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }

  // Supprimer un livre
  void deleteBook(String bookId) {
    _books.removeWhere((book) => book.id == bookId);
    notifyListeners();
  }

  // Marquer comme lu/non lu
  void toggleReadStatus(String bookId) {
    final index = _books.indexWhere((book) => book.id == bookId);
    if (index != -1) {
      _books[index] = _books[index].copyWith(isRead: !_books[index].isRead);
      notifyListeners();
    }
  }

  // Mettre à jour la note
  void updateRating(String bookId, double rating) {
    final index = _books.indexWhere((book) => book.id == bookId);
    if (index != -1) {
      _books[index] = _books[index].copyWith(rating: rating);
      notifyListeners();
    }
  }

  // Recherche
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Filtrer par genre
  void setSelectedGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  // Filtrer par statut de lecture
  void setShowOnlyUnread(bool showOnlyUnread) {
    _showOnlyUnread = showOnlyUnread;
    notifyListeners();
  }

  // Réinitialiser les filtres
  void clearFilters() {
    _searchQuery = '';
    _selectedGenre = 'Tous';
    _showOnlyUnread = false;
    notifyListeners();
  }

  // Obtenir un livre par ID
  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
}
