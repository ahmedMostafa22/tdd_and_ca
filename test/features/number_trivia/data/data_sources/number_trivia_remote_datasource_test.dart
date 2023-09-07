import 'dart:io';
import 'package:clean_arch_and_tdd/core/error/exceptions.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/data_sources/number_tirivia_remote_datasource.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_datasource_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;
  late MockClient client;
  const numberTriviaModel = NumberTriviaModel(number: 1, text: 'test');
  final numberTriviaUrl =
      Uri.parse('http://numbersapi.com/${numberTriviaModel.number}');
  final randomNumberTriviaUrl = Uri.parse('http://numbersapi.com/random');

  setUp(() {
    client = MockClient();
    remoteDataSourceImpl = NumberTriviaRemoteDataSourceImpl(client);
  });

  void setUpMockHttpClientSuccess200() {
    when(client.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(client.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => Response('Something went wrong', 404),
    );
  }

  group('GetConcreteNumberTrivia', () {
    test('Should fetch and return a NumberTriviaModel when calling the API',
        () async {
      //Arrange
      setUpMockHttpClientSuccess200();

      //Act
      final result = await remoteDataSourceImpl
          .getConcreteNumberTrivia(numberTriviaModel.number);

      //Assert
      expect(result, isA<NumberTriviaModel>());
      verify(client
          .get(numberTriviaUrl, headers: {'content-type': 'application/json'}));
      verifyNoMoreInteractions(client);
    });

    test('Should throw ServerException and when the API return status code 404',
        () async {
      //Arrange
      setUpMockHttpClientFailure404();

      //Act
      call() => remoteDataSourceImpl
          .getConcreteNumberTrivia(numberTriviaModel.number);

      //Assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      verify(client
          .get(numberTriviaUrl, headers: {'content-type': 'application/json'}));
      verifyNoMoreInteractions(client);
    });
  });

  group('GetRandomNumberTrivia', () {
    test(
        'Should fetch and return a NumberTriviaModel with random number when calling the API',
        () async {
      //Arrange
      setUpMockHttpClientSuccess200();

      //Act
      final result = await remoteDataSourceImpl.getRandomNumberTrivia();

      //Assert
      expect(result, isA<NumberTriviaModel>());
      verify(client.get(randomNumberTriviaUrl,
          headers: {'content-type': 'application/json'}));
      verifyNoMoreInteractions(client);
    });

    test('Should throw ServerException and when the API return status code 404',
        () async {
      //Arrange
      setUpMockHttpClientFailure404();

      //Act
      call() => remoteDataSourceImpl.getRandomNumberTrivia();

      //Assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      verify(client.get(randomNumberTriviaUrl,
          headers: {'content-type': 'application/json'}));
      verifyNoMoreInteractions(client);
    });
  });
}
