import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/presentation/blocs/user_form/user_form_bloc.dart';
import 'package:user_management_app/presentation/pages/user_form/user_form_page.dart';

class MockUserFormBloc extends MockBloc<UserFormEvent, UserFormState>
    implements UserFormBloc {}

void main() {
  late MockUserFormBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FirstNameChanged(''));
    registerFallbackValue(UserFormState());
  });

  setUp(() {
    mockBloc = MockUserFormBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<UserFormBloc>.value(
          value: mockBloc,
          child: const UserFormView(),
        ),
      ),
    );
  }

  final initialState = UserFormState(
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    birthDate: null,
    isValid: false,
    isSubmitting: false,
  );

  testWidgets('renders form fields correctly', (tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([initialState]),
      initialState: initialState,
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Información del usuario'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Guardar usuario'), findsOneWidget);
  });

  testWidgets('typing name triggers FirstNameChanged event', (tester) async {
    whenListen(mockBloc, Stream.fromIterable([initialState]),
        initialState: initialState);

    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre'), 'Juan');
    await tester.pump();

    verify(() => mockBloc.add(any(that: isA<FirstNameChanged>()))).called(1);
  });

  testWidgets('typing email triggers EmailChanged event', (tester) async {
    whenListen(mockBloc, Stream.fromIterable([initialState]),
        initialState: initialState);

    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@mail.com');
    await tester.pump();

    verify(() => mockBloc.add(any(that: isA<EmailChanged>()))).called(1);
  });

  testWidgets('shows validation errors from state', (tester) async {
    final errorState = initialState.copyWith(
      firstNameError: 'Campo requerido',
      emailError: 'Email inválido',
    );

    whenListen(
      mockBloc,
      Stream.fromIterable([errorState]),
      initialState: errorState,
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.text('Campo requerido'), findsOneWidget);
    expect(find.text('Email inválido'), findsOneWidget);
  });

  testWidgets('date picker triggers BirthDateChanged event', (tester) async {
    whenListen(mockBloc, Stream.fromIterable([initialState]),
        initialState: initialState);

    await tester.pumpWidget(makeTestableWidget());

    await tester.tap(find.text('Seleccionar fecha de nacimiento'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    verify(() => mockBloc.add(any(that: isA<BirthDateChanged>()))).called(1);
  });

  testWidgets('shows error snackbar when errorMessage present', (tester) async {
    final errorState = initialState.copyWith(errorMessage: 'Error al guardar');

    whenListen(mockBloc, Stream.fromIterable([errorState]),
        initialState: initialState);

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.text('Error al guardar'), findsOneWidget);
  });

  testWidgets('shows loading indicator when submitting', (tester) async {
    final loadingState = initialState.copyWith(isSubmitting: true);

    whenListen(mockBloc, Stream.fromIterable([loadingState]),
        initialState: loadingState);

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
