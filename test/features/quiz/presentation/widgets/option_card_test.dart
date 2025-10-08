import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_learning/features/quiz/presentation/widgets/option_card.dart';

void main() {
  testWidgets('OptionCard displays option text', (WidgetTester tester) async {
    // Arrange
    const optionText = 'Test Option';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionCard(
            option: optionText,
            isSelected: false,
            onTap: () {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.text(optionText), findsOneWidget);
  });

  testWidgets('OptionCard shows selection indicator when selected',
      (WidgetTester tester) async {
    // Arrange
    const optionText = 'Test Option';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionCard(
            option: optionText,
            isSelected: true,
            onTap: () {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.byIcon(Icons.circle), findsOneWidget);
  });

  testWidgets('OptionCard calls onTap when tapped',
      (WidgetTester tester) async {
    // Arrange
    bool tapped = false;
    const optionText = 'Test Option';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionCard(
            option: optionText,
            isSelected: false,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(OptionCard));
    await tester.pump();

    // Assert
    expect(tapped, true);
  });
}

