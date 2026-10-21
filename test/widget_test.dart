import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_bedrock_resources/app.dart';


void main() {
  testWidgets('app opens and shows the home screen', (tester) async {
    await tester.pumpWidget(const CprCommunityApp());

    expect(find.text('CPR Community'), findsOneWidget);
    expect(find.text('الوصول السريع'), findsOneWidget);
    expect(find.text('الرئيسية'), findsOneWidget);
  });
}
