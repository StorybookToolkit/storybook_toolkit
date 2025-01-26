import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/common/constants.dart';
import 'package:storybook_toolkit/src/story/story_notifier.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.text = context.read<StoryNotifier>().searchTerm;
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<TextEditingValue>(
        valueListenable: _searchController,
        builder: (BuildContext context, TextEditingValue value, Widget? _) {
          final ThemeData theme = Theme.of(context);

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingValue,
              vertical: 16.0,
            ),
            child: SizedBox(
              height: containerHeight,
              child: TextFormField(
                controller: _searchController,
                style: theme.textTheme.bodyMedium,
                cursorColor: cursorColor,
                cursorWidth: cursorWidth,
                cursorHeight: cursorHeight,
                cursorRadius: cursorRadius,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hoverColor: Colors.transparent,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: focusedBorderWidth,
                    ),
                    borderRadius: borderRadius,
                  ),
                  border: const OutlineInputBorder(borderRadius: borderRadius),
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onPressed: () {
                            _searchController.clear();
                            context.read<StoryNotifier>().searchTerm = '';
                          },
                          icon: const Icon(Icons.clear, size: 16),
                        )
                      : null,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (String value) {
                  context.read<StoryNotifier>().searchTerm = value;
                },
              ),
            ),
          );
        },
      );
}
