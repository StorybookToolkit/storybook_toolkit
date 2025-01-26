import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:storybook_toolkit/src/story/story.dart';

/// Use this notifier to get the current story.
class StoryNotifier extends ChangeNotifier {
  StoryNotifier(
    List<Story> stories, {
    String? initial,
    Map<String, String>? storyRouteMap,
  })  : _stories = stories.toList(),
        _currentStoryName = initial,
        _getInitialStoryName = initial,
        _storyRouteMap = storyRouteMap ?? {};

  // Initial story.
  final String? _getInitialStoryName;

  String? get getInitialStoryName => _getInitialStoryName;

  // Story route map.
  final Map<String, String> _storyRouteMap;

  Map<String, String> get storyRouteMap => _storyRouteMap;

  String? getStoryRouteName(String? route) => _storyRouteMap[route];

  String? getStoryRoutePath(String? name) =>
      _storyRouteMap.entries.firstWhereOrNull((entry) => entry.value == name)?.key;

  // Route match.
  bool? _hasRouteMatch;

  set hasRouteMatch(bool? hasRouteMatch) {
    _hasRouteMatch = hasRouteMatch;
    notifyListeners();
  }

  bool? get hasRouteMatch => _hasRouteMatch;

  // Stories.
  List<Story> _stories;

  set stories(List<Story> value) {
    _stories = value.toList(growable: false);
    notifyListeners();
  }

  List<Story> get stories => UnmodifiableListView(
        _searchTerm.isEmpty
            ? _stories
            : _stories.where(
                (story) => story.title.toLowerCase().contains(_searchTerm.toLowerCase()),
              ),
      );

  // Story route path.
  String? _storyRoutePath;

  String? get storyRoutePath => _storyRoutePath;

  set storyRoutePath(String? path) {
    _storyRoutePath = _storyRoutePath;
    notifyListeners();
  }

  // Story route name.
  String? _storyRouteName;

  String? get storyRouteName => _storyRouteName;

  // Current Story name.
  String? _currentStoryName;

  String? get currentStoryName => _currentStoryName;

  set currentStoryName(String? value) {
    _currentStoryName = value;
    notifyListeners();
  }

  Story? get currentStory {
    final index = _stories.indexWhere((story) => story.name == _currentStoryName);

    final Story? story = index != -1 ? _stories[index] : null;

    _storyRoutePath = story?.router?.routeInformationProvider.value.uri.path;
    _storyRouteName = getStoryRouteName(_storyRoutePath);

    return story;
  }

  // Search term.
  String _searchTerm = '';

  String get searchTerm => _searchTerm;

  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }
}
