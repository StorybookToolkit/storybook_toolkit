import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/src/plugins/others/text_sizer.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';


/// Use this wrapper to wrap each route aware story inside default
/// [MaterialApp.router] widget.
class RouteWrapperBuilder {
  RouteWrapperBuilder({
    this.title = '',
    ThemeData? theme,
    ThemeData? darkTheme,
    this.debugShowCheckedModeBanner = false,
    Widget Function(BuildContext, Widget?)? wrapperBuilder,
  })  : theme = theme ?? ThemeData.light(),
        darkTheme = darkTheme ?? ThemeData.dark(),
        wrapperBuilder = wrapperBuilder ?? defaultWrapperBuilder;

  final String title;
  final ThemeData theme;
  final ThemeData darkTheme;
  final bool debugShowCheckedModeBanner;
  final Widget Function(BuildContext, Widget?) wrapperBuilder;

  static Widget defaultWrapperBuilder(BuildContext context, Widget? child) => Scaffold(
    body: Center(
      child: child ?? const SizedBox.shrink(),
    ),
  );
}

Widget defaultMediaQueryBuilder(BuildContext context, Widget? child) {
  try {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          context.watch<TextSizerNotifier>().value,
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  } catch (e) {
    return child ?? const SizedBox.shrink();
  }
}

/// Use this wrapper to wrap each story into a [MaterialApp] widget.
Widget materialWrapper(BuildContext context, Widget? child) {
  final LocalizationData localization = context.watch<LocalizationNotifier>().value;
  return MaterialApp(
    theme: ThemeData.light().copyWith(
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
    ),
    darkTheme: ThemeData.dark().copyWith(
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
    ),
    debugShowCheckedModeBanner: false,
    supportedLocales: localization.supportedLocales.values,
    localizationsDelegates: localization.delegates,
    locale: localization.currentLocale,
    builder: defaultMediaQueryBuilder,
    home: Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        body: Center(
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    ),
  );
}

/// Use this wrapper to wrap each story into a [CupertinoApp] widget.
Widget cupertinoWrapper(BuildContext context, Widget? child) {
  final LocalizationData localization = context.watch<LocalizationNotifier>().value;
  return CupertinoApp(
    debugShowCheckedModeBanner: false,
    supportedLocales: localization.supportedLocales.values,
    localizationsDelegates: localization.delegates,
    locale: localization.currentLocale,
    builder: defaultMediaQueryBuilder,
    home: Directionality(
      textDirection: Directionality.of(context),
      child: CupertinoPageScaffold(
        child: Center(child: child),
      ),
    ),
  );
}
