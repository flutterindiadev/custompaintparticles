import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomPaintScreen extends StatefulWidget {
  const CustomPaintScreen({super.key});

  @override
  State<CustomPaintScreen> createState() => _CustomPaintScreenState();
}

class _CustomPaintScreenState extends State<CustomPaintScreen>
    with SingleTickerProviderStateMixin {
  late List<Particle> particles;
  late List<Particle> particlesToRemove;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    particles = List.generate(1, (index) => Particle());
    particlesToRemove = List.empty(growable: true);
    _ticker = createTicker((elapsed) {
      for (var element in particlesToRemove) {
        particles.remove(element);
      }
      particles.add(Particle());
      setState(() {});
    });
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: CustomPaint(
        painter: CustompaintParticles(
            particles: particles, particlestoRemove: particlesToRemove),
      ),
    );
  }
}

class CustompaintParticles extends CustomPainter {
  List<Particle> particles;
  List<Particle> particlestoRemove;

  CustompaintParticles(
      {required this.particles, required this.particlestoRemove});
  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.setPosition(particle.x * size.width, particle.y * size.height);
      particle.update();
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        13,
        Paint()..color = Color.fromARGB(particle.opacity, 255, 255, 255),
      );
      if (particle.finished()) particlestoRemove.add(Particle());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  double x = 0.5;
  double y = 0.8;
  double vx = doubleInRange(-1, 1);
  double vy = doubleInRange(-5, -1);
  int opacity = 255;
  Particle();

  setPosition(double xPostion, double yPosition) {
    if (x < 1 && y < 1) {
      x = xPostion;
      y = yPosition;
    }
  }

  update() {
    x += vx;
    y += vy;
    opacity -= 3;
  }

  bool finished() {
    return opacity == 0;
  }
}

Random _random = Random();

double doubleInRange(num start, num end) =>
    _random.nextDouble() * (end - start) * start;
