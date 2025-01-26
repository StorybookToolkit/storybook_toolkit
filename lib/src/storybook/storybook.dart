import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector/inspector.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/plugins/others/inspector.dart';
import 'package:storybook_toolkit/src/storybook/current_story.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';


final _defaultPlugins = initializePlugins();

class Storybook extends StatefulWidget {
  Storybook({
    super.key,
    required Iterable<Story> stories,
    Iterable<Plugin>? plugins,
    this.initialStory,
    this.wrapperBuilder = materialWrapper,
    this.routeWrapperBuilder,
    this.canvasColor,
    this.showPanel = true,
    this.enableLayout = true,
    this.brandingWidget,
    this.logoWidget,
    Layout initialLayout = Layout.auto,
    double autoLayoutThreshold = 800,
  })  : plugins = UnmodifiableListView([
          LayoutPlugin(
            initialLayout,
            autoLayoutThreshold,
            enableLayout: enableLayout,
          ),
          ContentsPlugin(logoWidget: logoWidget, showPanel: showPanel),
          ...plugins ?? _defaultPlugins,
          KnobsPlugin(showPanel: showPanel),
        ]),
        stories = UnmodifiableListView(stories);

  /// All available stories.
  ///
  /// It is not recommended to mix route aware and default stories
  /// due to unexpected behavior in web.
  final List<Story> stories;

  /// All enabled plugins.
  final List<Plugin> plugins;

  /// Optional initial story.
  final String? initialStory;

  /// Each story will be wrapped into a widget returned by this builder.
  final TransitionBuilder wrapperBuilder;

  /// Each routed story will be wrapped into a widget returned by this builder.
  final RouteWrapperBuilder? routeWrapperBuilder;

  /// Canvas color of the Storybook. Story color can be changed inside
  /// the wrapperBuilder and routeWrapperBuilder.
  final Color? canvasColor;

  /// Whether to show the plugin panel at the bottom.
  final bool showPanel;

  /// Whether to enable the layout plugin in the plugin panel.
  final bool enableLayout;

  /// Branding widget to use in the plugin panel.
  final Widget? brandingWidget;

  /// Logo widget to use in the left side panel above search field.
  final Widget? logoWidget;

  /// For internal use to manage focus in Storybook.
  static late FocusScopeNode? storyFocusNode;

  @override
  State<Storybook> createState() => _StorybookState();
}

class _StorybookState extends State<Storybook> {
  late final StoryNotifier _storyNotifier;
  late final ExpansionTileStateNotifier _expansionTileState;

  final GlobalKey<OverlayState> _overlayKey = GlobalKey<OverlayState>();
  final LayerLink _layerLink = LayerLink();

  GoRouter? router;

  void _initExpansionTileStateMap() {
    final foldersList = widget.stories
        .where((story) => story.router != null)
        .expand((story) => story.storyPathFolders)
        .toSet()
        .toList();

    final Map<String, bool> expansionTileStateMap = {
      for (final folder in foldersList) folder: false,
    };

    _expansionTileState.setExpansionTileStateMap = expansionTileStateMap;
  }

  void _setExpansionTileState() {
    final String routePathMatch = router!.routeInformationParser.configuration
        .findMatch(router!.routerDelegate.currentConfiguration.uri)
        .fullPath;

    _storyNotifier.hasRouteMatch = routePathMatch.isNotEmpty;

    if (routePathMatch.isNotEmpty) {
      final String? routeNameMatch =
          _storyNotifier.storyRouteMap.entries.firstWhereOrNull((route) => route.key == routePathMatch)?.value;

      if (routeNameMatch != null) {
        final List<String> parts = routeNameMatch.split('/');

        if (parts.length > 1) {
          final List<String> tileKeys = parts.sublist(0, parts.length - 1);

          for (final key in tileKeys) {
            _expansionTileState.setExpanded(key, expanded: true);
          }
        }
      }

      _storyNotifier
        ..storyRoutePath = routePathMatch
        ..currentStoryName = routeNameMatch;
    }
  }

