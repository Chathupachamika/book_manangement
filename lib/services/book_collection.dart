import '../models/book.dart';
import '../models/book_status.dart';

class BookCollection {
  List<Book> _books = [];

  void addBook(Book book) {
    if (_books.any((b) => b.isbn == book.isbn)) {
      throw ArgumentError('A book with this ISBN already exists');
    }
    _books.add(book);
  }

  void removeBook(String isbn) {
    _books.removeWhere((book) => book.isbn == isbn);
  }

  void updateBookStatus(String isbn, BookStatus newStatus) {
    final book = _books.firstWhere(
            (b) => b.isbn == isbn,
        orElse: () => throw ArgumentError('Book not found')
    );
    book.updateStatus(newStatus);
  }

  List<Book> searchByTitle(String title) {
    return _books.where(
            (book) => book.title.toLowerCase().contains(title.toLowerCase())
    ).toList();
  }

  List<Book> searchByAuthor(String author) {
    return _books.where(
            (book) => book.author.toLowerCase().contains(author.toLowerCase())
    ).toList();
  }

  List<Book> filterByStatus(BookStatus status) {
    return _books.where((book) => book.status == status).toList();
  }

  List<Book> getAllBooks() {
    return List.unmodifiable(_books);
  }
}