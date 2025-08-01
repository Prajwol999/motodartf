// test/feature/auth/presentation/view/signin_page_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motofix_app/feature/auth/presentation/view/signin_page.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';

// Use MockBloc from bloc_test for better integration.
class MockLoginViewModel extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

void main() {
  late MockLoginViewModel mockLoginViewModel;

  // This setup runs before each test.
  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    // Register a fallback value for our event because we will use `verify` with `any()`
    // or a matcher. This is required by mocktail.
    registerFallbackValue(
      LoginWithEmailAndPassword(
        context: MockBuildContext(), // A mock context is fine here
        email: '',
        password: '',
      ),
    );
  });

  // A helper function to build the widget tree for our tests.
  Widget createWidgetUnderTest() {
    return BlocProvider<LoginViewModel>(
      create: (context) => mockLoginViewModel,
      child: const MaterialApp(
        home: SignInPage(),
      ),
    );
  }

  group('SignInPage', () {
    // Test 1: Ensure the initial UI renders correctly.
    testWidgets('renders initial UI elements correctly', (tester) async {
      // Arrange: Set the initial state of the BLoC.
      when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());

      // Act: Pump the widget.
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert: Check for key widgets.
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      // Use the correct case for the button text.
      expect(find.widgetWithText(ElevatedButton, 'SIGN IN'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    // Test 2: Test the form validation for empty fields.
    testWidgets('shows validation errors when sign in is tapped with empty fields',
            (tester) async {
          // Arrange
          when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
          await tester.pumpWidget(createWidgetUnderTest());

          // Act: Tap the sign-in button without entering any text.
          await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));
          await tester.pump(); // pump() to trigger the validation and rebuild.

          // Assert: Check for the correct validation messages.
          expect(find.text('Please enter your email'), findsOneWidget);
          expect(find.text('Please enter your password'), findsOneWidget);
        });

    // Test 3: Test the interaction with the BLoC when the form is valid.
    testWidgets('adds LoginWithEmailAndPassword event when form is valid',
            (tester) async {
          // Arrange
          when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
          await tester.pumpWidget(createWidgetUnderTest());

          const email = 'test@example.com';
          const password = 'password123';

          // Act: Enter valid text and tap the button.
          await tester.enterText(find.byType(TextFormField).at(0), email);
          await tester.enterText(find.byType(TextFormField).at(1), password);
          await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));
          await tester.pump();

          // Assert: Verify that the correct event was added to the BLoC.
          // We use a matcher to check that the event has the correct email and password.
          verify(() => mockLoginViewModel.add(any(that: isA<LoginWithEmailAndPassword>()
              .having((e) => e.email, 'email', email)
              .having((e) => e.password, 'password', password))))
              .called(1);
        });
  });
}

// A simple mock for BuildContext to satisfy the event constructor.
class MockBuildContext extends Mock implements BuildContext {}