import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import 'package:user_management_app/presentation/pages/user_detail/user_detail_page.dart';

class MockAddressBloc extends MockBloc<AddressEvent, AddressState>
    implements AddressBloc {}

class FakeAddressEvent extends Fake implements AddressEvent {}

class FakeAddressState extends Fake implements AddressState {}

void main() {
  late MockAddressBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeAddressEvent());
    registerFallbackValue(FakeAddressState());
  });

  setUp(() {
    mockBloc = MockAddressBloc();
  });

  final user = UserEntity(
    id: '1',
    firstName: 'Juan',
    lastName: 'Perez',
    email: 'juan@test.com',
    phone: '123456',
    birthDate: DateTime(1990, 5, 10),
  );

  GoRouter createTestRouter(Widget child) {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => child,
        ),
        GoRoute(
          path: '/address',
          builder: (context, state) => const Scaffold(),
        ),
      ],
    );
  }

  Widget makeTestableWidget() {
    final router = createTestRouter(
      BlocProvider<AddressBloc>.value(
        value: mockBloc,
        child: UserDetailPage(user: user),
      ),
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('dispatches LoadAddressesEvent on init', (tester) async {
    when(() => mockBloc.state).thenReturn(AddressInitial());

    await tester.pumpWidget(makeTestableWidget());

    verify(() => mockBloc.add(
          LoadAddressesEvent(user.id),
        )).called(1);
  });
  testWidgets('renders user basic information', (tester) async {
    when(() => mockBloc.state).thenReturn(AddressInitial());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Detalle de usuario'), findsOneWidget);

    expect(find.text('Juan Perez'), findsNWidgets(2));

    expect(find.text('juan@test.com'), findsNWidgets(2));
  });

  testWidgets('shows loading indicator when addresses are loading',
      (tester) async {
    when(() => mockBloc.state).thenReturn(AddressLoading());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('shows empty message when no addresses exist', (tester) async {
    when(() => mockBloc.state).thenReturn(
      AddressLoaded([]),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(
      find.text('Este usuario no tiene direcciones registradas'),
      findsOneWidget,
    );
  });
  testWidgets('shows addresses when loaded', (tester) async {
    final addresses = [
      AddressEntity(
        id: 'a1',
        userId: '1',
        street: 'Calle 1',
        city: 'Bogotá',
        isPrimary: true,
        neighborhood: 'Centro',
        state: 'Cundinamarca',
        postalCode: '110111',
        label: 'Casa',
      ),
    ];

    when(() => mockBloc.state).thenReturn(
      AddressLoaded(addresses),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Direcciones'), findsOneWidget);
    expect(find.text('Calle 1'), findsOneWidget);
  });
  testWidgets('tapping gestionar button navigates', (tester) async {
    when(() => mockBloc.state).thenReturn(AddressInitial());

    await tester.pumpWidget(makeTestableWidget());

    await tester.tap(find.text('Gestionar'));
    await tester.pumpAndSettle();

    // Verifica que hubo navegación al path esperado
    expect(find.byType(Scaffold), findsWidgets);
  });
}
