import 'package:flutter/material.dart';

class _GradientOverlay extends StatelessWidget {
  final bool isLeft;

  const _GradientOverlay({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isLeft ? 0 : null,
      right: !isLeft ? 0 : null,
      top: 0,
      bottom: 0,
      width: 10,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            colors: [
              Colors.white,
              Colors.white.withAlpha(0),
            ],
          ),
        ),
      ),
    );
  }
}

class Marquee extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextDirection? textDirection;

  const Marquee({
    super.key,
    required this.text,
    this.style,
    this.textDirection,
  });

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  static const _blankSpace = 25.0;
  late ScrollController _scrollController;

  bool _activateMarquee = false;

  final _showLeftGradientOverlay = ValueNotifier(false);

  Size _getTextSize() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: widget.textDirection ?? TextDirection.ltr,
    )..layout();

    return textPainter.size;
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _showLeftGradientOverlay.value = _scrollController.position.pixels > 0 &&
          _scrollController.position.pixels < _getTextSize().width;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_scrollController.hasClients && _activateMarquee) {
        final position = _getTextSize().width + _blankSpace;
        const pixelsPerSecond = 15;

        await Future.delayed(const Duration(seconds: 1));

        while (true) {
          await _scrollController.animateTo(
            position,
            duration: Duration(
                milliseconds: (position / pixelsPerSecond * 1000).toInt()),
            curve: Curves.linear,
          );

          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }

          await Future.delayed(const Duration(seconds: 3));
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      widget.text,
      style: widget.style,
      maxLines: 1,
    );

    return LayoutBuilder(
      builder: (ctx, constraints) {
        _activateMarquee = _getTextSize().width > constraints.maxWidth;

        if (!_activateMarquee) {
          return textWidget;
        }

        return SizedBox(
          height: _getTextSize().height,
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, _) {
                  return Row(
                    children: [
                      textWidget,
                      const SizedBox(
                        width: _blankSpace,
                      )
                    ],
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: _showLeftGradientOverlay,
                builder: (_, showLeftGradientOverlay, __) =>
                showLeftGradientOverlay
                    ? const _GradientOverlay(isLeft: true)
                    : const SizedBox.shrink(),
              ),
              const _GradientOverlay(isLeft: false),
            ],
          ),
        );
      },
    );
  }
}
