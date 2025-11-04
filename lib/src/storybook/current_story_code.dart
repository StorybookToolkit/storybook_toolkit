import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class CurrentStoryCode extends StatefulWidget {
  const CurrentStoryCode();

  @override
  State<CurrentStoryCode> createState() => _CurrentStoryCodeState();
}

class _CurrentStoryCodeState extends State<CurrentStoryCode> {
  bool _isInitialized = false;
  late final CodeEditorController _controller;

  @override
  void initState() {
    super.initState();

    _initializeHighlighter().then((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  Future<void> _initializeHighlighter() async {
    await Highlighter.initialize(['dart']);

    final lightTheme = await HighlighterTheme.loadLightTheme();
    final darkTheme = await HighlighterTheme.loadDarkTheme();

    _controller = CodeEditorController(
      lightHighlighter: Highlighter(language: 'dart', theme: lightTheme),
      darkHighlighter: Highlighter(language: 'dart', theme: darkTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          bottom: false,
          left: false,
          right: false,
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => FutureBuilder<String?>(
                  future: context.read<StoryNotifier>().currentStory?.codeString,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || !_isInitialized) {
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
                      final code = snapshot.data ?? '';
                      _controller.value = TextEditingValue(text: code);

                      return Padding(
                        padding: const EdgeInsets.all(defaultPaddingValue),
                        child: CodeEditor(
                          textStyle: TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.3),
                          controller: _controller,
                          readOnly: true,
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
