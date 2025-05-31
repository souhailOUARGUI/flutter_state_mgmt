import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';
import 'add_edit_book_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final book = bookProvider.getBookById(bookId);

        if (book == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Livre introuvable')),
            body: const Center(
              child: Text('Ce livre n\'existe plus.'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(book.title),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _navigateToEdit(context, book),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(context, value, book),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'toggle_read',
                    child: Text(book.isRead ? 'Marquer non lu' : 'Marquer lu'),
                  ),
                  const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, book),
                const SizedBox(height: 24),
                _buildInfoSection(context, book),
                const SizedBox(height: 24),
                _buildRatingSection(context, book, bookProvider),
                const SizedBox(height: 24),
                _buildDescriptionSection(context, book),
                const SizedBox(height: 24),
                _buildActionButtons(context, book, bookProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Book book) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                color: book.isRead ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: book.isRead ? Colors.green : Colors.orange,
                  width: 2,
                ),
              ),
              child: Icon(
                book.isRead ? Icons.check_circle : Icons.schedule,
                size: 40,
                color: book.isRead ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'par ${book.author}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      book.genre,
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Book book) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.menu_book, 'Pages', '${book.pages} pages'),
            const SizedBox(height: 12),
            _buildInfoRow(
              book.isRead ? Icons.check_circle : Icons.schedule,
              'Statut',
              book.isRead ? 'Lu' : 'Non lu',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              'Ajouté le',
              _formatDate(book.dateAdded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(value),
      ],
    );
  }

  Widget _buildRatingSection(BuildContext context, Book book, BookProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évaluation',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Note: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                ...List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => provider.updateRating(book.id, (index + 1).toDouble()),
                    child: Icon(
                      index < book.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  book.rating > 0 ? '${book.rating}/5' : 'Non noté',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, Book book) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              book.description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Book book, BookProvider provider) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => provider.toggleReadStatus(book.id),
            icon: Icon(book.isRead ? Icons.remove_circle : Icons.check_circle),
            label: Text(book.isRead ? 'Marquer non lu' : 'Marquer lu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: book.isRead ? Colors.orange : Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _navigateToEdit(context, book),
            icon: const Icon(Icons.edit),
            label: const Text('Modifier'),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleMenuAction(BuildContext context, String action, Book book) {
    final provider = Provider.of<BookProvider>(context, listen: false);

    switch (action) {
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
              Navigator.pop(context); // Fermer le dialog
              Navigator.pop(context); // Retourner à la liste
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBookScreen(book: book)),
    );
  }
}
