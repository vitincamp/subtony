import 'package:flutter_test/flutter_test.dart';
import 'package:viacep_app/main.dart';

void main() {
  testWidgets('ViaCEP app renders the consultation screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ViaCepApp());

    expect(find.text('Consulta de CEP'), findsWidgets);
    expect(find.text('Logradouro'), findsOneWidget);
    expect(find.text('Bairro'), findsOneWidget);
    expect(find.text('Localidade'), findsOneWidget);
    expect(find.text('UF'), findsOneWidget);
  });
}
