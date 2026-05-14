import 'package:flutter_test/flutter_test.dart';
import 'package:proto/app.dart';

void main() {
  testWidgets('Portfolio test', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.byType(PortfolioApp), findsOneWidget);
  });
}
