import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/theme.dart';

const _tabs = ['Smart Post', 'Library', 'Communities', 'Share&Win'];

/// Redesigned tab row — active tab gets an animated gradient underline that
/// glides between positions instead of a hard color swap.
class SmartTabRow extends StatefulWidget {
  const SmartTabRow({super.key, this.activeIndex = 0, this.onTap});

  final int activeIndex;
  final void Function(int index)? onTap;

  @override
  State<SmartTabRow> createState() => _SmartTabRowState();
}

class _SmartTabRowState extends State<SmartTabRow> {
  final _keys = List.generate(_tabs.length, (_) => GlobalKey());
  double? _left;
  double? _width;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(covariant SmartTabRow old) {
    super.didUpdateWidget(old);
    if (old.activeIndex != widget.activeIndex) _measure();
  }

  void _measure() {
    final box = _keys[widget.activeIndex].currentContext?.findRenderObject()
        as RenderBox?;
    final rowBox = context.findRenderObject() as RenderBox?;
    if (box == null || rowBox == null) return;
    final offset = box.localToGlobal(Offset.zero, ancestor: rowBox);
    if (mounted) {
      setState(() {
        _left = offset.dx;
        _width = box.size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < _tabs.length; i++)
                GestureDetector(
                  key: _keys[i],
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onTap == null
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          widget.onTap!(i);
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 12),
                    child: AnimatedDefaultTextStyle(
                      duration: Motion.base,
                      curve: Motion.smooth,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: i == widget.activeIndex
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: i == widget.activeIndex
                            ? AppColors.brandGreen
                            : dark
                                ? Colors.white
                                : AppColors.ink,
                      ),
                      child: Text(_tabs[i]),
                    ),
                  ),
                ),
            ],
          ),
          if (_left != null)
            AnimatedPositioned(
              duration: Motion.base,
              curve: Motion.smooth,
              left: _left,
              bottom: 2,
              child: Container(
                width: _width,
                height: 3,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
