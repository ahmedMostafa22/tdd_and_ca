import 'package:clean_arch_and_tdd/core/error/failure.dart';
import 'package:clean_arch_and_tdd/core/error/failure_handler.dart';
import 'package:clean_arch_and_tdd/core/usecases/usecase.dart';
import 'package:clean_arch_and_tdd/core/utils/input_converter.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late MockGetConcreteNumberTrivia concrete;
  late MockGetRandomNumberTrivia random;
  late MockInputConverter inputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    concrete = MockGetConcreteNumberTrivia();
    random = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(concrete, random, inputConverter);
  });

  test('Initial state should be empty',
      () => expect(bloc.state, equals(Empty())));

  group('GetConcreteNumberTrivia', () {
    const numberString = '1';
    const invalidNumberString = 'qqq';
    final number = int.parse(numberString);
    final NumberTrivia numberTrivia =
        NumberTrivia(text: 'test', number: number);

    void setUpSuccessNumberConverting() =>
        when(inputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(number));

    void setUpFailingNumberConverting() =>
        when(inputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

    test(
        'should call the getConcreteNumberTrivia use case when adding GetConcreteNumberTriviaEvent',
        () async {
      //Arrange
      setUpSuccessNumberConverting();
      when(concrete(any)).thenAnswer((_) async => Right(numberTrivia));
      //Act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));
      await untilCalled(concrete(any));

      //Assert
      verify(concrete(any));
    });

    test('should emit NumberTrivia when input is valid', () async {
      //Arrange
      setUpSuccessNumberConverting();
      when(concrete(any)).thenAnswer((_) async => Right(numberTrivia));
      final expected = [Loading(), Loaded(trivia: numberTrivia)];

      //Act
      bloc.add(GetConcreteNumberTriviaEvent(invalidNumberString));

      //Assert
      expectLater(bloc.stream, emitsInOrder(expected));
      await untilCalled(inputConverter.stringToUnsignedInteger(any));
      verify(inputConverter.stringToUnsignedInteger(any));
      verify(concrete(any));
    });

    test('should emit error when input is invalid', () async {
      //Arrange
      setUpFailingNumberConverting();
      final expected = [Loading(), Error(message: invalidInput)];

      //Act
      bloc.add(GetConcreteNumberTriviaEvent(invalidNumberString));

      //Assert
      expectLater(bloc.stream, emitsInOrder(expected));
      await untilCalled(inputConverter.stringToUnsignedInteger(any));
    });

    test('should emit error ServerFailure when having problem with the server',
        () async {
      //Arrange
      setUpSuccessNumberConverting();
      when(concrete(any)).thenAnswer((_) async => Left(ServerFailure()));
      final expected = [Loading(), Error(message: serverFailure)];
      //Act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));

      //Assert
      expectLater(bloc.stream, emitsInOrder(expected));
      await untilCalled(concrete(any));
    });

    test('should emit error CacheFailure when having problem with the server',
        () async {
      //Arrange
      setUpSuccessNumberConverting();
      when(concrete(any)).thenAnswer((_) async => Left(CacheFailure()));

      final expected = [Loading(), Error(message: cacheFailure)];
      //Act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));

      //Assert
      expectLater(bloc.stream, emitsInOrder(expected));
      await untilCalled(concrete(any));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(random(any)).thenAnswer((_) async => const Right(tNumberTrivia));

        // act
        bloc.add(GetRandomNumberTriviaEvent());
        await untilCalled(random(any));

        // assert
        verify(random(const NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(random(any)).thenAnswer((_) async => const Right(tNumberTrivia));
        // assert later
        final expected = [
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetRandomNumberTriviaEvent());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails from server',
      () async {
        // arrange
        when(random(any)).thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(message: serverFailure),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetRandomNumberTriviaEvent());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails from cache',
      () async {
        // arrange
        when(random(any)).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(message: cacheFailure),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetRandomNumberTriviaEvent());
      },
    );
  });
}
