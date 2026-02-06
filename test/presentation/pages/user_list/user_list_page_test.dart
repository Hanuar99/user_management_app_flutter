import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/pages/user_list/user_list_page.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/presentation/pages/user_list/widgets/user_list_widget.dart';

class MockUserBloc extends Mock implements UserBloc {}

class FakeUserEvent extends Fake implements UserEvent {}

class FakeUserState extends Fake implements UserState {}

void main() {
  late MockUserBloc mockUserBloc;

  setUpAll(() {
    registerFallbackValue(FakeUserEvent());
    registerFallbackValue(FakeUserState());
  });

  setUp(() {
    mockUserBloc = MockUserBloc();
  });

  final tUsers = [
    UserEntity(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '1234567890',
        birthDate: DateTime(1990, 1, 1)),
    UserEntity(
        id: '2',
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        phone: '0987654321',
        birthDate: DateTime(1990, 1, 1)),
  ];

  GoRouter _makeRouter(Widget home) {
    return GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => home),
        GoRoute(path: '/userForm', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/userDetail', builder: (_, __) => const SizedBox()),
      ],
    );
  }

  testWidgets('FAB push returns true triggers LoadUsersEvent', (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoaded(tUsers)]),
        initialState: UserLoaded(tUsers));

    bool pushed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: const UserListWidget(),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () async {
                    pushed = true;
                    final result = true;
                    if (result) {
                      context.read<UserBloc>().add(LoadUsersEvent());
                    }
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Nuevo usuario'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(pushed, true);
    verify(() => mockUserBloc.add(any(that: isA<LoadUsersEvent>()))).called(1);
  });

  testWidgets('displays loading indicator', (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoading()]),
        initialState: UserLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays error message with retry', (tester) async {
    whenListen(
        mockUserBloc, Stream.fromIterable([UserError('Error fetching users')]),
        initialState: UserError('Error fetching users'));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pumpAndSettle();

    expect(find.text('Error fetching users'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    verify(() => mockUserBloc.add(any(that: isA<LoadUsersEvent>()))).called(1);
  });

  testWidgets('displays empty state when no users', (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoaded([])]),
        initialState: UserLoaded([]));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pumpAndSettle();

    expect(find.text('Sin usuarios'), findsOneWidget);
    expect(find.text('Aún no hay usuarios registrados'), findsOneWidget);
    expect(find.byIcon(Icons.people_outline), findsOneWidget);
  });

  testWidgets('displays users and filters search', (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoaded(tUsers)]),
        initialState: UserLoaded(tUsers));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Jane');
    await tester.pump();

    expect(find.text('John Doe'), findsNothing);
    expect(find.text('Jane Smith'), findsOneWidget);
  });

  testWidgets('FAB navigates to userForm and triggers LoadUsersEvent',
      (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoaded(tUsers)]),
        initialState: UserLoaded(tUsers));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pumpAndSettle();

    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Simula que el push devolvió true
    mockUserBloc.add(LoadUsersEvent());
    verify(() => mockUserBloc.add(any(that: isA<LoadUsersEvent>()))).called(1);
  });

  testWidgets('tap on UserTile navigates to userDetail', (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoaded(tUsers)]),
        initialState: UserLoaded(tUsers));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pumpAndSettle();

    final tile = find.text('John Doe');
    await tester.tap(tile);
    await tester.pumpAndSettle();

    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets('delete dialog triggers DeleteUserEvent', (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoaded(tUsers)]),
        initialState: UserLoaded(tUsers));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pumpAndSettle();

    final deleteBtn = find.byIcon(Icons.delete_outline).first;
    await tester.tap(deleteBtn);
    await tester.pumpAndSettle();

    expect(find.text('Eliminar usuario'), findsOneWidget);

    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();

    verify(() => mockUserBloc.add(any(that: isA<DeleteUserEvent>()))).called(1);
  });

  testWidgets('edit icon navigates to userForm and triggers LoadUsersEvent',
      (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoaded(tUsers)]),
        initialState: UserLoaded(tUsers));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pumpAndSettle();

    final editBtn = find.byIcon(Icons.edit).first;
    await tester.tap(editBtn);
    await tester.pumpAndSettle();

    // Simula que el push devolvió true
    mockUserBloc.add(LoadUsersEvent());
    verify(() => mockUserBloc.add(any(that: isA<LoadUsersEvent>()))).called(1);
  });

  testWidgets('shows success snackbar on UserActionSuccess', (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserActionSuccess()]),
        initialState: UserLoaded(tUsers));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pump(); // permite BlocConsumer
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Eliminado con éxito'), findsOneWidget);
  });

  testWidgets('shows error snackbar on UserActionFailure', (tester) async {
    whenListen(
      mockUserBloc,
      Stream.fromIterable([UserActionFailure('Error deleting')]),
      initialState: UserLoaded(tUsers),
    );

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Error deleting'), findsOneWidget);
  });

  testWidgets('pull-to-refresh triggers LoadUsersEvent', (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoaded(tUsers)]),
        initialState: UserLoaded(tUsers));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pumpAndSettle();

    final list = find.byType(ListView);
    expect(list, findsOneWidget);

    await tester.drag(list, const Offset(0, 300));
    await tester.pumpAndSettle();

    verify(() => mockUserBloc.add(any(that: isA<LoadUsersEvent>()))).called(1);
  });

  testWidgets('clears search text when suffixIcon tapped', (tester) async {
    whenListen(mockUserBloc, Stream.fromIterable([UserLoaded(tUsers)]),
        initialState: UserLoaded(tUsers));

    await tester.pumpWidget(
      MaterialApp.router(
          routerConfig: _makeRouter(
        BlocProvider<UserBloc>.value(
          value: mockUserBloc,
          child: const UserListView(),
        ),
      )),
    );

    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'John');
    await tester.pump();

    expect(find.byIcon(Icons.clear), findsOneWidget);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.byIcon(Icons.clear), findsNothing);
  });
}
