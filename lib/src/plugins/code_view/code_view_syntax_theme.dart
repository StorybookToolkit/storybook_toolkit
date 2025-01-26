import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme.dart';
import 'package:flutter/material.dart';

class CustomSyntaxHighlighterTheme {
  static AnySyntaxHighlighterTheme customTheme() => const AnySyntaxHighlighterTheme(
        classStyle: TextStyle(
          color: Color(0xffffffff),
        ),
        staticStyle: TextStyle(
          color: Color(0xfff582c3),
        ),
        constructor: TextStyle(
          color: Color(0xffffc66d),
        ),
        multilineComment: TextStyle(
          color: Color(0xffbbaeaa),
        ),
        comment: TextStyle(
          color: Color(0xffbbaeaa),
        ),
        keyword: TextStyle(
          color: Color(0xffcc7832),
          fontWeight: FontWeight.bold,
        ),
        identifier: TextStyle(
          color: Color(0xffffffff),
        ),
        private: TextStyle(
          color: Color(0xffffffff),
        ),
        function: TextStyle(
          color: Color(0xffc678dd),
        ),
        method: TextStyle(
          color: Color(0xffc884fb),
        ),
        number: TextStyle(
          color: Color(0xff8ba0e5),
        ),
        string: TextStyle(
          color: Color(0xff8ba0e5),
        ),
        operator: TextStyle(
          color: Color(0xffffffff),
        ),
        separator: TextStyle(
          color: Color(0xffffffff),
        ),
        fontFeatures: [FontFeature.slashedZero()],
        fontFamily: 'RobotoMono',
        letterSpacing: 0.1,
        decoration: BoxDecoration(color: Colors.transparent),
      );
}
