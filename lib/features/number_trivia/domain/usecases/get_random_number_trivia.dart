import 'package:clean_arch_and_tdd/core/error/failure.dart';
import 'package:clean_arch_and_tdd/core/usecases/usecase.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) =>
      numberTriviaRepository.getRandomNumberTrivia();
}
