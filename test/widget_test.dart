import 'package:flutter_test/flutter_test.dart';
// ignore: avoid_relative_lib_imports
import '../lib/app.dart';

void main() {
  testWidgets('app opens and shows the home screen', (tester) async {
    await tester.pumpWidget(const CprCommunityApp());

    expect(find.text('CPR Community'), findsOneWidget);
    expect(find.text('الوصول السريع'), findsOneWidget);
    expect(find.text('الرئيسية'), findsOneWidget);
  });
}
