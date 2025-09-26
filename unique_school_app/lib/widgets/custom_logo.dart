import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class CustomLogo extends StatelessWidget {
  final double size;
  final bool showGlow;
  final Color? primaryColor;
  final Color? backgroundColor;

  const CustomLogo({
    Key? key,
    this.size = 120,
    this.showGlow = false,
    this.primaryColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoColor = primaryColor ?? AppTheme.primaryBlue;
    final bgColor = backgroundColor ?? Colors.white;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(
          color: logoColor.withOpacity(0.2),
          width: 3,
        ),
        boxShadow: showGlow ? [
          BoxShadow(
            color: logoColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main school building icon
          Center(
            child: Icon(
              Icons.school_rounded,
              size: size * 0.5,
              color: logoColor,
            ),
          ),
          
          // Small graduation cap overlay
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: logoColor,
                border: Border.all(color: bgColor, width: 2),
              ),
              child: Icon(
                Icons.school,
                size: size * 0.12,
                color: bgColor,
              ),
            ),
          ),
          
          // Subtle text around the circle (optional)
          if (size >= 100)
            Positioned.fill(
              child: CustomPaint(
                painter: CircularTextPainter(
                  text: "UNIQUE SCHOOL SYSTEM",
                  color: logoColor.withOpacity(0.6),
                  fontSize: size * 0.08,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CircularTextPainter extends CustomPainter {
  final String text;
  final Color color;
  final double fontSize;

  CircularTextPainter({
    required this.text,
    required this.color,
    required this.fontSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    
    final textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 2,
    );
    
    final angleStep = (2 * 3.14159) / text.length;
    
    for (int i = 0; i < text.length; i++) {
      final angle = i * angleStep - 3.14159 / 2;
      final x = center.dx + radius * 0.8 * math.cos(angle);
      final y = center.dy + radius * 0.8 * math.sin(angle);
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + 3.14159 / 2);
      
      final textPainter = TextPainter(
        text: TextSpan(text: text[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Alternative simple logo design
class SimpleCustomLogo extends StatelessWidget {
  final double size;
  final Color? color;
  
  const SimpleCustomLogo({
    Key? key,
    this.size = 120,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppTheme.primaryBlue;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            logoColor,
            logoColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: logoColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.2),
              child: CustomPaint(
                painter: LogoPatternPainter(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_rounded,
                  size: size * 0.35,
                  color: Colors.white,
                ),
                SizedBox(height: size * 0.05),
                Text(
                  'U',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Corner accent
          Positioned(
            top: size * 0.1,
            right: size * 0.1,
            child: Container(
              width: size * 0.15,
              height: size * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogoPatternPainter extends CustomPainter {
  final Color color;
  
  LogoPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw subtle grid pattern
    for (int i = 0; i < 5; i++) {
      final x = (size.width / 4) * i;
      final y = (size.height / 4) * i;
      
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}