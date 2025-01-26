import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

class TimeDilationPlugin extends Plugin {
  TimeDilationPlugin({
    ValueSetter<bool>? onTimeDilationChanged,
  }) : super(
          id: PluginId.timeDilation,
          icon: _buildIcon,
          wrapperBuilder: _buildWrapper,
          onPressed: (context) => _onPressed(context, onTimeDilationChanged),
        );
}

Widget _buildIcon(BuildContext context) => Icon(
      context.watch<TimeDilationNotifier>().value
          ? Icons.slow_motion_video_outlined
          : Icons.play_circle_outline_outlined,
    );

void _onPressed(
  BuildContext context,
  ValueSetter<bool>? onTimeDilationChanged,
) {
  switch (context.read<TimeDilationNotifier>().value) {
    case true:
      context.read<TimeDilationNotifier>().value = false;
      onTimeDilationChanged?.call(false);
    case false:
      context.read<TimeDilationNotifier>().value = true;
      onTimeDilationChanged?.call(true);
  }
}

Widget _buildWrapper(BuildContext _, Widget? child) => ChangeNotifierProvider<TimeDilationNotifier>(
      create: (_) => TimeDilationNotifier(isTimeDilated: false),
      child: Builder(
        builder: (BuildContext context) {
          final bool isPage = context.select(
            (StoryNotifier storyNotifier) => storyNotifier.currentStory?.isPage == true,
          );

          timeDilation = context.watch<TimeDilationNotifier>().value && !isPage ? 10 : 1;

          return child ?? const SizedBox.shrink();
        },
      ),
    );

/// Use this notifier to listen to changes in time dilation state.
///
/// `TimeDilationPlugin` should be added to plugins for this to work.
class TimeDilationNotifier extends ValueNotifier<bool> {
  TimeDilationNotifier({required bool isTimeDilated}) : super(isTimeDilated);
}
