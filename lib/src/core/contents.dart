import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/common/custom_list_tile.dart';
import 'package:storybook_toolkit/src/components/search_text_field.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

/// Plugin that adds content as expandable list of stories.
///
/// If `sidePanel` is true, the stories are shown in the left side panel,
/// otherwise as a popup.
class ContentsPlugin extends Plugin {
  ContentsPlugin({Widget? logoWidget, bool showPanel = true})
      : super(
          id: PluginId.contents,
          icon: _buildIcon,
          panelBuilder: (BuildContext context) => _buildPanel(context, logoWidget),
          wrapperBuilder: (BuildContext context, Widget? child) => _buildWrapper(context, child, logoWidget, showPanel),
        );
}

Widget? _buildIcon(BuildContext context) => switch (context.watch<EffectiveLayout>()) {
      EffectiveLayout.compact => const Icon(Icons.list),
      EffectiveLayout.expanded => null,
    };

Widget _buildPanel(BuildContext _, Widget? logoWidget) => _Contents(logoWidget);

Widget _buildWrapper(BuildContext context, Widget? child, Widget? logoWidget, bool showPanel) =>
    switch (context.watch<EffectiveLayout>()) {
      EffectiveLayout.compact => child ?? const SizedBox.shrink(),
      EffectiveLayout.expanded => showPanel
          ? Row(
              children: [
                Material(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: SizedBox(
                      width: panelWidth,
                      child: Navigator(
                        onGenerateRoute: (_) => PageRouteBuilder<void>(
                          pageBuilder: (_, __, ___) => _Contents(logoWidget),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRect(
                    clipBehavior: Clip.hardEdge,
                    child: child,
                  ),
                ),
              ],
            )
          : child ?? const SizedBox.shrink(),
    };

class _Contents extends StatefulWidget {
  const _Contents(this.logoWidget);

  final Widget? logoWidget;

  @override
  _ContentsState createState() => _ContentsState();
}

class _ContentsState extends State<_Contents> {
  Widget _buildExpansionTile({
    required String title,
    required Iterable<Story> stories,
    required List<Widget> children,
    required double sectionLeftPadding,
  }) {
    final StoryNotifier storyNotifier = context.watch<StoryNotifier>();

    final ExpansionTileStateNotifier tilesState = context.watch<ExpansionTileStateNotifier>();

    final ValueKey<String> tileKey = ValueKey(
      '${storyNotifier.currentStoryName}${storyNotifier.hasRouteMatch}',
    );

    final bool tileIsExpanded = tilesState.isExpanded(title) ?? false;

    // When the initial story is non route story, the hasRouteMatch is null.
    // The hasRouteMatch value is assigned once there is navigation activity.
    bool isInitialNonRouteStoryFolder = false;
    if (storyNotifier.hasRouteMatch == null && tilesState.isExpanded(title) == null) {
      isInitialNonRouteStoryFolder = storyNotifier.getInitialStoryName?.contains(title) == true;
      if (isInitialNonRouteStoryFolder) {
        tilesState.setExpanded(title, expanded: true);
      }
    }

    final bool initiallyExpanded =
        storyNotifier.searchTerm.isNotEmpty || tileIsExpanded || isInitialNonRouteStoryFolder;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(padding: EdgeInsets.zero),
      child: ExpansionTile(
        key: tileKey,
        maintainState: true,
        tilePadding: EdgeInsets.only(
          left: sectionLeftPadding,
          right: defaultPaddingValue,
        ),
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: (bool isExpanded) {
          tilesState.setExpanded(title, expanded: isExpanded);
          setState(() {});
        },
        leading: SizedBox(
          width: 40,
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Builder(
                builder: (BuildContext context) => AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: tileIsExpanded ? 0.25 : 0,
                  child: const Icon(
                    Icons.arrow_right_rounded,
                    size: 24,
                    color: Colors.black26,
                  ),
                ),
              ),
              Icon(
                Icons.folder,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        title: Text(title),
        trailing: const SizedBox.shrink(),
        children: children,
      ),
    );
  }

  Widget _buildStoryTile(Story story, double leftPadding) {
    final ListTileThemeData listTileTheme = Theme.of(context).listTileTheme;
    final StoryNotifier storyNotifier = context.watch<StoryNotifier>();
    final GoRouter? router = story.router;

    final Story? currentSelectedStory = storyNotifier.currentStory;

    final bool isRouteAwareStory = router != null && story.routePath.isNotEmpty;

    final String? storyTileRoutePath = storyNotifier.getStoryRoutePath(story.name);

    final bool isSelected = isRouteAwareStory
        ? (story.name == storyNotifier.storyRouteName ||
                (storyNotifier.storyRoutePath == '/' && story.name == storyNotifier.currentStoryName)) &&
            currentSelectedStory?.router != null
        : story == currentSelectedStory;

    return CustomListTile(
      selected: isSelected,
      contentPadding: EdgeInsets.only(
        left: leftPadding,
        right: defaultPaddingValue,
      ),
      onTap: () {
        storyNotifier.currentStoryName = story.name;
        context.read<OverlayController?>()?.remove();

        router?.go(storyTileRoutePath!);
      },
      leading: SizedBox(
        height: 16,
        width: 16,
        child: story.isPage
            ? const Icon(
                Icons.description,
                size: 14,
                color: Colors.orangeAccent,
              )
            : const Icon(
                Icons.widgets_outlined,
                size: 14,
              ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(story.title),
          if (story.description != null)
            Padding(
              padding: defaultDescriptionPadding,
              child: Text(
                story.description!,
                style: listTileTheme.subtitleTextStyle?.copyWith(
                  color: isSelected ? listTileTheme.selectedColor : null,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildListChildren(List<Story> stories, {int depth = 1}) {
    const double sectionLeftPadding = 20.0;
    final double leftPadding = (depth - 1) * sectionLeftPadding;
    final double storyLeftPadding = leftPadding + defaultPaddingValue;

    final Map<String, List<Story>> grouped = stories.groupListsBy(
      (story) => story.path.length == depth ? '' : story.path[depth - 1],
    );

    final List<Widget> sectionStories =
        (grouped[''] ?? []).map((story) => _buildStoryTile(story, storyLeftPadding)).toList();

    return stories.length == sectionStories.length
        ? sectionStories
        : [
            ...grouped.keys.where((key) => key.isNotEmpty).map(
                  (key) => _buildExpansionTile(
                    sectionLeftPadding: leftPadding,
                    title: key,
                    stories: grouped[key]!,
                    children: _buildListChildren(
                      grouped[key]!,
                      depth: depth + 1,
                    ),
                  ),
                ),
            ...sectionStories,
          ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isSidePanel = context.watch<OverlayController?>() == null;
    final StoryNotifier storyNotifier = context.watch<StoryNotifier>();

    final List<Widget> pages = _buildListChildren(
      storyNotifier.stories.where((element) => element.isPage).toList(),
    );

    final List<Widget> stories = _buildListChildren(
      storyNotifier.stories.where((element) => !element.isPage).toList(),
    );

    return SafeArea(
      top: isSidePanel,
      bottom: isSidePanel,
      left: isSidePanel,
      right: false,
      child: Column(
        children: [
          if (widget.logoWidget != null && isSidePanel) widget.logoWidget!,
          const SearchTextField(),
          Expanded(
            key: ValueKey(storyNotifier.searchTerm),
            child: pages.isEmpty && stories.isEmpty && storyNotifier.searchTerm.isNotEmpty
                ? const Center(child: Text('Nothing found'))
                : ListView(
                    primary: false,
                    addAutomaticKeepAlives: true,
                    padding: EdgeInsets.only(
                      bottom: isSidePanel ? 16.0 : 0.0,
                      top: 8.0,
                    ),
                    children: [
                      ...pages,
                      ...stories,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class ExpansionTileStateNotifier extends ChangeNotifier {
  Map<String, bool> _tileStates = {};

  bool? isExpanded(String tileKey) => _tileStates[tileKey];

  void setExpanded(String tileKey, {required bool expanded}) {
    _tileStates[tileKey] = expanded;
  }

  set setExpansionTileStateMap(Map<String, bool> tileStateMap) {
    _tileStates = tileStateMap;
  }
}
