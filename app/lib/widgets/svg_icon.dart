import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String name;
  final Color? color;
  final double? size;

  const SvgIcon(
      this.name, {
        super.key,
        this.color,
        this.size,
      });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      name,
      width: size ?? IconTheme.of(context).size,
      height: size ?? IconTheme.of(context).size,
      colorFilter: ColorFilter.mode(
        color ?? IconTheme.of(context).color!,
        BlendMode.srcIn,
      ),
    );
  }
}