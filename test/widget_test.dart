import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codequest/presentation/widgets/game/codequest_certificate_card.dart';

void main() {
  testWidgets('CodeQuestCertificateCard renders student name and language',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: CodeQuestCertificateCard(
              studentName: 'Gokul G',
              level: 5,
              rank: 'Code Warrior',
              languageId: 'python',
            ),
          ),
        ),
      ),
    );

    // Verify key certificate texts
    expect(find.text('CERTIFICATE'), findsOneWidget);
    expect(find.text('OF COMPLETION'), findsOneWidget);
    expect(find.text('GOKUL G'), findsOneWidget);
    expect(find.text('LEVEL 5  •  CODE WARRIOR'), findsOneWidget);
    expect(find.text('CODEQUEST'), findsWidgets);
  });
}
