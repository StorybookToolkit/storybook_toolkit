import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/common/constants.dart';
import 'package:storybook_toolkit/src/plugins/knobs/knobs_notifier.dart';
import 'package:storybook_toolkit/src/components/knob_list_tile.dart';
import 'package:storybook_toolkit/src/knobs/knobs.dart';

/// {@template string_knob}
/// A knob that allows the user to edit a string value.
///
/// See also:
/// * [StringKnobWidget], which is the widget that displays the knob.
/// {@endtemplate}
class StringKnobValue extends KnobValue<String> {
  /// {@macro string_knob}
  StringKnobValue({required super.value});

  @override
  Widget build({
    required String label,
    required String? description,
    required bool enabled,
    required bool nullable,
  }) =>
      StringKnobWidget(
        label: label,
        description: description,
        value: value,
        enabled: enabled,
        nullable: nullable,
      );
}

/// {@template string_knob_widget}
/// A knob widget that allows the user to edit a string value.
///
/// The knob is displayed as a [TextFormField].
///
/// See also:
/// * [StringKnobValue], which is the knob that this widget represents.
/// {@endtemplate}
class StringKnobWidget extends StatelessWidget {
  /// {@macro string_knob_widget}
  const StringKnobWidget({
    super.key,
    required this.label,
    required this.description,
    required this.value,
    required this.enabled,
    required this.nullable,
  });

  final String label;
  final String? description;
  final String value;
  final bool enabled;
  final bool nullable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = this.description;

    return KnobListTile(
      enabled: enabled,
      nullable: nullable,
      contentPadding: inputKnobTilePadding,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: theme.textTheme.bodyMedium,
            cursorColor: cursorColor,
            cursorWidth: cursorWidth,
            cursorHeight: cursorHeight,
            cursorRadius: cursorRadius,
            decoration: InputDecoration(
              labelText: label,
              constraints: BoxConstraints.tight(
                const Size.fromHeight(containerHeight),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: knobsHorizontalTitleGap,
              ),
              hoverColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: focusedBorderWidth,
                ),
                borderRadius: borderRadius,
              ),
              border: const OutlineInputBorder(borderRadius: borderRadius),
            ),
            textInputAction: TextInputAction.done,
            initialValue: value,
            onChanged: (String value) => context.read<KnobsNotifier>().update(label, value),
          ),
          if (description != null)
            Padding(
              padding: inputKnobDescriptionPadding,
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
