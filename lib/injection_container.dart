import 'package:clean_arch_and_tdd/core/network/network_info.dart';
import 'package:clean_arch_and_tdd/core/utils/input_converter.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/data_sources/number_tirivia_remote_datasource.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch_and_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';

final sl = GetIt.instance;
Future<void> init() async {
  initFeatures();
  initCore();
  await initExternal();
}

void initFeatures() {
  //BLoC
  sl.registerFactory(() => NumberTriviaBloc(sl(), sl(), sl()));

  //Use Cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImplementation(
          numberTriviaLocalDataSource: sl(),
          numberTriviaRemoteDataSource: sl(),
          networkInfo: sl()));

  //Data Sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(sl()));
}

void initCore() {
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

Future<void> initExternal() async {
  sl.registerLazySingleton(() => InternetConnectionChecker());
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => Client());
}

//Init from top to bottom (start with bloc and finish with data source)
