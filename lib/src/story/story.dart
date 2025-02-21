import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storybook_toolkit/src/common/constants.dart';
import 'package:storybook_toolkit/src/storybook/storybook_wrappers.dart';

@immutable
class Story {
  const Story({
    required this.name,
    required this.builder,
    this.description,
    this.wrapperBuilder,
    this.codeString,
    this.loadDuration,
    this.isPage = false,
    this.goldenPathBuilder,
    this.tags = const [],
  })  : router = null,
        routePath = '',
        routeWrapperBuilder = null;

  const Story.asRoute({
    required this.name,
    required GoRouter this.router,
    required this.routePath,
    this.description,
    this.routeWrapperBuilder,
    this.codeString,
    this.loadDuration,
    this.isPage = false,
    this.goldenPathBuilder,
    this.tags = const [],
  })  : wrapperBuilder = null,
        builder = null,
        assert(
          routePath != '',
          'Route path cannot be empty for route aware story.',
        );

  /// If this story is a page.
  /// Plugin and knob panels with respective functionalities are
  /// hidden and disabled for pages.
  final bool isPage;

  /// Router for route aware story.
  final GoRouter? router;

  /// Route path for route aware story. Route path cannot be empty.
  final String routePath;

  /// Tags for tests
  final List<String> tags;

  /// Unique name of the story.
  ///
  /// Use `/` to group stories in sections, e.g. `Buttons/FlatButton`
  /// will create a section `Buttons` with a story `FlatButton` in it.
  final String name;

  /// Optional description of the story.
  ///
  /// It will be used as a secondary text under story name.
  final String? description;

  /// Code string to show for the story.
  final Future<String>? codeString;

  /// Duration of time for waiting then content is loaded.
  ///
  /// It is useful for golden tests generating.
  final Duration? loadDuration;

  /// Wrapper builder for story.
  final TransitionBuilder? wrapperBuilder;

  /// Wrapper builder for route aware story.
  final RouteWrapperBuilder? routeWrapperBuilder;

  /// Story builder.
  final WidgetBuilder? builder;

  /// Golden test path builder.
  final String Function(PathContext)? goldenPathBuilder;

  List<String> get path => name.split(sectionSeparator);

  String get title => name.split(sectionSeparator).last;

  List<String> get storyPathFolders => name.split(sectionSeparator).sublist(0, path.length - 1);
}