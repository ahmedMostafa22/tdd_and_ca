import 'dart:convert';
import 'dart:io';

import 'package:clean_arch_and_tdd/core/error/exceptions.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_datasource_test.mocks.dart';

const String cachedNTKey = 'CACHED_NUMBER_TRIVIA';
@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl localDataSourceImpl;
  late MockSharedPreferences preferences;
  final numberTriviaModel =
      NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));

  setUp(() {
    preferences = MockSharedPreferences();
    localDataSourceImpl = NumberTriviaLocalDataSourceImpl(preferences);
  });
  group('GetLatestNumberTrivia', () {
    test(
        'should get the latest cached the NumberTriviaModel from SharedPreferences from Encoded Json',
        () async {
      //Arrange
      when(preferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      //Act
      final result = await localDataSourceImpl.getLatestNumberTrivia();

      //Assert
      expect(result, equals(numberTriviaModel));
      verify(preferences.getString(cachedNTKey));
      verifyNoMoreInteractions(preferences);
    });

    test('should throw CacheException when the SharedPreferences has no data',
        () async {
      //Arrange
      when(preferences.getString(any)).thenReturn(null);

      //Act
      final call = localDataSourceImpl.getLatestNumberTrivia;

      //Assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      verify(preferences.getString(cachedNTKey));
      verifyNoMoreInteractions(preferences);
    });
  });

  group('CacheNumberTrivia', () {
    test(
        'should Cache the NumberTriviaModel in the SharedPreferences when the encoded JSON is valid',
        () async {
      //Arrange
      when(preferences.setString(any, any)).thenAnswer((_) async => true);

      //Act
      await localDataSourceImpl.cacheNumberTrivia(numberTriviaModel);

      //Assert
      verify(preferences.setString(
          cachedNTKey, jsonEncode(numberTriviaModel.toJson())));
      verifyNoMoreInteractions(preferences);
    });

    test(
        'should throw CacheException when the SharedPreferences fails to cache the NumberTrivia',
        () async {
      //Arrange
      when(preferences.setString(any, any))
          .thenAnswer((_) => Future.value(false));

      //Act
      call() => localDataSourceImpl.cacheNumberTrivia(numberTriviaModel);

      //Assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      verify(preferences.setString(
          cachedNTKey, jsonEncode(numberTriviaModel.toJson())));
      verifyNoMoreInteractions(preferences);
    });
  });
}
