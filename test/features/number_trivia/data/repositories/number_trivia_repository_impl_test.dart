import 'package:clean_arch_and_tdd/core/error/exceptions.dart';
import 'package:clean_arch_and_tdd/core/error/failure.dart';
import 'package:clean_arch_and_tdd/core/network/network_info.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/data_sources/number_tirivia_remote_datasource.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  late NumberTriviaRepositoryImplementation numberTriviaRepo;
  late NumberTriviaRemoteDataSource remoteDataSource;
  late NumberTriviaLocalDataSource localDataSource;
  late NetworkInfo networkInfo;
  const tNumberTriviaModel = NumberTriviaModel(text: 'test', number: 1);
  const tNumberTrivia = tNumberTriviaModel;

  setUp(() {
    remoteDataSource = MockNumberTriviaRemoteDataSource();
    localDataSource = MockNumberTriviaLocalDataSource();
    networkInfo = MockNetworkInfo();
    numberTriviaRepo = NumberTriviaRepositoryImplementation(
        numberTriviaLocalDataSource: localDataSource,
        numberTriviaRemoteDataSource: remoteDataSource,
        networkInfo: networkInfo);
  });

  tearDown(() {});
  group('Concrete NumberTrivia', () {
    group('When Online', () {
      setUp(() => when(networkInfo.isConnected).thenAnswer((_) async => true));

      test(
          'should get NumberTrivia from RemoteDataSource when user has internet connection',
          () async {
        //Arrange
        when(remoteDataSource.getConcreteNumberTrivia(tNumberTrivia.number))
            .thenAnswer((_) async => tNumberTrivia);

        //Act
        final result = await numberTriviaRepo
            .getConcreteNumberTrivia(tNumberTrivia.number);

        //Assert
        expect(result, equals(const Right(tNumberTrivia)));
        verify(networkInfo.isConnected);
        verify(remoteDataSource.getConcreteNumberTrivia(tNumberTrivia.number));
        verifyNoMoreInteractions(remoteDataSource);
        verifyNoMoreInteractions(networkInfo);
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //Arrange
        when(remoteDataSource.getConcreteNumberTrivia(tNumberTrivia.number))
            .thenAnswer((_) async => tNumberTrivia);

        //Act
        await numberTriviaRepo.getConcreteNumberTrivia(tNumberTrivia.number);

        //Assert
        verify(networkInfo.isConnected);
        verify(remoteDataSource.getConcreteNumberTrivia(tNumberTrivia.number));
        verify(localDataSource.cacheNumberTrivia(tNumberTrivia));
        verifyNoMoreInteractions(localDataSource);
        verifyNoMoreInteractions(remoteDataSource);
        verifyNoMoreInteractions(networkInfo);
      });

      test(
          'should return failure when the call to remote data source is unsuccessful',
          () async {
        //Arrange
        when(remoteDataSource.getConcreteNumberTrivia(tNumberTrivia.number))
            .thenThrow(ServerException());

        //Act
        final result = await numberTriviaRepo
            .getConcreteNumberTrivia(tNumberTrivia.number);

        //Assert
        expect(result, Left(ServerFailure()));
        verify(networkInfo.isConnected);
        verify(remoteDataSource.getConcreteNumberTrivia(tNumberTrivia.number));
        verifyZeroInteractions(localDataSource);
        verifyNoMoreInteractions(networkInfo);
        verifyNoMoreInteractions(remoteDataSource);
      });
    });

    group('When Offline', () {
      setUp(() => when(networkInfo.isConnected).thenAnswer((_) async => false));
      test(
          'should return NumberTrivia from LocalDataSource when user has no internet connection',
          () async {
        //Arrange
        when(localDataSource.getLatestNumberTrivia())
            .thenAnswer((_) async => tNumberTrivia);

        //Act
        final result = await numberTriviaRepo
            .getConcreteNumberTrivia(tNumberTrivia.number);

        //Assert
        expect(result, equals(const Right(tNumberTrivia)));
        verify(networkInfo.isConnected);
        verify(localDataSource.getLatestNumberTrivia());
        verifyZeroInteractions(remoteDataSource);
        verifyNoMoreInteractions(localDataSource);
        verifyNoMoreInteractions(networkInfo);
      });

      test(
          'should return CacheFailure from LocalDataSource when there is no cache present',
          () async {
        //Arrange
        when(localDataSource.getLatestNumberTrivia())
            .thenThrow(CacheException());

        //Act
        final result = await numberTriviaRepo
            .getConcreteNumberTrivia(tNumberTrivia.number);

        //Assert
        expect(result, equals(Left(CacheFailure())));
        verify(networkInfo.isConnected);
        verify(localDataSource.getLatestNumberTrivia());
        verifyZeroInteractions(remoteDataSource);
        verifyNoMoreInteractions(localDataSource);
        verifyNoMoreInteractions(networkInfo);
      });
    });
  });

  group('Random NumberTrivia', () {
    group('When Online', () {
      setUp(() => when(networkInfo.isConnected).thenAnswer((_) async => true));

      test(
          'should get NumberTrivia from RemoteDataSource when user has internet connection',
          () async {
        //Arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTrivia);

        //Act
        final result = await numberTriviaRepo.getRandomNumberTrivia();

        //Assert
        expect(result, equals(const Right(tNumberTrivia)));
        verify(networkInfo.isConnected);
        verify(remoteDataSource.getRandomNumberTrivia());
        verifyNoMoreInteractions(remoteDataSource);
        verifyNoMoreInteractions(networkInfo);
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //Arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTrivia);

        //Act
        await numberTriviaRepo.getRandomNumberTrivia();

        //Assert
        verify(networkInfo.isConnected);
        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(tNumberTrivia));
        verifyNoMoreInteractions(localDataSource);
        verifyNoMoreInteractions(remoteDataSource);
        verifyNoMoreInteractions(networkInfo);
      });

      test(
          'should return failure when the call to remote data source is unsuccessful',
          () async {
        //Arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        //Act
        final result = await numberTriviaRepo.getRandomNumberTrivia();

        //Assert
        expect(result, Left(ServerFailure()));
        verify(networkInfo.isConnected);
        verify(remoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(localDataSource);
        verifyNoMoreInteractions(networkInfo);
        verifyNoMoreInteractions(remoteDataSource);
      });
    });

    group('When Offline', () {
      setUp(() => when(networkInfo.isConnected).thenAnswer((_) async => false));
      test(
          'should return NumberTrivia from LocalDataSource when user has no internet connection',
          () async {
        //Arrange
        when(localDataSource.getLatestNumberTrivia())
            .thenAnswer((_) async => tNumberTrivia);

        //Act
        final result = await numberTriviaRepo.getRandomNumberTrivia();

        //Assert
        expect(result, equals(const Right(tNumberTrivia)));
        verify(networkInfo.isConnected);
        verify(localDataSource.getLatestNumberTrivia());
        verifyZeroInteractions(remoteDataSource);
        verifyNoMoreInteractions(localDataSource);
        verifyNoMoreInteractions(networkInfo);
      });

      test(
          'should return CacheFailure from LocalDataSource when there is no cache present',
          () async {
        //Arrange
        when(localDataSource.getLatestNumberTrivia())
            .thenThrow(CacheException());

        //Act
        final result = await numberTriviaRepo.getRandomNumberTrivia();

        //Assert
        expect(result, equals(Left(CacheFailure())));
        verify(networkInfo.isConnected);
        verify(localDataSource.getLatestNumberTrivia());
        verifyZeroInteractions(remoteDataSource);
        verifyNoMoreInteractions(localDataSource);
        verifyNoMoreInteractions(networkInfo);
      });
    });
  });
}
