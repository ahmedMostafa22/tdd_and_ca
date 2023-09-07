import 'dart:convert';

import 'package:clean_arch_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const numberTriviaModel = NumberTriviaModel(number: 1, text: 'test');
  test('NumberTriviaModel should be a subclass of NumberTrivia entity',
      () => expect(numberTriviaModel, isA<NumberTrivia>()));

  group('fromJson', () {
    test(
        'should return NumberTriviaModel when passing integer number in the JSON',
        () {
      //Arrange
      Map<String, dynamic> trivia = jsonDecode(fixture('trivia.json'));

      //Act
      final nTM = NumberTriviaModel.fromJson(trivia);

      //Assert
      expect(nTM, numberTriviaModel);
    });

    test(
        'should return NumberTriviaModel when passing double number in the JSON',
        () {
      //Arrange
      Map<String, dynamic> trivia = jsonDecode(fixture('trivia_double.json'));

      //Act
      final nTM = NumberTriviaModel.fromJson(trivia);

      //Assert
      expect(nTM, numberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return JSON containing proper data', () {
      //Act
      Map<String, dynamic> json = numberTriviaModel.toJson();

      //Assert
      expect(json, {"text": "test", "number": 1});
    });
  });
}
