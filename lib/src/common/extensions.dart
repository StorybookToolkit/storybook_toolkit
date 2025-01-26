
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/plugins/knobs/knobs_notifier.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

extension Knobs on BuildContext {
  KnobsBuilder get knobs => watch<KnobsNotifier>();
}

