import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/common/constants.dart';
import 'package:storybook_toolkit/src/plugins/knobs/knobs_notifier.dart';
import 'package:storybook_toolkit/src/components/knob_list_tile.dart';
import 'package:storybook_toolkit/src/knobs/knobs.dart';

/// A type definition for a function that formats a [double] value.
typedef DoubleFormatter = String Function(double value);

String _defaultFormat(double value) => value.toStringAsFixed(2);

/// {@template slider_knob}
/// A knob that allows the user to select a value from a range.
///
/// See also:
/// * [SliderKnobWidget], which is the widget that displays the knob.
/// {@endtemplate}
class SliderKnobValue extends KnobValue<double> {
  /// {@macro slider_knob}
  SliderKnobValue({
    required super.value,
    required this.max,
    required this.min,
    this.divisions,
    this.formatValue = _defaultFormat,
  });

  /// The maximum value of the slider.
  final double max;

  /// The minimum value of the slider.
  final double min;

  /// An optional function that formats the value of the slider.
  ///
  /// By default, the value is formatted as a decimal number with two digits
  /// after the decimal point.
  final DoubleFormatter formatValue;

  /// The number of divisions in the slider.
  ///
  /// Using divisions will create a lag in the slider drag.
  final int? divisions;

  @override
  Widget build({
    required String label,
    required String? description,
    required bool enabled,
    required bool nullable,
  }) =>
      SliderKnobWidget(
        label: label,
        description: description,
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        formatValue: formatValue,
        enabled: enabled,
        nullable: nullable,
      );
}

/// {@template slider_knob_widget}
/// A knob widget that allows the user to select a value from a range.
///
/// The knob is displayed as a [Slider].
///
/// See also:
/// * [SliderKnobValue], which is the knob that this widget represents.
/// {@endtemplate}
class SliderKnobWidget extends StatelessWidget {
  /// {@macro slider_knob_widget}
  const SliderKnobWidget({
    super.key,
    required this.label,
    required this.description,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.formatValue,
    required this.enabled,
    required this.nullable,
  });

  final String label;
  final String? description;
  final double min;
  final double max;
  final double value;
  final int? divisions;
  final DoubleFormatter formatValue;
  final bool enabled;
  final bool nullable;

  @override
  Widget build(BuildContext context) => KnobListTile(
        nullable: nullable,
        enabled: enabled,
        onToggled: (bool enabled) => context.read<KnobsNotifier>().update(label, enabled ? value : null),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$label (${formatValue(value)})'),
            if (description != null)
              Padding(
                padding: defaultDescriptionPadding,
                child: Text(
                  description!,
                  style: Theme.of(context).listTileTheme.subtitleTextStyle,
                ),
              ),
            Padding(
              padding: sliderPadding,
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: _CustomTrackShape(),
                  trackHeight: 2.0,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                ),
                child: Slider(
                  value: value,
                  onChanged: (double value) => context.read<KnobsNotifier>().update(label, value),
                  max: max,
                  min: min,
                  divisions: divisions,
                  autofocus: false,
                ),
              ),
            ),
          ],
        ),
      );
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx + 10.0;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width - 18.0;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
