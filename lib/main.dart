import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(MyApp());
}

final double kBallSize = 8;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Scaffold(
          body: Stack(children: [
        ...List.generate(1000, (index) => Performance()),
        Positioned(
          bottom: 10,
          right: 10,
          left: 10,
          child:
              ElevatedButton(onPressed: () {}, child: Text("Increase by x10")),
        ),
      ])),
    );
  }
}

class Performance extends StatefulWidget {
  Performance({Key? key}) : super(key: key);

  @override
  _PerformanceState createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance>
    with TickerProviderStateMixin {
  Color color = Colors.transparent;
  late Ticker ticker;
  late Offset offset;
  Direction horizontalDirection = Direction.leftToRight;
  Direction verticalDirection = Direction.topToBottom;

  @override
  void initState() {
    super.initState();
    offset = Offset(
        Random().nextInt(MediaQuery.of(context).size.width.toInt()).toDouble(),
        Random()
            .nextInt(MediaQuery.of(context).size.height.toInt())
            .toDouble()
            .toDouble());

    ticker = Ticker((duration) {
      setState(() {
        offset = getOffset();
        color = getRandomColor();
      });
    });
    ticker.start();
  }

  Direction getRandomDirection() {
    return Direction.values[Random().nextInt(Direction.values.length)];
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(255),
      random.nextInt(255),
      random.nextInt(255),
    );
  }

  Offset getOffset() {
    Size size = MediaQuery.of(context).size;
    double dx = 0;
    double dy = 0;
    if (offset.dx < size.width &&
        horizontalDirection == Direction.leftToRight) {
      dx = offset.dx + 1;
    } else if (offset.dx >= 0.0 &&
        horizontalDirection == Direction.rightToLeft) {
      dx = offset.dx - 1;
    }

    if (offset.dy < size.height && verticalDirection == Direction.topToBottom) {
      dy = offset.dy + 1;
    } else if (offset.dy >= size.height &&
        verticalDirection == Direction.bottomToTop) {
      dy = offset.dy - 1;
    }
    return Offset(dx, dy);
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: CirclePainter(offset: offset, color: color));
  }
}

class CirclePainter extends CustomPainter {
  final Offset offset;
  final Color color;

  CirclePainter({required this.offset, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(offset, kBallSize, paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) =>
      oldDelegate.color != this.color || this.offset != oldDelegate.offset;

  @override
  bool shouldRebuildSemantics(CirclePainter oldDelegate) => false;
}

enum Direction { leftToRight, rightToLeft, bottomToTop, topToBottom }
