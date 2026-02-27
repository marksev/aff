import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_affirmations/main.dart';

void main() {
  setUp(() {
    // Provide an empty backing store for SharedPreferences in tests.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App renders home screen with categories',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DailyAffirmationsApp());
    await tester.pumpAndSettle();

    // Verify home screen title is shown
    expect(find.text('Daily Affirmations'), findsOneWidget);

    // Verify all 10 categories are shown
    expect(find.text('Self Love'), findsOneWidget);
    expect(find.text('Confidence'), findsOneWidget);
    expect(find.text('Success'), findsOneWidget);
    expect(find.text('Wealth'), findsOneWidget);
    expect(find.text('Health'), findsOneWidget);
    expect(find.text('Motivation'), findsOneWidget);
    expect(find.text('Gratitude'), findsOneWidget);
    expect(find.text('Positivity'), findsOneWidget);
    expect(find.text('Relationships'), findsOneWidget);
    expect(find.text('Discipline'), findsOneWidget);
  });
}
