import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pagesController = TextEditingController();

  String _selectedGenre = 'Fiction';
  double _rating = 0.0;
  bool _isRead = false;

  final List<String> _genres = [
    'Fiction',
    'Science-Fiction',
    'Fantasy',
    'Romance',
    'Thriller',
    'Mystère',
    'Histoire',
    'Biographie',
    'Technique',
    'Développement personnel',
    'Cuisine',
    'Art',
    'Voyage',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _initializeWithBook(widget.book!);
    }
  }

  void _initializeWithBook(Book book) {
    _titleController.text = book.title;
    _authorController.text = book.author;
    _descriptionController.text = book.description;
    _pagesController.text = book.pages.toString();
    _selectedGenre = book.genre;
    _rating = book.rating;
    _isRead = book.isRead;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier le livre' : 'Ajouter un livre'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton(
            onPressed: _saveBook,
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildDetailsSection(),
              const SizedBox(height: 24),
              _buildRatingSection(),
              const SizedBox(height: 24),
              _buildStatusSection(),
              const SizedBox(height: 32),
              _buildActionButtons(isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations de base',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le titre est obligatoire';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Auteur *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'L\'auteur est obligatoire';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGenre,
              decoration: const InputDecoration(
                labelText: 'Genre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _genres.map((genre) {
                return DropdownMenuItem(value: genre, child: Text(genre));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pagesController,
              decoration: const InputDecoration(
                labelText: 'Nombre de pages',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.menu_book),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final pages = int.tryParse(value);
                  if (pages == null || pages <= 0) {
                    return 'Veuillez entrer un nombre valide';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La description est obligatoire';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
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
                const Text('Note: '),
                ...List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = (index + 1).toDouble();
                      });
                    },
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
                const SizedBox(width: 8),
                Text(_rating > 0 ? '${_rating.toInt()}/5' : 'Non noté'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _rating = 0.0;
                    });
                  },
                  child: const Text('Effacer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statut de lecture',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Livre lu'),
              subtitle: Text(_isRead ? 'Ce livre a été lu' : 'Ce livre n\'a pas encore été lu'),
              value: _isRead,
              onChanged: (value) {
                setState(() {
                  _isRead = value;
                });
              },
              secondary: Icon(
                _isRead ? Icons.check_circle : Icons.schedule,
                color: _isRead ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isEditing) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveBook,
            child: Text(isEditing ? 'Mettre à jour' : 'Ajouter'),
          ),
        ),
      ],
    );
  }

  void _saveBook() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<BookProvider>(context, listen: false);
    final isEditing = widget.book != null;

    final book = Book(
      id: isEditing ? widget.book!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      description: _descriptionController.text.trim(),
      genre: _selectedGenre,
      pages: int.tryParse(_pagesController.text) ?? 0,
      rating: _rating,
      isRead: _isRead,
      dateAdded: isEditing ? widget.book!.dateAdded : DateTime.now(),
    );

    if (isEditing) {
      provider.updateBook(book);
    } else {
      provider.addBook(book);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Livre mis à jour avec succès' : 'Livre ajouté avec succès'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
