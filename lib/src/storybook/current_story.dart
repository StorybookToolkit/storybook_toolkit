import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/plugins/code_view/code_view.dart';
import 'package:storybook_toolkit/src/storybook/current_story_code.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

class CurrentStory extends StatelessWidget {
  const CurrentStory({
    super.key,
    required this.wrapperBuilder,
    this.routeWrapperBuilder,
  });

  final TransitionBuilder wrapperBuilder;
  final RouteWrapperBuilder? routeWrapperBuilder;

  @override
  Widget build(BuildContext context) {
    final StoryNotifier storyNotifier = context.watch<StoryNotifier>();
    final Story? currentStory = storyNotifier.currentStory;

    if (currentStory == null) {
      return const Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          child: Center(
            child: Text('Select a Story'),
          ),
        ),
      );
    }

    final bool showCodeSnippet = context.watch<CodeViewNotifier>().value;

    TextDirection getEffectiveTextDirection() {
      TextDirection result = TextDirection.ltr;
      try {
        result = context.watch<TextDirectionNotifier>().value;
      } catch (e) {
        result = TextDirection.ltr;
      }
      return result;
    }

    final plugins = context.watch<List<Plugin>>();
    final pluginStoryBuilders = plugins
        .map((Plugin plugin) => plugin.storyBuilder)
        .whereType<TransitionBuilder>()
        .map((builder) => SingleChildBuilder(builder: builder))
        .toList();

    Widget child;

    if (currentStory.router != null) {
      final RouteWrapperBuilder effectiveRouteWrapperBuilder =
          currentStory.routeWrapperBuilder ?? routeWrapperBuilder ?? RouteWrapperBuilder();

      late final ThemeData theme;
      try {
        theme = context.watch<ThemeModeNotifier>().value != ThemeMode.light
            ? effectiveRouteWrapperBuilder.darkTheme
            : effectiveRouteWrapperBuilder.theme;
      } catch (e) {
        theme = effectiveRouteWrapperBuilder.darkTheme;
      }

      child = MaterialApp.router(
        title: effectiveRouteWrapperBuilder.title,
        theme: effectiveRouteWrapperBuilder.theme,
        darkTheme: effectiveRouteWrapperBuilder.darkTheme,
        debugShowCheckedModeBanner: effectiveRouteWrapperBuilder.debugShowCheckedModeBanner,
        routerConfig: currentStory.router,
        builder: (BuildContext context, Widget? child) => effectiveRouteWrapperBuilder.wrapperBuilder(
          context,
          Directionality(
            textDirection: getEffectiveTextDirection(),
            child: FocusScope(
              node: Storybook.storyFocusNode,
              child: showCodeSnippet && !currentStory.isPage
                  ? Stack(
                      children: [
                        child ?? const SizedBox.shrink(),
                        Theme(
                          data: theme,
                          child: CurrentStoryCode(),
                        ),
                      ],
                    )
                  : child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      );
    } else {
      final Widget Function(BuildContext, Widget?) effectiveWrapperBuilder =
          currentStory.wrapperBuilder ?? wrapperBuilder;

      child = effectiveWrapperBuilder(
        context,
        showCodeSnippet && !currentStory.isPage
            ? const CurrentStoryCode()
            : FocusScope(
                node: Storybook.storyFocusNode,
                child: Directionality(
                  textDirection: getEffectiveTextDirection(),
                  child: Builder(builder: currentStory.builder!),
                ),
              ),
      );
    }

    return KeyedSubtree(
      key: ValueKey(currentStory.name),
      child: pluginStoryBuilders.isEmpty ? child : Nested(children: pluginStoryBuilders, child: child),
    );
  }
}
