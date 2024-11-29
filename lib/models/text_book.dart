import 'book.dart';
import 'book_status.dart';

class TextBook extends Book {
  String _subject;
  String _gradeLevel;

  TextBook({
    required String title,
    required String author,
    required String isbn,
    required String subject,
    required String gradeLevel,
    BookStatus status = BookStatus.available
  }) :
        _subject = subject,
        _gradeLevel = gradeLevel,
        super(
          title: title,
          author: author,
          isbn: isbn,
          status: status
      );

  String get subject => _subject;
  String get gradeLevel => _gradeLevel;

  set subject(String newSubject) => _subject = newSubject;
  set gradeLevel(String newGradeLevel) => _gradeLevel = newGradeLevel;

  @override
  String toString() {
    return 'TextBook: ${super.toString()}, Subject: $_subject, Grade: $_gradeLevel)';
  }
}