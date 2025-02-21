import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/plugins/code_view/code_view.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

/// Plugin that adds story customization knobs.
///
/// If `sidePanel` is true, the knobs will be displayed in the right side panel.
class KnobsPlugin extends Plugin {
  KnobsPlugin({bool showPanel = true})
      : super(
          id: PluginId.knobs,
          icon: _buildIcon,
          panelBuilder: _buildPanel,
          wrapperBuilder: (BuildContext context, Widget? child) => _buildWrapper(context, child, showPanel),
        );
}

Widget? _buildIcon(BuildContext context) => switch (context.watch<EffectiveLayout>()) {
      EffectiveLayout.compact => const Icon(Icons.settings),
      EffectiveLayout.expanded => null,
    };

Widget _buildPanel(BuildContext context) {
  final KnobsNotifier knobs = context.watch<KnobsNotifier>();
  final bool isCodeView = context.watch<CodeViewNotifier>().value;
  final bool isSidePanel = context.watch<OverlayController?>() == null;
  final String? currentStoryName = context.read<StoryNotifier>().storyRouteName;

  final List<Knob<dynamic>> items = isCodeView ? [] : knobs.all();

  final Story? currentStory = context.select((StoryNotifier storyNotifier) => storyNotifier.currentStory);

  return items.isEmpty
      ? isCodeView
          ? const SizedBox()
          : const Center(child: Text('No knobs'))
      : ListView.separated(
          key: ValueKey(currentStoryName ?? currentStory?.name ?? ''),
          primary: false,
          padding: EdgeInsets.symmetric(vertical: isSidePanel ? 16.0 : 0.0),
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemCount: items.length,
          itemBuilder: (context, index) => items[index].build(),
        );
}

Widget _buildWrapper(BuildContext context, Widget? child, bool showPanel) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SelectKnobDropdownStateManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => KnobsNotifier(context.read<StoryNotifier>()),
        ),
      ],
      builder: (BuildContext context, Widget? _) {
        final StoryNotifier storyNotifier = context.watch<StoryNotifier>();
        final bool isPage = storyNotifier.currentStory?.isPage == true;
        final bool isErrorScreen = !(storyNotifier.hasRouteMatch ?? true);

        return isPage || isErrorScreen || !showPanel
            ? child!
            : switch (context.watch<EffectiveLayout>()) {
                EffectiveLayout.compact => child!,
                EffectiveLayout.expanded => Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        Expanded(child: child ?? const SizedBox.shrink()),
                        TapRegion(
                          onTapOutside: (PointerDownEvent _) {
                            context.read<SelectKnobDropdownStateManager>().popDropdown();
                          },
                          child: RepaintBoundary(
                            child: Material(
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(color: Colors.black12),
                                  ),
                                ),
                                child: SafeArea(
                                  left: false,
                                  child: SizedBox(
                                    width: 250,
                                    child: Navigator(
                                      onGenerateRoute: (_) => PageRouteBuilder<void>(
                                        pageBuilder: (BuildContext context, _, __) => _buildPanel(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              };
      },
    );
