import 'package:flutter/material.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:storybook_toolkit_example/stories/counter_page.dart';
import 'package:storybook_toolkit_tester/storybook_toolkit_tester.dart';

void main() => testStorybook(
      storybook,
      devices: {
        Devices.ios.iPhoneSE,
        Devices.ios.iPhone12,
        Devices.android.pixel4,
        Devices.android.samsungGalaxyS20,
        Devices.ios.iPadAir4,
      },
      isFrameVisible: true,
      filterStories: (Story story) {
        final skipStories = [];
        return !skipStories.contains(story.name);
      },
    );

final storybook = Storybook(
  stories: [
    Story(
      name: 'Buttons/SimpleButton/Default',
      tags: ['buttons'],
      builder: (context) => ElevatedButton(
        onPressed: () {},
        child: const Text('Default Button'),
      ),
    ),
    Story(
      name: 'Buttons/SimpleButton/Customized',
      tags: ['buttons'],
      builder: (context) => ElevatedButton(
        onPressed: () {},
        child: const Text(
          'Customized Button',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    Story(
      name: 'Pages/Counter',
      builder: (context) => const CounterPage(),
      goldenPathBuilder: (c) => "${c.rootPath}/subfolder1/${c.path}/subfolder2/${c.file}",
      tags: ['pages'],
    ),
    Story(
      name: 'CounterPage',
      builder: (context) => const CounterPage(),
      tags: ['pages'],
    ),
  ],
  showPanel: true,
  plugins: StorybookPlugins(
    enableCodeView: false,
    enableDirectionality: false,
    enableTimeDilation: false,
  ),
);
