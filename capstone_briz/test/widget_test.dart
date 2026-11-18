
import 'package:flutter_test/flutter_test.dart';
import 'package:capstone_briz/main.dart';

void main() {
  testWidgets('App navigation loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SchoolEventRsvpApp());

    expect(find.text('Campus Events'), findsOneWidget);
    expect(find.text('My Events'), findsOneWidget);
    expect(find.text('Discover what is happening around campus.'), findsOneWidget);
  });
}
