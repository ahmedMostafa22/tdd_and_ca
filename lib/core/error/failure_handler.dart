import 'package:clean_arch_and_tdd/core/error/failure.dart';
import 'package:clean_arch_and_tdd/core/utils/input_converter.dart';

const String unknownFailure = 'Unknown Failure';
const String serverFailure = 'Server Failure';
const String cacheFailure = 'Cache Failure';
const String invalidInput =
    'Invalid Input - The number must be a positive integer or zero.';

String failureHandler(Failure failure) {
  if (failure is ServerFailure) return serverFailure;
  if (failure is CacheFailure) return cacheFailure;
  if (failure is InvalidInputFailure) return invalidInput;

  return unknownFailure;
}
