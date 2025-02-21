import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _rippleController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _initializeParticles();

    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Ripple animation
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: Curves.easeOutCirc,
      ),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Start animations sequence
    _startAnimationSequence();
  }

  void _initializeParticles() {
    for (int i = 0; i < 30; i++) {
      _particles.add(Particle());
    }
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _rippleController.repeat();
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1200),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: const HomeScreen(),
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _rippleController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff017b4a),
      body: Stack(
        children: [
          // Animated particles
          ...List.generate(_particles.length, (index) {
            return AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final particle = _particles[index];
                final progress = _particleController.value;
                final offsetY = progress * MediaQuery.of(context).size.height;
                return Positioned(
                  left: particle.x,
                  top: (particle.y + offsetY) % MediaQuery.of(context).size.height,
                  child: Transform.rotate(
                    angle: progress * 2 * pi,
                    child: Container(
                      width: particle.size,
                      height: particle.size,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.transparent,
                  const Color(0xff017b4a).withOpacity(0.8),
                ],
              ),
            ),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo container
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Ripple effects
                            ...List.generate(
                              4,
                                  (index) => AnimatedBuilder(
                                animation: _rippleController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1 + (_rippleAnimation.value + index * 0.3) % 1,
                                    child: Container(
                                      width: 180,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(
                                            (1 - ((_rippleAnimation.value + index * 0.3) % 1)) * 0.25,
                                          ),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Logo container with glass effect
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: const Center(
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/logo.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Animated text with enhanced effects
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _textController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: _textController,
                    child: Column(
                      children: [
                        // Starbucks text with gradient and shadow
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Color(0xFFE0E0E0)],
                          ).createShader(bounds),
                          child: const Text(
                            "STARBUCKS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 15,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Tagline with animated gradient
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              Colors.white70,
                              Colors.white,
                              Colors.white70,
                            ],
                            stops: [
                              0.0,
                              _textController.value,
                              1.0,
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            "Good Coffee, Good Moments",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Enhanced loading indicator
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textController,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      // Rotating outer circle
                      RotationTransition(
                        turns: _rippleController,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.5),
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                      // Inner pulsing dot
                      Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.5, end: 1.0),
                          duration: const Duration(milliseconds: 1000),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Particle class for background animation
class Particle {
  final double x;
  final double y;
  final double size;

  Particle()
      : x = Random().nextDouble() * 400,
        y = Random().nextDouble() * 800,
        size = Random().nextDouble() * 4 + 1;
}