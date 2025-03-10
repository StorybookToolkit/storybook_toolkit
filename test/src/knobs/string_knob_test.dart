import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/components/knob_list_tile.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

class MockKnobsNotifier extends Mock implements KnobsNotifier {}

void main() {
  group('StringKnobValue', () {
    group('build', () {
      test('returns a StringKnobWidget', () {
        final knobValue = StringKnobValue(value: 'value');

        expect(
          knobValue.build(
            label: 'label',
            description: 'description',
            enabled: true,
            nullable: false,
          ),
          isA<StringKnobWidget>().having(
            (w) => w.value,
            'value',
            'value',
          ),
        );
      });
    });
  });

  group('StringKnobWidget', () {
    const label = 'LABEL';
    late KnobsNotifier knobsNotifier;

    setUp(() {
      knobsNotifier = MockKnobsNotifier();
    });

    Widget buildSubject() => ChangeNotifierProvider.value(
          value: knobsNotifier,
          child: const MaterialApp(
            home: Scaffold(
              body: StringKnobWidget(
                label: label,
                description: 'description',
                enabled: true,
                nullable: false,
                value: 'value',
              ),
            ),
          ),
        );

    testWidgets('contains KnobListTile', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byType(KnobListTile), findsOneWidget);
    });

    testWidgets('inputting text updates knob', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(find.byType(TextFormField), 'test');

      verify(() => knobsNotifier.update(label, 'test')).called(1);
    });
  });
}
