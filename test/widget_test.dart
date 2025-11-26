// Test básico de la aplicación Cremosos E-commerce

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cremosos_ecommerce/main.dart';

void main() {
  testWidgets('Cremosos app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: CremososApp()));

    // Verify that the app loads with the home screen
    expect(find.text('Cremosos'), findsWidgets);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Productos'), findsOneWidget);
    expect(find.text('Carrito'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });
}
