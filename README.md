# Flutter Book Management App

A Flutter application demonstrating state management with Provider pattern for managing a personal book collection.

## 📚 Overview

This application showcases effective state management in Flutter using the Provider pattern. It allows users to manage their book collection with features like adding, editing, and filtering books, along with visual statistics about their reading habits.

## 🏗️ Architecture

### State Management with Provider

The application implements the Provider pattern for state management:

- **Single Source of Truth**: `BookProvider` manages the entire book collection state
- **Reactive UI**: Widgets rebuild automatically when state changes
- **Separation of Concerns**: Business logic is separated from UI components

### Project Structure

```
lib/
├── main.dart                    # Entry point with ChangeNotifierProvider setup
├── models/
│   └── book.dart                # Book data model
├── providers/
│   └── book_provider.dart       # State management with ChangeNotifier
└── screens/
    ├── book_list_screen.dart    # Main screen with book list and filters
    ├── book_detail_screen.dart  # Book details view
    └── add_edit_book_screen.dart # Form for adding/editing books
```

## ✨ Features

### Book Management
- Add new books with details (title, author, genre, pages, etc.)
- Edit existing book information
- Delete books from collection
- Mark books as read/unread
- Rate books (1-5 stars)

### Search & Filtering
- Search by title or author
- Filter by genre
- Filter by read status
- Combine multiple filters

### Statistics
- Total books count
- Read vs. unread books
- Average rating of collection

### UI Features
- Material 3 design
- Intuitive navigation
- Visual indicators for book status
- Responsive layout

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/book_management_app.git
   ```

2. Navigate to the project directory:
   ```bash
   cd book_management_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## 📱 Usage

### Adding a Book
1. Tap the "+" button on the main screen
2. Fill in the book details
3. Tap "Save"

### Editing a Book
1. Tap on a book or select "Edit" from the menu
2. Modify the details
3. Tap "Save"

### Filtering Books
1. Use the search bar to find books by title or author
2. Use the genre dropdown to filter by genre
3. Toggle the "Show only unread" switch

## 🧩 State Management Implementation

### Provider Setup
```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: BookManagementApp(),
    ),
  );
}
```

### Consuming State
```dart
Consumer<BookProvider>(
  builder: (context, bookProvider, child) {
    return ListView.builder(
      itemCount: bookProvider.filteredBooks.length,
      itemBuilder: (context, index) {
        final book = bookProvider.filteredBooks[index];
        // Build UI with book data
      },
    );
  },
)
```

### Modifying State
```dart
// Access provider without listening to changes
final provider = Provider.of<BookProvider>(context, listen: false);
provider.addBook(newBook);
```

## 🔄 Data Flow

1. **User Action**: User interacts with UI (adds book, toggles filter)
2. **State Change**: Provider method is called, modifying internal state
3. **Notification**: Provider calls `notifyListeners()`
4. **UI Update**: All listening widgets rebuild with new data

## 📦 Dependencies

- [provider](https://pub.dev/packages/provider): ^6.1.2 - For state management
<!-- 
## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details. -->