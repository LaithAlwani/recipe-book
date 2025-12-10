import 'package:recipe_book/features/recipe_book_details/recipe_book_model.dart';

enum RecipeBooksStatus { initial, loading, loaded, error }

class RecipeBooksState {
  final RecipeBooksStatus status;
  final List<RecipeBook> books;
  final String? currentBookId; // The collection itself // Or just recipes
  final bool isLoadingBooks;
  final bool isUpdating;
  final String? errorMessage;

  const RecipeBooksState({
    this.status = RecipeBooksStatus.initial,
    this.books = const [],
    this.currentBookId,
    this.isLoadingBooks = false,
    this.isUpdating = false,
    this.errorMessage,
  });

  RecipeBooksState copyWith({
    RecipeBooksStatus? status,
    List<RecipeBook>? books,
    String? currentBookId,
    bool? isLoadingBooks,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return RecipeBooksState(
      status: status ?? this.status,
      books: books ?? this.books,
      currentBookId: currentBookId ?? this.currentBookId,
      isLoadingBooks: isLoadingBooks ?? this.isLoadingBooks,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RecipeBooksState.initial() => const RecipeBooksState(
    status: RecipeBooksStatus
        .initial, // custom enum, e.g., initial/loading/loaded/error
    books: [],
    currentBookId: null,
    isLoadingBooks: false,
    isUpdating: false,
    errorMessage: null,
  );
}
