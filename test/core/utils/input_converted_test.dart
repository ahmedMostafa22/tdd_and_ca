import 'package:clean_arch_and_tdd/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter converter;

  setUp(() => converter = InputConverter());

  test('should return int when entering a valid number int String', () {
    //Arrange
    String numberString = '1';

    //Act
    final result = converter.stringToUnsignedInteger(numberString);

    //Assert
    expect(result, const Right(1));
  });

  test('should return int when entering a valid number double in String', () {
    //Arrange
    String numberString = '1.0';

    //Act
    final result = converter.stringToUnsignedInteger(numberString);

    //Assert
    expect(result, Left(InvalidInputFailure()));
  });

  test('should return int when entering a valid negative number in String', () {
    //Arrange
    String numberString = '-1';

    //Act
    final result = converter.stringToUnsignedInteger(numberString);

    //Assert
    expect(result, Left(InvalidInputFailure()));
  });

  test(
      'should return InvalidInputFailure when entering an invalid number in String',
      () {
    //Arrange
    String numberString = '-qwe1';

    //Act
    final result = converter.stringToUnsignedInteger(numberString);

    //Assert
    expect(result, Left(InvalidInputFailure()));
  });
}
