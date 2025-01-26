import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/core/plugin.dart';
import 'package:vader_popup/vader_popup.dart';

class TextSizerPlugin extends Plugin {
  TextSizerPlugin()
      : super(
          id: PluginId.textSizer,
          icon: _buildIcon,
          wrapperBuilder: _buildWrapper,
        );
}

Widget _buildIcon(BuildContext context) => GestureDetector(
      onTap: () async {
        context.read<TextSizerNotifier>().value = await PopupDialog().choose(
          context: context,
          title: "Text Sizer",
          message: "Choose text size:",
          options: [
            for (double size in [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0])
              PopupOption<double>(label: size.toString(), value: size),
          ],
        );
      },
      child: Wrap(
        children: [
          Icon(Icons.format_size),
          SizedBox(width: 3),
          Text(
            context.watch<TextSizerNotifier>().value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );

Widget _buildWrapper(BuildContext context, Widget? child) => ChangeNotifierProvider<TextSizerNotifier>(
      create: (_) => TextSizerNotifier(1.0),
      child: child ?? const SizedBox.shrink(),
    );

/// Use this notifier to listen to changes in textSizer state.
///
/// `TextSizerPlugin` should be added to plugins for this to work.
class TextSizerNotifier extends ValueNotifier<double> {
  TextSizerNotifier(super._value);
}
