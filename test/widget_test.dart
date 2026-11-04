import 'package:flutter_test/flutter_test.dart';
import 'package:product_search_app/main.dart';

void main() {
  testWidgets('App renders search bar and product search title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProductSearchApp());

    expect(find.text('🔍 Product Search & Filter'), findsOneWidget);
    expect(find.text('Search products by name...'), findsOneWidget);
  });
}