  void _listener() => Future.microtask(_setExpansionTileState);

  @override
  void initState() {
    super.initState();

    Storybook.storyFocusNode = FocusScopeNode();

    final routeMap = Map.fromEntries(
      widget.stories.where((story) => story.router != null && story.routePath.isNotEmpty).map((story) {
        router ??= story.router;

        return MapEntry(story.routePath, story.name);
      }),
    );

    _storyNotifier = StoryNotifier(
      widget.stories,
      storyRouteMap: routeMap,
      initial: widget.initialStory,
    );

    _expansionTileState = ExpansionTileStateNotifier();

    if (router != null) {
      _initExpansionTileStateMap();
      router!.routerDelegate.addListener(_listener);
    }
  }

  @override
  void dispose() {
    _storyNotifier.dispose();
    _expansionTileState.dispose();
    Storybook.storyFocusNode?.dispose();

    router?.routerDelegate.removeListener(_listener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = CurrentStory(
      wrapperBuilder: widget.wrapperBuilder,
      routeWrapperBuilder: widget.routeWrapperBuilder,
    );

    return MaterialApp(
        theme: ThemeData(
          canvasColor: widget.canvasColor,
          splashFactory: NoSplash.splashFactory,
          focusColor: Theme.of(context).focusColor.withAlpha(18),
          expansionTileTheme: const ExpansionTileThemeData(
            shape: RoundedRectangleBorder(),
            collapsedShape: RoundedRectangleBorder(),
          ),
          listTileTheme: ListTileThemeData(
            minLeadingWidth: 0,
            minVerticalPadding: 4.0,
            horizontalTitleGap: 5.0,
            selectedColor: Theme.of(context).primaryColor,
            selectedTileColor: Theme.of(context).focusColor.withAlpha(18),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
            subtitleTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.2,
                  color: Colors.black54,
                ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: PopScope(
          canPop: false,
          child: MediaQuery.fromView(
            view: View.of(context),
            child: Localizations(
              delegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
              locale: const Locale('en', 'US'),
              child: Nested(
                children: [
                  Provider.value(value: widget.plugins),
                  ChangeNotifierProvider.value(value: _storyNotifier),
                  ChangeNotifierProvider.value(value: _expansionTileState),
                  ...widget.plugins
                      .map((plugin) => plugin.wrapperBuilder)
                      .whereType<TransitionBuilder>()
                      .map((builder) => SingleChildBuilder(builder: builder)),
                ],
                child: Scaffold(
                  body: Builder(
                    builder: (BuildContext context) {
                      final bool isSidePanel = context.watch<OverlayController?>() != null;

                      final bool isPage = context.select(
                        (StoryNotifier value) => value.currentStory?.isPage == true,
                      );
                      final bool isError = context.select(
                        (StoryNotifier value) => value.hasRouteMatch == false,
                      );

                      final bool showBrandingWidget = widget.brandingWidget != null && !isPage && !isError;

                      return widget.showPanel
                          ? Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: Inspector(
                                        isEnabled: context.watch<InspectorNotifier>().value,
                                        child: currentStory,
                                      ),
                                    ),
                                    RepaintBoundary(
                                      child: Material(
                                        child: SafeArea(
                                          top: false,
                                          left: isSidePanel,
                                          right: isSidePanel,
                                          child: CompositedTransformTarget(
                                            link: _layerLink,
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Container(
                                                width: double.infinity,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: PluginPanel(
                                                        plugins: widget.plugins,
                                                        overlayKey: _overlayKey,
                                                        layerLink: _layerLink,
                                                      ),
                                                    ),
                                                    if (showBrandingWidget) widget.brandingWidget!,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Overlay(key: _overlayKey),
                                ),
                              ],
                            )
                          : currentStory;
                    },
                  ),
                ),
              ),
            ),
        ),
      ),
    );
  }
}