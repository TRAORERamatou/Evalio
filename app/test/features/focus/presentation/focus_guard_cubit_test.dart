import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:evalio/features/focus/domain/focus_event.dart';
import 'package:evalio/features/focus/domain/focus_monitor.dart';
import 'package:evalio/features/focus/presentation/focus_guard_cubit.dart';

class MockFocusMonitor extends Mock implements FocusMonitor {}

void main() {
  late MockFocusMonitor mockMonitor;

  setUp(() {
    mockMonitor = MockFocusMonitor();
  });

  blocTest<FocusGuardCubit, FocusGuardState>(
    'increments exitCount once per focus loss',
    build: () {
      when(() => mockMonitor.isSecure()).thenAnswer((_) async => true);
      when(() => mockMonitor.onFocusChanged()).thenAnswer(
        (_) =>
            Stream.fromIterable([const FocusEvent(hasFocus: false, timestampMs: 1)]),
      );
      return FocusGuardCubit(mockMonitor);
    },
    act: (cubit) => cubit.start(),
    expect: () => const [FocusGuardBlurred(1)],
    verify: (_) {
      verify(() => mockMonitor.isSecure()).called(1);
      verify(() => mockMonitor.onFocusChanged()).called(1);
    },
  );

  blocTest<FocusGuardCubit, FocusGuardState>(
    'emits focused when app regains focus',
    build: () {
      when(() => mockMonitor.isSecure()).thenAnswer((_) async => true);
      when(() => mockMonitor.onFocusChanged()).thenAnswer(
        (_) => Stream.fromIterable([
          const FocusEvent(hasFocus: false, timestampMs: 1),
          const FocusEvent(hasFocus: true, timestampMs: 2),
        ]),
      );
      return FocusGuardCubit(mockMonitor);
    },
    act: (cubit) => cubit.start(),
    expect: () => const [FocusGuardBlurred(1), FocusGuardFocused()],
  );

  blocTest<FocusGuardCubit, FocusGuardState>(
    'emits initial state when isSecure throws',
    build: () {
      when(() => mockMonitor.isSecure()).thenThrow(Exception('no secure'));
      when(
        () => mockMonitor.onFocusChanged(),
      ).thenAnswer((_) => Stream.fromIterable([]));
      return FocusGuardCubit(mockMonitor);
    },
    act: (cubit) => cubit.start(),
    expect: () => [],
  );

  test('close cancels the subscription', () async {
    when(() => mockMonitor.isSecure()).thenAnswer((_) async => true);
    when(
      () => mockMonitor.onFocusChanged(),
    ).thenAnswer((_) => Stream.fromIterable([]));

    final cubit = FocusGuardCubit(mockMonitor);
    await cubit.start();
    expect(cubit.exitCount, 0);

    await cubit.close();

    // Après close, le cubit est fermé et ne doit plus émettre.
    expect(cubit.isClosed, true);
  });
}
