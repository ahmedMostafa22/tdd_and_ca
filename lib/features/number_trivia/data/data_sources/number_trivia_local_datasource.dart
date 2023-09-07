import 'dart:convert';

import 'package:clean_arch_and_tdd/core/error/exceptions.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the latest cached [NumberTriviaModel] when the user had internet connection.
  ///
  /// Throws a [CacheException] if no cached data exist.
  Future<NumberTriviaModel> getLatestNumberTrivia();

  /// Store the latest cached [NumberTriviaModel] when the user had internet connection.
  ///
  /// Throws a [CacheException] for all error codes.
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

const String cachedNTKey = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences preferences;

  NumberTriviaLocalDataSourceImpl(this.preferences);

  @override
  Future<NumberTriviaModel> getLatestNumberTrivia() async {
    String? numberTriviaString = preferences.getString(cachedNTKey);
    if (numberTriviaString == null) throw CacheException();
    return NumberTriviaModel.fromJson(jsonDecode(numberTriviaString));
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) async {
    bool cached = await preferences.setString(
        cachedNTKey, jsonEncode(numberTriviaModel.toJson()));
    if (!cached) throw CacheException();
  }
}
