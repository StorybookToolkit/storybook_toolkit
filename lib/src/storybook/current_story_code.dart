import 'dart:ui';

import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/plugins/code_view/code_view_syntax_theme.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

class CurrentStoryCode extends StatelessWidget {
  const CurrentStoryCode({this.panelBackgroundColor});

  final Color? panelBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final ScrollBehavior scrollBehaviour = ScrollConfiguration.of(context).copyWith(
      scrollbars: false,
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      },
    );

    final bool isDesktopWeb = kIsWeb &&
        !(kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android));

    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: panelBackgroundColor ?? ThemeData.dark().scaffoldBackgroundColor,
        child: SafeArea(
          bottom: false,
          left: false,
          right: false,
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => FutureBuilder<String?>(
                  future: context.watch<StoryNotifier>().currentStory?.codeString,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Houston, we have a problem with showing the code :(',
                          style: textStyle,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ScrollConfiguration(
                        behavior: scrollBehaviour,
                        child: SingleChildScrollView(
                          child: AnySyntaxHighlighter(
                            snapshot.data ?? '',
                            fontSize: 12,
                            padding: defaultPaddingValue,
                            hasCopyButton: true,
                            isSelectableText: isDesktopWeb,
                            reservedWordSets: const {'dart'},
                            theme: CustomSyntaxHighlighterTheme.customTheme(),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        'No code provided',
                        style: textStyle,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
