import 'package:flutter/material.dart';
import 'models/book.dart';
import 'models/text_book.dart';
import 'models/book_status.dart';
import 'services/book_collection.dart';

void main() {
  runApp(MyBookManagementApp());
}

class MyBookManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookCollection _library = BookCollection();
  List<Book> _displayedBooks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addInitialBooks();
    _displayedBooks = _library.getAllBooks();
  }

  void _addInitialBooks() {
    try {
      _library.addBook(Book(
        title: 'Clean Code',
        author: 'Robert Martin',
        isbn: '9780132350884',
      ));
      _library.addBook(TextBook(
        title: 'Calculus',
        author: 'James Stewart',
        isbn: '9780840058553',
        subject: 'Mathematics',
        gradeLevel: '12',
      ));
    } catch (e) {
      _showSnackBar('Error adding initial books: $e');
    }
  }

  void _searchBooks(String query) {
    setState(() {
      _displayedBooks = _library.getAllBooks().where((book) {
        return book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase()) ||
            book.isbn.contains(query);
      }).toList();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _confirmDeleteBook(Book book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Book'),
          content: Text('Are you sure you want to delete "${book.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _library.removeBook(book.isbn);
                  _displayedBooks = _library.getAllBooks();
                });
                _showSnackBar('Book "${book.title}" deleted successfully.');
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateBookStatusDialog(Book book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Book Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: BookStatus.values.map((status) {
              return ListTile(
                title: Text(status.toString().split('.').last),
                onTap: () {
                  setState(() {
                    _library.updateBookStatus(book.isbn, status);
                    _displayedBooks = _library.getAllBooks();
                  });
                  _showSnackBar('Book status updated to ${status.toString().split('.').last}.');
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showAddBookDialog() {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final isbnController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: isbnController,
                decoration: InputDecoration(labelText: 'ISBN'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  final newBook = Book(
                    title: titleController.text.trim(),
                    author: authorController.text.trim(),
                    isbn: isbnController.text.trim(),
                  );
                  setState(() {
                    _library.addBook(newBook);
                    _displayedBooks = _library.getAllBooks();
                  });
                  _showSnackBar('Book "${newBook.title}" added successfully.');
                  Navigator.of(context).pop();
                } catch (e) {
                  _showSnackBar('Error: $e');
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Books',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _searchBooks,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _displayedBooks.length,
              itemBuilder: (context, index) {
                final book = _displayedBooks[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text('${book.author} - ${book.isbn}'),
                  trailing: Text(book.status.toString().split('.').last),
                  onTap: () => _showUpdateBookStatusDialog(book),
                  onLongPress: () => _confirmDeleteBook(book),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
