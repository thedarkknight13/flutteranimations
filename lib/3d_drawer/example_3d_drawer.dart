import 'package:flutter/material.dart';
import 'dart:math' show pi;

class Example3dDrawer extends StatefulWidget {
  const Example3dDrawer({super.key});

  @override
  State<Example3dDrawer> createState() => _Example3dDrawerState();
}

class _Example3dDrawerState extends State<Example3dDrawer> {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      drawer: Material(
        child: Container(
          color: const Color(0xff24283b),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 80, top: 100),
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  'Item $index',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Drawer",
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.grey[800],
          elevation: 10,
        ),
        body: Container(
          color: const Color(0xff414868),
        ),
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;

  const MyDrawer({
    super.key,
    required this.child,
    required this.drawer,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late AnimationController _xControllerForChild;
  late Animation<double> _yRotationAnimationForChild;

  late AnimationController _xControllerForDrawer;
  late Animation<double> _yRotationAnimationForDrawer;

  @override
  void initState() {
    super.initState();
    _xControllerForChild = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _yRotationAnimationForChild = Tween<double>(
      begin: 0,
      end: -pi / 2,
    ).animate(_xControllerForChild);

    _xControllerForDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _yRotationAnimationForDrawer = Tween<double>(
      begin: pi / 2.7,
      end: 0,
    ).animate(_xControllerForDrawer);
  }

  @override
  void dispose() {
    _xControllerForChild.dispose();
    _xControllerForDrawer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.8;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final delta = details.delta.dx / maxDrag;
        _xControllerForChild.value += delta;
        _xControllerForDrawer.value += delta;
      },
      onHorizontalDragEnd: (details) {
        if (_xControllerForChild.value < 0.5) {
          _xControllerForChild.reverse();
          _xControllerForDrawer.reverse();
        } else {
          _xControllerForChild.forward();
          _xControllerForDrawer.forward();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _xControllerForChild,
          _xControllerForDrawer,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                color: const Color(0xff1a1b26),
              ),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(_xControllerForChild.value * maxDrag)
                  ..rotateY(_yRotationAnimationForChild.value),
                child: widget.child,
              ),
              Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(
                    -screenWidth + _xControllerForDrawer.value * maxDrag,
                  )
                  ..rotateY(_yRotationAnimationForDrawer.value),
                child: widget.drawer,
              ),
            ],
          );
        },
      ),
    );
  }
}
