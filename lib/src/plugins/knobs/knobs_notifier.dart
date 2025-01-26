import 'package:flutter/material.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';


class KnobsNotifier extends ChangeNotifier implements KnobsBuilder {
  KnobsNotifier(this._storyNotifier) {
    _storyNotifier.addListener(_onStoryChanged);
  }

  final StoryNotifier _storyNotifier;
  final Map<String, Map<String, Knob<dynamic>>> _knobs = {};

  @override
  late final nullable = _NullableKnobsBuilder(this);

  void _onStoryChanged() => notifyListeners();

  void update<T>(String label, T value) {
    final story = _storyNotifier.currentStory;
    if (story == null) return;

    final String? currentStoryName = _storyNotifier.storyRouteName;

    _knobs[currentStoryName ?? story.name]![label]!.value = value;

    notifyListeners();
  }

  T get<T>(String label) {
    // ignore: avoid-non-null-assertion, having null here is a bug
    final story = _storyNotifier.currentStory!;
    final String? routeStoryName = _storyNotifier.storyRouteName;

    return _knobs[routeStoryName ?? story.name]![label]!.value as T;
  }

  List<Knob<dynamic>> all() {
    final story = _storyNotifier.currentStory;
    if (story == null) return [];

    final String? routeStoryName = _storyNotifier.storyRouteName;

    return _knobs[routeStoryName ?? story.name]?.values.toList() ?? [];
  }

  T _addKnob<T>(Knob<T> value) {
    // ignore: avoid-non-null-assertion, having null here is a bug
    final story = _storyNotifier.currentStory!;
    final String? routeStoryName = _storyNotifier.storyRouteName;

    final knobs = _knobs.putIfAbsent(routeStoryName ?? story.name, () => {});

    return (knobs.putIfAbsent(value.label, () {
      Future.microtask(notifyListeners);

      return value;
    }) as Knob<T>)
        .value;
  }

  @override
  bool boolean({
    required String label,
    String? description,
    bool initial = false,
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: BoolKnobValue(
            value: initial,
          ),
        ),
      );

  @override
  String text({
    required String label,
    String? description,
    String initial = '',
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: StringKnobValue(
            value: initial,
          ),
        ),
      );

  @override
  T options<T>({
    required String label,
    String? description,
    required T initial,
    List<Option<T>> options = const [],
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: SelectKnobValue(
            value: initial,
            options: options,
          ),
        ),
      );

  @override
  double slider({
    required String label,
    String? description,
    double? initial,
    double max = 1,
    double min = 0,
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: SliderKnobValue(
            value: initial ?? min,
            max: max,
            min: min,
          ),
        ),
      );

  @override
  int sliderInt({
    required String label,
    String? description,
    int? initial,
    int max = 100,
    int min = 0,
    int? divisions,
  }) =>
      _addKnob(
        Knob(
          label: label,
          description: description,
          knobValue: SliderKnobValue(
            value: (initial ?? min).toDouble(),
            max: max.toDouble(),
            min: min.toDouble(),
            divisions: divisions,
            formatValue: (v) => v.toInt().toString(),
          ),
        ),
      ).toInt();

  @override
  void dispose() {
    _storyNotifier.removeListener(_onStoryChanged);
    super.dispose();
  }
}

class _NullableKnobsBuilder extends NullableKnobsBuilder {
  const _NullableKnobsBuilder(this._knobs);

  final KnobsNotifier _knobs;

  @override
  bool? boolean({
    required String label,
    String? description,
    bool initial = false,
    bool enabled = true,
  }) =>
      _knobs._addKnob(
        NullableKnob(
          enabled: enabled,
          label: label,
          description: description,
          knobValue: BoolKnobValue(
            value: initial,
          ),
        ),
      );

  @override
  T? options<T>({
    required String label,
    String? description,
    required T initial,
    List<Option<T>> options = const [],
    bool enabled = true,
  }) =>
      _knobs._addKnob(
        NullableKnob(
          enabled: enabled,
          label: label,
          description: description,
          knobValue: SelectKnobValue(
            value: initial,
            options: options,
          ),
        ),
      );

  @override
  double? slider({
    required String label,
    String? description,
    double? initial,
    double max = 1,
    double min = 0,
    bool enabled = true,
  }) =>
      _knobs._addKnob(
        NullableKnob(
          enabled: enabled,
          label: label,
          description: description,
          knobValue: SliderKnobValue(
            value: initial ?? min,
            max: max,
            min: min,
          ),
        ),
      );

  @override
  int? sliderInt({
    required String label,
    String? description,
    int? initial,
    int max = 100,
    int min = 0,
    int? divisions,
    bool enabled = true,
  }) =>
      _knobs
          ._addKnob(
        NullableKnob(
          enabled: enabled,
          label: label,
          description: description,
          knobValue: SliderKnobValue(
            value: (initial ?? min).toDouble(),
            max: max.toDouble(),
            min: min.toDouble(),
            divisions: divisions,
            formatValue: (v) => v.toInt().toString(),
          ),
        ),
      )
          ?.toInt();

  @override
  String? text({
    required String label,
    String? description,
    String initial = '',
    bool enabled = true,
  }) =>
      _knobs._addKnob(
        NullableKnob(
          enabled: enabled,
          label: label,
          description: description,
          knobValue: StringKnobValue(
            value: initial,
          ),
        ),
      );
}
