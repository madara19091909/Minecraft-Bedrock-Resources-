import 'package:flutter_test/flutter_test.dart';
import 'package:resource_pack_studio/main.dart';

void main() {
  testWidgets('Resource Pack Studio starts', (WidgetTester tester) async {
    await tester.pumpWidget(const ResourcePackStudioApp());
    expect(find.text('Resource Pack Studio'), findsOneWidget);
    expect(find.text('ابدأ بمكتبتك الخاصة'), findsOneWidget);
  });
}
