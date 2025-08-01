import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motofix_app/feature/auth/presentation/view/signup_page.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/register_view_model/egister_event.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';

// Mocks
class MockRegisterViewModel extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterViewModel {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockRegisterViewModel mockRegisterViewModel;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  setUp(() {
    mockRegisterViewModel = MockRegisterViewModel();
    registerFallbackValue(
      RegisterUserEvent(
        fullName: '',
        email: '',
        password: '',
        context: MockBuildContext(),
      ),
    );
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<RegisterViewModel>(
      create: (context) => mockRegisterViewModel,
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: const SignUpPage(),
      ),
    );
  }

  group('SignUpPage', () {
    const validPassword = 'Password@123';
    // A stable finder for the button that works whether it's loading or not.
    // It finds the single ElevatedButton on the page.
    final elevatedButtonFinder = find.byType(ElevatedButton);

    testWidgets(
        'shows validation errors when fields are empty and button is tapped',
        (tester) async {
      when(() => mockRegisterViewModel.state)
          .thenReturn(RegisterState.initial());
      await tester.pumpWidget(createWidgetUnderTest());

      // Scroll the button into view before tapping.
      await tester.ensureVisible(elevatedButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.tap(elevatedButtonFinder);
      await tester.pump();

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter an email'), findsOneWidget);
      expect(find.text('Please enter a password.'), findsOneWidget);
    });

    testWidgets('shows snackbar if terms are not agreed to', (tester) async {
      when(() => mockRegisterViewModel.state)
          .thenReturn(RegisterState.initial());
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), validPassword);
      await tester.enterText(find.byType(TextFormField).at(3), validPassword);

      // Scroll the button into view before tapping
      await tester.ensureVisible(elevatedButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(elevatedButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please agree to the terms and conditions.'),
          findsOneWidget);
    });

    testWidgets(
        'adds RegisterUserEvent when form is valid and terms are agreed',
        (tester) async {
      when(() => mockRegisterViewModel.state)
          .thenReturn(RegisterState.initial());
      await tester.pumpWidget(createWidgetUnderTest());

      const name = 'Test User';
      const email = 'test@example.com';

      await tester.enterText(find.byType(TextFormField).at(0), name);
      await tester.enterText(find.byType(TextFormField).at(1), email);
      await tester.enterText(find.byType(TextFormField).at(2), validPassword);
      await tester.enterText(find.byType(TextFormField).at(3), validPassword);

      // Dismiss keyboard to prevent it from covering the button/checkbox
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      // Ensure Checkbox and Button are visible before interacting
      await tester.ensureVisible(find.byType(Checkbox));
      await tester.tap(find.byType(Checkbox));
      await tester.ensureVisible(elevatedButtonFinder);
      await tester.tap(elevatedButtonFinder);
      await tester.pump();

      verify(() => mockRegisterViewModel.add(any(
              that: isA<RegisterUserEvent>()
                  .having((e) => e.fullName, 'fullName', name)
                  .having((e) => e.email, 'email', email)
                  .having((e) => e.password, 'password', validPassword))))
          .called(1);
    });

    // testWidgets('shows terms and conditions dialog on link tap',
    //     (tester) async {
    //   when(() => mockRegisterViewModel.state)
    //       .thenReturn(RegisterState.initial());
    //   await tester.pumpWidget(createWidgetUnderTest());

    //   final termsFinder = find.text('Terms and Conditions');

    //   // Scroll the link into view before tapping
    //   await tester.ensureVisible(termsFinder);
    //   await tester.pumpAndSettle();

    //   await tester.tap(termsFinder);
    //   await tester.pumpAndSettle();

    //   expect(find.byType(AlertDialog), findsOneWidget);
    // });

    testWidgets(
        'shows CircularProgressIndicator and disables button on loading',
        (tester) async {
      // Arrange: Set up the BLoC to emit the loading state
      whenListen(
        mockRegisterViewModel,
        Stream.fromIterable([
          const RegisterState(isLoading: true),
        ]),
        initialState: RegisterState.initial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      // pump again to process the new state from the stream
      await tester.pump();

      // Assert:
      // 1. Check that the progress indicator is now visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // 2. The text "SIGN UP" should no longer be present
      expect(find.text('SIGN UP'), findsNothing);
      // 3. Find the button by its type and check if its onPressed is null
      final button = tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(button.onPressed, isNull, reason: "Button should be disabled");
    });
  });
}
