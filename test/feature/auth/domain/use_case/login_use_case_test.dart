import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motofix_app/core/error/failure.dart';
import 'package:motofix_app/feature/auth/domain/use_case/login_use_case.dart';

import 'repository_mock.dart';
import 'token_mock.dart';

void main() {
  late MockRepository repository;
  late TokenMockUser tokenSharedPrefs;
  late UserLoginUseCase usecase;

  setUp(() {
    repository = MockRepository();
    tokenSharedPrefs = TokenMockUser();
    usecase = UserLoginUseCase(
      userRepository: repository,
      tokenSharedPrefs: tokenSharedPrefs,
    );
  });

  test(
    "should call the [StudentRepo.login] with correst username and password [binod,binod123]",
    () async {
      when(() => repository.loginUser(any(), any())).thenAnswer((
        invocation,
      ) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if (email == 'dipendra@gmail.com' && password == 'Password@123') {
          return Future.value(const Right('token'));
        } else {
          return Future.value(
            const Left(
              ApiFailure(
                  message: 'Invalid username or password', statusCode: 500),
            ),
          );
        }
      });

      when(
        () => tokenSharedPrefs.saveToken(any()),
      ).thenAnswer((_) async => Right(null));

      final result = await usecase(
        LoginParams(email: "dipendra@gmail.com", password: "Password@123"),
      );

      expect(result, Right('token'));

      verify(() => repository.loginUser(any(), any())).called(1);
      verify(() => tokenSharedPrefs.saveToken(any())).called(1);

      verifyNoMoreInteractions(repository);
      verifyNoMoreInteractions(tokenSharedPrefs);
    },
  );

  tearDown(() {
    reset(repository);
    reset(tokenSharedPrefs);
  });
}
