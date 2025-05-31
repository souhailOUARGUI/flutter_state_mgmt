import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/book_provider.dart';
import 'screens/book_list_screen.dart';

void main() {
  runApp(const BookManagementApp());
}

class BookManagementApp extends StatelessWidget {
  const BookManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: MaterialApp(
        title: 'Gestion de Livres',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BookListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
