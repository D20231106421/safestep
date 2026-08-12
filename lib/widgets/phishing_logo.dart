import 'package:flutter/material.dart';

class PhishingLogo extends StatelessWidget {
  final double size;

  const PhishingLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.2);
    final innerRadius = BorderRadius.circular(size * 0.17);

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.045),
      decoration: BoxDecoration(
        color: const Color(0xFF106452),
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A106452),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: innerRadius,
        child: Transform.scale(
          scale: 1.22,
          child: Image.asset(
            'assets/images/safestep_logo.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
