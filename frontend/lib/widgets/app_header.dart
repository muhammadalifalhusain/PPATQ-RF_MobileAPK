import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatefulWidget {
  final bool showBackButton;
  final bool showAuthButtons;

  const AppHeader({
    Key? key,
    this.showBackButton = false,
    this.showAuthButtons = true,
  }) : super(key: key);

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E), // Deep blue modern
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                'V1.1.17',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset('assets/images/logo.png', height: 60),
              ),
              if (widget.showBackButton)
                Positioned(
                  top: 0,
                  left: -10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 25),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Pondok Pesantren Anak-anak Tahfidzul Qur\'an Raudlatul Falah - Pati',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (widget.showAuthButtons)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  LoginScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color:  Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 2,
                              color: Colors.transparent,
                            ),
                          ),
                          child: CustomPaint(
                            painter: AnimatedBorderPainter(_animation.value),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.login, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            'Log In',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
          else
            const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class AnimatedBorderPainter extends CustomPainter {
  final double animationValue;

  AnimatedBorderPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );

    final path = Path()..addRRect(rect);
    final pathMetrics = path.computeMetrics().toList();
    
    if (pathMetrics.isNotEmpty) {
      final pathMetric = pathMetrics.first;
      final totalLength = pathMetric.length;
      final lightLength = totalLength * 0.25; 
      final startDistance = (totalLength * animationValue) % totalLength;
      
      // Create bright white gradient effect
      final shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.9),
          Colors.white,
          Colors.white.withOpacity(0.9),
          Colors.white.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.15, 0.3, 0.5, 0.7, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
      paint.shader = shader;
      
      final extractPath = pathMetric.extractPath(
        startDistance,
        (startDistance + lightLength) % totalLength,
      );
      
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}