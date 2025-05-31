import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';
import 'book_detail_screen.dart';
import 'add_edit_book_screen.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Bibliothèque'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          return Column(
            children: [
              _buildStatsCard(bookProvider),
              _buildActiveFilters(context, bookProvider),
              Expanded(
                child: bookProvider.filteredBooks.isEmpty
                    ? _buildEmptyState(context)
                    : _buildBookList(context, bookProvider.filteredBooks),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddBook(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsCard(BookProvider provider) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Total', provider.totalBooks.toString(), Icons.book),
            _buildStatItem('Lus', provider.readBooks.toString(), Icons.check_circle),
            _buildStatItem('Non lus', provider.unreadBooks.toString(), Icons.schedule),
            _buildStatItem('Note moy.', provider.averageRating.toStringAsFixed(1), Icons.star),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActiveFilters(BuildContext context, BookProvider provider) {
    final hasFilters = provider.searchQuery.isNotEmpty ||
        provider.selectedGenre != 'Tous' ||
        provider.showOnlyUnread;

    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Filtres actifs: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: [
                if (provider.searchQuery.isNotEmpty)
                  Chip(
                    label: Text('Recherche: "${provider.searchQuery}"'),
                    onDeleted: () => provider.setSearchQuery(''),
                  ),
                if (provider.selectedGenre != 'Tous')
                  Chip(
                    label: Text('Genre: ${provider.selectedGenre}'),
                    onDeleted: () => provider.setSelectedGenre('Tous'),
                  ),
                if (provider.showOnlyUnread)
                  Chip(
                    label: const Text('Non lus seulement'),
                    onDeleted: () => provider.setShowOnlyUnread(false),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => provider.clearFilters(),
            child: const Text('Effacer tout'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun livre trouvé',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez votre premier livre ou modifiez vos filtres',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddBook(context),
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un livre'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList(BuildContext context, List<Book> books) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: book.isRead ? Colors.green : Colors.orange,
              child: Icon(
                book.isRead ? Icons.check : Icons.schedule,
                color: Colors.white,
              ),
            ),
            title: Text(
              book.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('par ${book.author}'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        book.genre,
                        style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (book.rating > 0) ...[
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      Text('${book.rating}'),
                    ],
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(context, value, book),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'view', child: Text('Voir détails')),
                const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                PopupMenuItem(
                  value: 'toggle_read',
                  child: Text(book.isRead ? 'Marquer non lu' : 'Marquer lu'),
                ),
                const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
              ],
            ),
            onTap: () => _navigateToBookDetail(context, book),
          ),
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    final provider = Provider.of<BookProvider>(context, listen: false);
    final controller = TextEditingController(text: provider.searchQuery);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechercher'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Titre ou auteur...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              provider.setSearchQuery(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Rechercher'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final provider = Provider.of<BookProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtres'),
        content: Consumer<BookProvider>(
          builder: (context, bookProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: bookProvider.selectedGenre,
                  decoration: const InputDecoration(labelText: 'Genre'),
                  items: bookProvider.availableGenres.map((genre) {
                    return DropdownMenuItem(value: genre, child: Text(genre));
                  }).toList(),
                  onChanged: (value) => bookProvider.setSelectedGenre(value!),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Livres non lus seulement'),
                  value: bookProvider.showOnlyUnread,
                  onChanged: (value) => bookProvider.setShowOnlyUnread(value!),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.clearFilters();
              Navigator.pop(context);
            },
            child: const Text('Réinitialiser'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action, Book book) {
    final provider = Provider.of<BookProvider>(context, listen: false);

    switch (action) {
      case 'view':
        _navigateToBookDetail(context, book);
        break;
      case 'edit':
        _navigateToEditBook(context, book);
        break;
      case 'toggle_read':
        provider.toggleReadStatus(book.id);
        break;
      case 'delete':
        _showDeleteConfirmation(context, book);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${book.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<BookProvider>(context, listen: false).deleteBook(book.id);
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditBookScreen()),
    );
  }

  void _navigateToEditBook(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBookScreen(book: book)),
    );
  }

  void _navigateToBookDetail(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(bookId: book.id)),
    );
  }
}
