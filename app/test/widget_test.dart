import 'package:evalio/app.dart';
import 'package:evalio/core/di/get_it.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    setupLocator();
  });

  testWidgets('shows the focus spike screen', (tester) async {
    await tester.pumpWidget(const EvalioApp());
    expect(find.text('Spike T04 - Focus / FLAG_SECURE'), findsOneWidget);
  });
}
