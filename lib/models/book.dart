import 'book_status.dart';

class Book {
  String _title;
  String _author;
  late String _isbn;
  BookStatus _status;

  Book({
    required String title,
    required String author,
    required String isbn,
    BookStatus status = BookStatus.available
  }) :
        _title = title,
        _author = author,
        _status = status {
    if (!_isValidISBN(isbn)) {
      throw ArgumentError('Invalid ISBN format');
    }
    _isbn = isbn;
  }

  String get title => _title;
  String get author => _author;
  String get isbn => _isbn;
  BookStatus get status => _status;

  set title(String newTitle) => _title = newTitle;
  set author(String newAuthor) => _author = newAuthor;

  bool _isValidISBN(String isbn) {
    final cleanIsbn = isbn.replaceAll(RegExp(r'[-\s]'), '');
    return RegExp(r'^\d{13}$').hasMatch(cleanIsbn);
  }

  void updateStatus(BookStatus newStatus) {
    _status = newStatus;
  }

  @override
  String toString() {
    return 'Book: $_title by $_author (ISBN: $_isbn, Status: $_status)';
  }
}