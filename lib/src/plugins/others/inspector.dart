import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/core/plugin.dart';

class InspectorPlugin extends Plugin {
  InspectorPlugin({
    bool enableInspector = true,
    ValueSetter<TextDirection>? onTextDirectionChanged,
  }) : super(
          id: PluginId.inspector,
          icon: (context) => enableInspector ? _buildIcon(context) : null,
          wrapperBuilder: _buildWrapper,
        );
}

Widget _buildIcon(BuildContext context) => GestureDetector(
      onTap: () => context.read<InspectorNotifier>().value = !context.read<InspectorNotifier>().value,
      child: Icon(context.watch<InspectorNotifier>().value ? Icons.search_off : Icons.search),
    );

Widget _buildWrapper(BuildContext _, Widget? child) => ChangeNotifierProvider<InspectorNotifier>(
      create: (_) => InspectorNotifier(false),
      child: child,
    );

class InspectorNotifier extends ValueNotifier<bool> {
  InspectorNotifier(super._value);
}
