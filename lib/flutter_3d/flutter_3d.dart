import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:vector_math/vector_math_64.dart' show Vector3;

class Flutter3d extends StatefulWidget {
  const Flutter3d({super.key});

  @override
  State<Flutter3d> createState() => _Flutter3dState();
}

class _Flutter3dState extends State<Flutter3d> with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;

  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();

    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    _animation = Tween(
      begin: 0,
      end: pi * 2,
    );
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const widthAndHeight = 100.0;

    _xController
      ..reset()
      ..repeat();

    _yController
      ..reset()
      ..repeat();

    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: widthAndHeight,
              width: double.infinity,
            ),
            AnimatedBuilder(
              animation: Listenable.merge([
                _xController,
                _yController,
                _zController,
              ]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(_animation.evaluate(_xController))
                    ..rotateY(_animation.evaluate(_yController))
                    ..rotateZ(_animation.evaluate(_zController)),
                  child: Stack(
                    children: [
                      // back
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(Vector3(0, 0, -widthAndHeight)),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.purple,
                        ),
                      ),
                      // left
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(pi / 2),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.red,
                        ),
                      ),
                      // right
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(-pi / 2),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.blue,
                        ),
                      ),
                      // front
                      Container(
                        height: widthAndHeight,
                        width: widthAndHeight,
                        color: Colors.green,
                      ),
                      // top side
                      Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()..rotateX(-pi / 2),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.orange,
                        ),
                      ),
                      // bottom side
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(pi / 2),
                        child: Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
