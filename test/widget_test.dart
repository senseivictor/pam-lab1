import 'package:flutter_test/flutter_test.dart';
import 'package:conversie_moneda/main.dart';

void main() {
  testWidgets('Currency converter title smoke test', (WidgetTester tester) async {
    // 1. Build our app (Using CurrencyConverterApp instead of MyApp)
    await tester.pumpWidget(const CurrencyConverterApp());

    // 2. Verify that the title "Conversie monedă" is found
    expect(find.text('Conversie monedă'), findsOneWidget);
  });
}