import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:storybook_toolkit_example/common/logo_widget.dart';
import 'package:storybook_toolkit_example/l10n/app_localizations.dart';
import 'package:storybook_toolkit_example/routing/route_aware_stories.dart';
import 'package:storybook_toolkit_example/stories/counter_page.dart';
import 'package:storybook_toolkit_example/stories/scaffold_page.dart';

void main() {
  usePathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Storybook(
        canvasColor: Colors.white,
        initialStory: 'Home',
        plugins: StorybookPlugins(
          enableCodeView: false,
          initialDeviceFrameData: DeviceFrameData(
            visibility: DeviceFrameVisibility.none,
            device: Devices.ios.iPhone12ProMax,
            orientation: Orientation.portrait
          ),
          enableDirectionality: false,
          enableTimeDilation: false,
          enableTextSizer: true,
          localizationData: LocalizationData(
            supportedLocales: {
              "Czech": Locale('cs', 'CZ'),
              "English": Locale('en', 'US'),
            },
            delegates: AppLocalizations.localizationsDelegates,
            currentLocale: AppLocalizations.supportedLocales.first,
            onChangeLocale: (locale) {
              print("Local was changed to: $locale");
            }
          ),
        ),
        routeWrapperBuilder: RouteWrapperBuilder(title: 'Storybook'),
        logoWidget: const LogoWidget(),
        //brandingWidget: const Align(
        //  alignment: Alignment.centerRight,
        //  child: Padding(
        //    padding: EdgeInsets.symmetric(horizontal: 8.0),
        //    child: Text('Storybook'),
        //  ),
        //),
        stories: [
          ...routeAwareStories,
          Story(
            name: 'Screens/Scaffold',
            builder: (context) => const ScaffoldPage(),
          ),
          Story(
            name: 'Screens/Counter',
            description: 'Counter app with dialog.',
            builder: (context) => const CounterPage(),
          ),
          Story(
            name: 'Widgets/Text',
            description: 'Simple text widget.',
            builder: (context) => const Center(child: Text('Simple text')),
          ),
          Story(
            name: 'Story/Nested/Multiple/Times/First',
            builder: (context) => const Center(child: Text('First')),
          ),
          Story(
            name: 'Story/Nested/Multiple/Times/Second',
            builder: (context) => const Center(child: Text('Second')),
          ),
          Story(
            name: 'Story/Nested/Multiple/Third',
            builder: (context) => const Center(child: Text('Third')),
          ),
          Story(
            name: 'Story/Nested/Multiple/Fourth',
            builder: (context) => const Center(child: Text('Fourth')),
          ),
          Story(
            name: 'Story without a category',
            description: 'Story with a longer description example.',
            builder: (context) => const Center(child: Text('Simple text')),
          ),
        ],
      );
}
