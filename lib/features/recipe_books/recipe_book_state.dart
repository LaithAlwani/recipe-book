import 'package:recipe_book/features/recipe_book_details/recipe_book_model.dart';

enum RecipeBooksStatus { initial, loading, loaded, error }

class RecipeBooksState {
  final RecipeBooksStatus status;
  final List<RecipeBook> books;
  final String? currentBookId;
  final String? currentBookTitle;
  final bool isLoadingBooks;
  final bool isUpdating;
  final String? errorMessage;

  const RecipeBooksState({
    this.status = RecipeBooksStatus.initial,
    this.books = const [],
    this.currentBookId,
    this.currentBookTitle,
    this.isLoadingBooks = false,
    this.isUpdating = false,
    this.errorMessage,
  });

  RecipeBooksState copyWith({
    RecipeBooksStatus? status,
    List<RecipeBook>? books,
    String? currentBookId,
    String? currentBookTitle,
    bool? isLoadingBooks,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return RecipeBooksState(
      status: status ?? this.status,
      books: books ?? this.books,
      currentBookId: currentBookId ?? this.currentBookId,
      currentBookTitle: currentBookTitle ?? this.currentBookTitle,
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
    currentBookTitle: null,
    isLoadingBooks: false,
    isUpdating: false,
    errorMessage: null,
  );
}
