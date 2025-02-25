import 'package:flutter/material.dart';

class ExampleImplicitAnimations extends StatefulWidget {
  const ExampleImplicitAnimations({super.key});

  @override
  State<ExampleImplicitAnimations> createState() =>
      _ExampleImplicitAnimationsState();
}

const _defaultWidth = 100.0;

class _ExampleImplicitAnimationsState extends State<ExampleImplicitAnimations> {
  var _isZoomedIn = false;
  var _buttonTitle = "Zoom In";
  var _width = _defaultWidth;
  var _curve = Curves.bounceOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Home Page"),
        ),
        elevation: 5,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 370),
                width: _width,
                curve: _curve,
                child: Image.asset("assets\\images\\wallpaper.jpg"),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isZoomedIn = !_isZoomedIn;
                _buttonTitle = _isZoomedIn ? "Zoom Out" : "Zoom In";
                _width = _isZoomedIn
                    ? MediaQuery.of(context).size.width
                    : _defaultWidth;
                _curve = _isZoomedIn ? Curves.easeInOut : Curves.bounceOut;
              });
            },
            child: Text(_buttonTitle),
          ),
        ],
      ),
    );
  }
}
