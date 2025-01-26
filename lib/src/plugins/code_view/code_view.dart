import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/core/plugin.dart';

class CodeViewPlugin extends Plugin {
  CodeViewPlugin({
    required bool enableCodeView,
    ValueSetter<bool>? onShowCodeView,
  }) : super(
          id: PluginId.codeView,
          icon: enableCodeView ? _buildIcon : null,
          wrapperBuilder: _buildWrapper,
          onPressed: (context) => _onPressed(context, onShowCodeView),
        );
}

Widget _buildIcon(BuildContext context) => Icon(
      context.watch<CodeViewNotifier>().value ? Icons.remove_red_eye_outlined : Icons.code,
    );

void _onPressed(BuildContext context, ValueSetter<bool>? onShowCodeView) {
  switch (context.read<CodeViewNotifier>().value) {
    case true:
      context.read<CodeViewNotifier>().value = false;
      onShowCodeView?.call(false);
    case false:
      context.read<CodeViewNotifier>().value = true;
      onShowCodeView?.call(true);
  }
}

Widget _buildWrapper(BuildContext context, Widget? child) => ChangeNotifierProvider<CodeViewNotifier>(
      create: (_) => CodeViewNotifier(showCodeView: false),
      child: Builder(
        builder: (context) => child ?? const SizedBox.shrink(),
      ),
    );

/// Use this notifier to listen to changes in code view selected state.
///
/// `CodeViewPlugin` should be added to plugins for this to work.
class CodeViewNotifier extends ValueNotifier<bool> {
  CodeViewNotifier({required bool showCodeView}) : super(showCodeView);
}
