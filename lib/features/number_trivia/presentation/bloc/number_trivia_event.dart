part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String numberString;
  int get number => int.parse(numberString);
  GetConcreteNumberTriviaEvent(this.numberString);

  @override
  List<Object?> get props => [numberString];
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}
