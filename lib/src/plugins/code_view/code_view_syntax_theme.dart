import 'package:flutter/material.dart';
import 'package:flutter_syntax_highlighter/flutter_syntax_highlighter.dart';

class MyLightSyntaxTheme extends SyntaxColorSchema {
  const MyLightSyntaxTheme()
      : super(
    baseStyle: const Color(0xFF2B2B2B),
    lineNumberStyle: const Color(0xFFAAAAAA),
    keywordStyle: const Color(0xFF8959A8),
    specialKeywordStyle: const Color(0xFFAA5DCD),
    storageModifierStyle: const Color(0xFFAA5DCD),
    typeStyle: const Color(0xFF3E999F),
    functionStyle: const Color(0xFF4271AE),
    literalStyle: const Color(0xFF795E26),
    commentStyle: const Color(0xFF8E908C),
    punctuationStyle: const Color(0xFF2B2B2B),
    stringStyle: const Color(0xFF718C00),
    numberStyle: const Color(0xFF0992D6),
    bracket1Style: const Color(0xFF3E9F5E),
    bracket2Style: const Color(0xFFD67F00),
    bracket3Style: const Color(0xFFD64F4F),
    variableStyle: const Color(0xFF4271AE),
  );
}

class MyDarkSyntaxTheme extends SyntaxColorSchema {
  const MyDarkSyntaxTheme()
      : super(
    baseStyle: const Color(0xFFE0E0E0),
    lineNumberStyle: const Color(0xFF7F8C8D),
    keywordStyle: const Color(0xFF81A2BE),
    specialKeywordStyle: const Color(0xFFB294BB),
    storageModifierStyle: const Color(0xFFB294BB),
    typeStyle: const Color(0xFFF0C674),
    functionStyle: const Color(0xFF8ABEB7),
    literalStyle: const Color(0xFFDE935F),
    commentStyle: const Color(0xFF969896),
    punctuationStyle: const Color(0xFFE0E0E0),
    stringStyle: const Color(0xFFB5BD68),
    numberStyle: const Color(0xFFDE935F),
    bracket1Style: const Color(0xFFA0E8A5),
    bracket2Style: const Color(0xFFD5A0E8),
    bracket3Style: const Color(0xFFE8A0A0),
    variableStyle: const Color(0xFF8ABEB7),
  );
}
