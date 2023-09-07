import 'package:clean_arch_and_tdd/core/error/exceptions.dart';
import 'package:clean_arch_and_tdd/core/error/failure.dart';
import 'package:clean_arch_and_tdd/core/network/network_info.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import '../data_sources/number_tirivia_remote_datasource.dart';

class NumberTriviaRepositoryImplementation implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImplementation(
      {required this.numberTriviaLocalDataSource,
      required this.numberTriviaRemoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) =>
      _getTrivia(
          () => numberTriviaRemoteDataSource.getConcreteNumberTrivia(number));

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() =>
      _getTrivia(() => numberTriviaRemoteDataSource.getRandomNumberTrivia());

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTriviaModel> Function() getTrivia) async {
    try {
      late final NumberTriviaModel result;
      if (await networkInfo.isConnected) {
        result = await getTrivia();
        numberTriviaLocalDataSource.cacheNumberTrivia(result);
      } else {
        result = await numberTriviaLocalDataSource.getLatestNumberTrivia();
      }
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
