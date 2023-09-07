import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_arch_and_tdd/core/error/failure_handler.dart';
import 'package:clean_arch_and_tdd/core/usecases/usecase.dart';
import 'package:clean_arch_and_tdd/core/utils/input_converter.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_random_number_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(this.getConcreteNumberTrivia, this.getRandomNumberTrivia,
      this.inputConverter)
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetConcreteNumberTriviaEvent) {
        emit(Loading());
        final res = inputConverter.stringToUnsignedInteger(event.numberString);
        await res.fold(
            (f) async => emit(Error(message: failureHandler(f))),
            (number) => getConcreteNumberTrivia(Params(number: number))
                .then((result) => _eitherLoadedOrError(result, emit)));
      } else if (event is GetRandomNumberTriviaEvent) {
        emit(Loading());
        await getRandomNumberTrivia(const NoParams())
            .then((result) => _eitherLoadedOrError(result, emit));
      }
    });
  }

  void _eitherLoadedOrError(Either<Failure, NumberTrivia> result, Emitter e) =>
      result.fold((failure) => e(Error(message: failureHandler(failure))),
          (nTrivia) => e(Loaded(trivia: nTrivia)));
}
