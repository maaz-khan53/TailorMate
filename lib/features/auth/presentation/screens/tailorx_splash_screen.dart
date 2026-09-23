import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tailorx/features/dashboard/presentation/screens/dashboard_screen.dart';

/// TailorX Post-Login Splash
///
/// FLOW:
/// App Open
///   ↓
/// Login / Sign Up
///   ↓
/// Successful Login
///   ↓
/// TailorX Splash (~3 seconds)
///   ↓
/// Dashboard
///
/// Put this file at:
/// lib/features/auth/presentation/screens/tailorx_splash_screen.dart
///
/// IMPORTANT:
/// Do NOT use this as MaterialApp.home if you want Login to appear first.
/// After successful Login/Sign Up, navigate to this screen.
///
/// Example:
///
/// Navigator.of(context).pushReplacement(
///   MaterialPageRoute(
///     builder: (_) => const TailorXSplashScreen(),
///   ),
/// );

const Color _tailorBg = Color(0xFF03100C);
const Color _tailorBgMid = Color(0xFF0A2118);
const Color _tailorBgLight = Color(0xFF12382A);
const Color _tailorGold = Color(0xFFE5BD6F);
const Color _tailorGoldBright = Color(0xFFFFE4A6);
const Color _tailorCream = Color(0xFFF8F1E4);

class TailorXSplashScreen extends StatefulWidget {
  const TailorXSplashScreen({super.key});

  @override
  State<TailorXSplashScreen> createState() => _TailorXSplashScreenState();
}

class _TailorXSplashScreenState extends State<TailorXSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _particleController;
  late final AnimationController _threadController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _contentOpacityAnimation;
  late final Animation<Offset> _contentSlideAnimation;

  bool _openedDashboard = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    _threadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.28,
        curve: Curves.easeOut,
      ),
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.72,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.18,
          0.58,
          curve: Curves.elasticOut,
        ),
      ),
    );

    _contentOpacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.45,
        0.78,
        curve: Curves.easeOut,
      ),
    );

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.45,
          0.80,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _controller.forward();
    _threadController.forward();

    Future<void>.delayed(
      const Duration(seconds: 3),
      _openDashboard,
    );
  }

  void _openDashboard() {
    if (!mounted || _openedDashboard) return;

    _openedDashboard = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DashboardScreen();
        },
        transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
            ) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.035),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleController.dispose();
    _threadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _tailorBg,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _particleController,
          _threadController,
        ]),
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              const _LuxuryFabricBackground(),

              CustomPaint(
                painter: _ParticlesPainter(
                  progress: _particleController.value,
                ),
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 320,
                      height: 315,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(320, 315),
                            painter: _ThreadPainter(
                              progress: _threadController.value,
                            ),
                          ),

                          Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: const _TailorXLogo(),
                            ),
                          ),

                          Positioned(
                            bottom: 18,
                            child: Opacity(
                              opacity: _contentOpacityAnimation.value,
                              child: Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _tailorGold.withValues(
                                      alpha: 0.30,
                                    ),
                                  ),
                                  color: _tailorGold.withValues(
                                    alpha: 0.06,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.content_cut_rounded,
                                  color: _tailorGoldBright,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SlideTransition(
                      position: _contentSlideAnimation,
                      child: FadeTransition(
                        opacity: _contentOpacityAnimation,
                        child: const Column(
                          children: [
                            Text(
                              'CRAFTING YOUR STYLE',
                              style: TextStyle(
                                color: _tailorGoldBright,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 3.0,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Measure  •  Design  •  Stitch  •  Smile',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 28,
                right: 28,
                bottom: 42,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          minHeight: 3,
                          value: _controller.value,
                          backgroundColor: Colors.white.withValues(
                            alpha: 0.08,
                          ),
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(
                            _tailorGold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'OPENING YOUR ATELIER',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LuxuryFabricBackground extends StatelessWidget {
  const _LuxuryFabricBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.25,
          colors: [
            _tailorBgLight,
            _tailorBgMid,
            _tailorBg,
          ],
          stops: [
            0.0,
            0.48,
            1.0,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: -140,
            top: 100,
            child: Transform.rotate(
              angle: -0.18,
              child: Container(
                width: 480,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.025),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            right: -170,
            bottom: 120,
            child: Transform.rotate(
              angle: 0.22,
              child: Container(
                width: 500,
                height: 190,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _tailorGold.withValues(alpha: 0.035),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TailorXLogo extends StatelessWidget {
  const _TailorXLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 122,
          height: 122,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _tailorGold.withValues(alpha: 0.72),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: _tailorGold.withValues(alpha: 0.12),
                blurRadius: 38,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'T',
              style: TextStyle(
                color: _tailorGoldBright,
                fontSize: 72,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'TAILORX',
          style: TextStyle(
            color: _tailorCream,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: 6,
          ),
        ),
      ],
    );
  }
}

class _ThreadPainter extends CustomPainter {
  const _ThreadPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(size.width * 0.08, size.height * 0.14);

    path.cubicTo(
      size.width * 0.32,
      size.height * 0.00,
      size.width * 0.88,
      size.height * 0.12,
      size.width * 0.66,
      size.height * 0.34,
    );

    path.cubicTo(
      size.width * 0.46,
      size.height * 0.54,
      size.width * 0.92,
      size.height * 0.62,
      size.width * 0.78,
      size.height * 0.84,
    );

    path.cubicTo(
      size.width * 0.64,
      size.height * 1.02,
      size.width * 0.28,
      size.height * 0.94,
      size.width * 0.14,
      size.height * 0.78,
    );

    final metric = path.computeMetrics().first;

    final visiblePath = metric.extractPath(
      0,
      metric.length * progress.clamp(0.0, 1.0),
    );

    final glow = Paint()
      ..color = _tailorGold.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        9,
      );

    final thread = Paint()
      ..color = _tailorGoldBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(visiblePath, glow);
    canvas.drawPath(visiblePath, thread);

    if (progress > 0.02) {
      final tangent = metric.getTangentForOffset(
        metric.length * progress.clamp(0.0, 1.0),
      );

      if (tangent != null) {
        canvas.drawCircle(
          tangent.position,
          3.2,
          Paint()..color = _tailorGoldBright,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ThreadPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ParticlesPainter extends CustomPainter {
  const _ParticlesPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(23);

    for (int i = 0; i < 42; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      final y = baseY +
          math.sin(
            (progress * math.pi * 2) + i * 0.7,
          ) *
              8;

      final alpha = (0.025 +
          (math.sin(progress * math.pi * 2 + i) + 1) * 0.045)
          .clamp(0.015, 0.12);

      canvas.drawCircle(
        Offset(x, y),
        0.6 + random.nextDouble() * 1.5,
        Paint()
          ..color = _tailorGold.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
