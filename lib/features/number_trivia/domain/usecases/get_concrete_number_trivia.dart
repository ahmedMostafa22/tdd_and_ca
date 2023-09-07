import 'package:clean_arch_and_tdd/core/error/failure.dart';
import 'package:clean_arch_and_tdd/core/usecases/usecase.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia(this.numberTriviaRepository);
  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) =>
      numberTriviaRepository.getConcreteNumberTrivia(params.number);
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});
  @override
  List<Object?> get props => [number];
}
