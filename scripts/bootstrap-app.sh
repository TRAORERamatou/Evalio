#!/usr/bin/env bash
# Creates the Flutter app skeleton. Run once, from the repository root.
set -euo pipefail
cd "$(dirname "$0")/.."

command -v flutter >/dev/null || { echo "Flutter is not installed"; exit 1; }
[ -e app/pubspec.yaml ] && { echo "app/ already exists, nothing done"; exit 1; }

flutter create --platforms=android --org bf.evalio --project-name evalio app
cd app

flutter pub add flutter_bloc bloc bloc_concurrency equatable get_it go_router \
  dio flutter_secure_storage shared_preferences socket_io_client uuid
flutter pub add --dev bloc_test mocktail

# Release builds need the network permission (flutter create only adds it for debug).
sed -i 's|<application|<uses-permission android:name="android.permission.INTERNET"/>\n    <application|' \
  android/app/src/main/AndroidManifest.xml

mkdir -p lib/core/{di,router,network,error,storage,theme,widgets}
for f in auth courses quizzes attempts focus grading results live; do
  mkdir -p "lib/features/$f"/{domain,data,presentation}
done
find lib -type d -empty -exec touch {}/.gitkeep \;

cat > lib/core/config.dart <<'DART'
const apiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:3000/api/v1',
);
DART

cat > lib/app.dart <<'DART'
import 'package:flutter/material.dart';

class EvalioApp extends StatelessWidget {
  const EvalioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evalio',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF1B5E8C)),
      home: const Scaffold(body: Center(child: Text('Evalio'))),
    );
  }
}
DART

cat > lib/main.dart <<'DART'
import 'package:flutter/material.dart';

import 'app.dart';

void main() => runApp(const EvalioApp());
DART

cat > test/widget_test.dart <<'DART'
import 'package:evalio/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the application name', (tester) async {
    await tester.pumpWidget(const EvalioApp());
    expect(find.text('Evalio'), findsOneWidget);
  });
}
DART

dart format .
flutter analyze
flutter test
echo "App skeleton ready."
