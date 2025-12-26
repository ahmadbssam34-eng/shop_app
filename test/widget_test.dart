import 'package:flutter_test/flutter_test.dart';
import 'package:gadget_market/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const GadgetMarketApp());
    await tester.pump(const Duration(milliseconds: 500));
    
    // Verify app title is present
    expect(find.text('Gadget Market'), findsWidgets);
  });
}
