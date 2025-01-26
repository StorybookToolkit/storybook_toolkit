import 'package:flutter/material.dart';

// Panel
const double panelWidth = 275.00;

// Container
const double containerHeight = 40.0;
const double focusedBorderWidth = 1.25;
const Radius radius = Radius.circular(8.0);
const BorderRadius borderRadius = BorderRadius.all(radius);

// Cursor
const double cursorWidth = 1.2;
const double cursorHeight = 17;
const Radius cursorRadius = Radius.circular(32);
const Color cursorColor = Colors.black87;

// Spacing
const double knobsHorizontalTitleGap = 12.0;
const double deviceFrameHorizontalTitleGap = 8.0;

// ListTile padding
const double defaultPaddingValue = 24.0;
const EdgeInsets defaultTilePadding = EdgeInsets.symmetric(horizontal: defaultPaddingValue);
const EdgeInsets deviceFrameTilePadding = EdgeInsets.symmetric(horizontal: 16.0);
const EdgeInsets inputKnobTilePadding = EdgeInsets.only(
  top: 8.0,
  bottom: 4.0,
  left: defaultPaddingValue,
  right: defaultPaddingValue,
);

// ListTile description padding
const EdgeInsets defaultDescriptionPadding = EdgeInsets.only(top: 2.0, bottom: 4.0);
const EdgeInsets deviceFrameDescriptionPadding = EdgeInsets.symmetric(vertical: 2.0);
const EdgeInsets inputKnobDescriptionPadding = EdgeInsets.only(top: 4.0);

// Padding
const EdgeInsets sliderPadding = EdgeInsets.symmetric(vertical: 2.0);
const EdgeInsets inputTextPadding = EdgeInsets.only(top: 2.0);


const sectionSeparator = '/';

typedef PathContext = ({String rootPath, String path, String file});
