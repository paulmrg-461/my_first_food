import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;
  const AppLogo({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Image.asset(
        'assets/images/logo_no_bg.png',
        height: size,
        fit: BoxFit.contain,
        color: color,
        colorBlendMode: color != null ? BlendMode.srcIn : null,
        errorBuilder: (context, e, _) => Icon(
          Icons.restaurant_rounded,
          size: size,
          color: color ?? const Color(0xFFE8677A),
        ),
      ),
    );
  }
}
