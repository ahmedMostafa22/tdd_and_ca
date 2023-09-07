part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState([List props = const <dynamic>[]]);
}

class Empty extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({required this.trivia}) : super([trivia]);

  @override
  List<Object?> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message}) : super([message]);

  @override
  List<Object?> get props => [message];
}
