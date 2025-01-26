import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/common/constants.dart';
import 'package:storybook_toolkit/src/plugins/knobs/knobs_notifier.dart';
import 'package:storybook_toolkit/src/components/knob_list_tile.dart';
import 'package:storybook_toolkit/src/knobs/knobs.dart';

/// {@template bool_knob_value}
/// A knob value that allows the user to toggle a boolean value.
///
/// See also:
/// * [BooleanKnobWidget], which is the widget that displays the knob.
/// {@endtemplate}
class BoolKnobValue extends KnobValue<bool> {
  /// {@macro bool_knob_value}
  BoolKnobValue({required super.value});

  @override
  Widget build({
    required String label,
    required String? description,
    required bool enabled,
    required bool nullable,
  }) =>
      BooleanKnobWidget(
        label: label,
        description: description,
        value: value,
        enabled: enabled,
        nullable: nullable,
      );
}

/// {@template boolean_knob_widget}
/// A knob widget that allows the user to toggle a boolean value.
///
/// The knob is displayed as a checkbox.
///
/// See also:
/// * [BoolKnobValue], which is the knob that this widget represents.
/// {@endtemplate}
class BooleanKnobWidget extends StatelessWidget {
  /// {@macro boolean_knob_widget}
  const BooleanKnobWidget({
    super.key,
    required this.label,
    required this.description,
    required this.value,
    required this.enabled,
    required this.nullable,
  });

  final String label;
  final String? description;
  final bool value;
  final bool enabled;
  final bool nullable;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? description = this.description;

    return KnobListTile(
      enabled: value,
      nullable: nullable,
      onToggled: (bool value) => context.read<KnobsNotifier>().update(label, value),
      leading: SizedBox(
        width: 16,
        child: Transform.scale(
          scale: 0.9,
          child: Checkbox(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            value: enabled ? value : null,
            side: BorderSide(
              color: theme.unselectedWidgetColor,
              width: 1.2,
            ),
            shape: const ContinuousRectangleBorder(borderRadius: borderRadius),
            onChanged: (bool? value) => context.read<KnobsNotifier>().update(label, value),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          if (description != null)
            Padding(
              padding: defaultDescriptionPadding,
              child: Text(
                description,
                style: theme.listTileTheme.subtitleTextStyle,
              ),
            ),
        ],
      ),
    );
  }
}
