import 'package:clean_arch_and_tdd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late InternetConnectionChecker internetConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    internetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(internetConnectionChecker);
  });

  group('is connected', () {
    test(
        'should forward true value when the internetConnectionChecker.hasConnection forward true',
        () async {
      //Arrange
      when(internetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);

      //Act
      final result = await networkInfoImpl.isConnected;
      //Assert
      expect(result, true);
      verify(internetConnectionChecker.hasConnection);
      verifyNoMoreInteractions(internetConnectionChecker);
    });
  });

  group('is not connected', () {
    test(
        'should forward false value when the internetConnectionChecker.hasConnection forward false ',
        () async {
      //Arrange
      when(internetConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);

      //Act
      final result = await networkInfoImpl.isConnected;
      //Assert
      expect(result, false);
      verify(internetConnectionChecker.hasConnection);
      verifyNoMoreInteractions(internetConnectionChecker);
    });
  });
}
