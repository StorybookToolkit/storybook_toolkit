import 'package:flutter/material.dart';
import 'package:storybook_toolkit/src/common/constants.dart';
import 'package:storybook_toolkit/src/common/custom_list_tile.dart';

class KnobListTile extends StatefulWidget {
  const KnobListTile({
    super.key,
    required this.enabled,
    required this.nullable,
    this.contentPadding,
    this.onToggled,
    this.title,
    this.subtitle,
    this.leading,
  });

  final bool enabled;
  final bool nullable;
  final EdgeInsetsGeometry? contentPadding;
  final ValueChanged<bool>? onToggled;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;

  @override
  State<KnobListTile> createState() => _KnobListTileState();
}

class _KnobListTileState extends State<KnobListTile> {
  @override
  Widget build(BuildContext context) {
    final onToggled = widget.onToggled != null ? () => widget.onToggled!(!widget.enabled) : null;

    return widget.nullable
        ? CustomListTile(
            isThreeLine: true,
            horizontalTitleGap: knobsHorizontalTitleGap,
            contentPadding: widget.contentPadding ?? defaultTilePadding,
            onTap: onToggled,
            leading: SizedBox(
              width: 32,
              child: Transform.scale(
                scale: 0.6,
                child: Switch(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: widget.enabled,
                  onChanged: widget.onToggled,
                ),
              ),
            ),
            title: IgnorePointer(
              key: const Key('knobListTile_ignorePointer_disableTitle'),
              ignoring: !widget.enabled,
              child: Opacity(
                opacity: widget.enabled ? 1 : 0.5,
                child: widget.title ?? const SizedBox.shrink(),
              ),
            ),
            subtitle: IgnorePointer(
              key: const Key('knobListTile_ignorePointer_disableSubtitle'),
              ignoring: !widget.enabled,
              child: Opacity(
                opacity: widget.enabled ? 1 : 0.5,
                child: widget.subtitle,
              ),
            ),
          )
        : CustomListTile(
            isThreeLine: false,
            horizontalTitleGap: knobsHorizontalTitleGap,
            contentPadding: widget.contentPadding ?? defaultTilePadding,
            onTap: onToggled,
            leading: widget.leading,
            title: widget.title,
            subtitle: widget.subtitle,
          );
  }
}
