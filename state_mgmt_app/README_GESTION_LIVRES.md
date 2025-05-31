# Application de Gestion de Livres - Flutter State Management

## 📚 Description

Cette application Flutter démontre l'utilisation du **Provider** pour la gestion d'état dans une application de gestion de livres. Elle permet d'ajouter, modifier, supprimer et organiser une collection de livres avec des fonctionnalités avancées de filtrage et de recherche.

## 🏗️ Architecture et State Management

### Provider Pattern
L'application utilise le pattern **Provider** de Flutter pour la gestion d'état :

- **BookProvider** : Gère l'état global de la collection de livres
- **ChangeNotifier** : Notifie automatiquement les widgets des changements d'état
- **Consumer** : Écoute les changements et reconstruit l'interface utilisateur

### Structure du Projet

```
lib/
├── main.dart                    # Point d'entrée avec ChangeNotifierProvider
├── models/
│   └── book.dart               # Modèle de données Book
├── providers/
│   └── book_provider.dart      # Provider pour la gestion d'état
└── screens/
    ├── book_list_screen.dart   # Écran principal avec liste des livres
    ├── book_detail_screen.dart # Écran de détails d'un livre
    └── add_edit_book_screen.dart # Écran d'ajout/modification
```

## ✨ Fonctionnalités

### 📖 Gestion des Livres
- ✅ Ajouter de nouveaux livres
- ✅ Modifier les informations d'un livre
- ✅ Supprimer des livres
- ✅ Marquer comme lu/non lu
- ✅ Système de notation (1-5 étoiles)

### 🔍 Recherche et Filtres
- ✅ Recherche par titre ou auteur
- ✅ Filtrage par genre
- ✅ Filtrage par statut de lecture
- ✅ Combinaison de filtres multiples

### 📊 Statistiques
- ✅ Nombre total de livres
- ✅ Livres lus vs non lus
- ✅ Note moyenne de la collection

### 🎨 Interface Utilisateur
- ✅ Design Material 3
- ✅ Navigation intuitive
- ✅ Cartes d'information
- ✅ Indicateurs visuels de statut

## 🚀 Comment visualiser le preview

### Option 1: Émulateur Android/iOS
```bash
# Démarrer un émulateur Android ou iOS
flutter emulators --launch <emulator_id>

# Lancer l'application
cd state_mgmt_app
flutter run
```

### Option 2: Web Browser
```bash
cd state_mgmt_app
flutter run -d web-server --web-port 8080
```
Puis ouvrir http://localhost:8080 dans votre navigateur

### Option 3: Device physique
```bash
# Connecter votre téléphone en mode développeur
flutter devices

# Lancer sur le device
cd state_mgmt_app
flutter run -d <device_id>
```

### Option 4: VS Code
1. Ouvrir le projet dans VS Code
2. Installer l'extension Flutter
3. Appuyer sur F5 ou utiliser "Run > Start Debugging"

## 🔧 Prérequis

- Flutter SDK (>=3.8.0)
- Dart SDK
- Un émulateur Android/iOS ou un navigateur web

## 📦 Dépendances

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2  # Pour la gestion d'état
```

## 🎯 Concepts de State Management démontrés

### 1. Provider Setup
```dart
// main.dart
ChangeNotifierProvider(
  create: (context) => BookProvider(),
  child: MaterialApp(...)
)
```

### 2. State Management
```dart
// book_provider.dart
class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  
  void addBook(Book book) {
    _books.add(book);
    notifyListeners(); // Notifie tous les listeners
  }
}
```

### 3. Consuming State
```dart
// Dans les widgets
Consumer<BookProvider>(
  builder: (context, bookProvider, child) {
    return ListView.builder(
      itemCount: bookProvider.books.length,
      // ...
    );
  },
)
```

### 4. Accessing Provider
```dart
// Pour les actions sans rebuild
final provider = Provider.of<BookProvider>(context, listen: false);
provider.addBook(newBook);
```

## 🎨 Captures d'écran attendues

1. **Écran principal** : Liste des livres avec statistiques et filtres
2. **Écran de détails** : Informations complètes d'un livre avec actions
3. **Écran d'ajout** : Formulaire pour ajouter/modifier un livre
4. **Recherche et filtres** : Interface de filtrage avancée

## 🔄 Flux de données

1. **Action utilisateur** → Appel de méthode Provider
2. **Provider** → Modification de l'état + `notifyListeners()`
3. **Consumer widgets** → Reconstruction automatique de l'UI
4. **Interface** → Affichage des nouvelles données

## 🧪 Test de l'application

L'application inclut des données d'exemple pour tester immédiatement :
- Le Petit Prince (Fiction, Lu)
- Clean Code (Technique, Non lu)
- 1984 (Science-Fiction, Lu)
- Sapiens (Histoire, Non lu)

## 📝 Notes importantes

- L'état est persisté en mémoire uniquement (redémarre à chaque lancement)
- Pour la persistance, ajouter SharedPreferences ou une base de données
- Le code est structuré pour faciliter l'ajout de nouvelles fonctionnalités
- Tous les widgets sont réactifs aux changements d'état

## 🎓 Apprentissages

Cette application démontre :
- ✅ Séparation des responsabilités (Model-View-Provider)
- ✅ Gestion d'état réactive avec Provider
- ✅ Navigation entre écrans
- ✅ Formulaires avec validation
- ✅ Filtrage et recherche en temps réel
- ✅ Interface utilisateur moderne avec Material 3
