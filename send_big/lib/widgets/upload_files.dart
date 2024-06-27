import 'package:flutter/material.dart';
import 'dart:math' as math;

class UploadFiles extends StatelessWidget {
  const UploadFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Card(
          color: Colors.white,
          elevation: 8,
          child: Column(
            children: [
              Container(
                // height: 280,
                width: 280,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ]),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          CustomPaint(
                            painter: DashedBorderPainter(
                              strokeWidth: 1.0,
                              color: Colors.blue,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Image.asset('assets/images/files.png'),
                                  const Text('Add or drop your files here'),
                                  TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Or select a folder',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.blue,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                label: Text(
                                  'Your Email',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 75, 74, 74)),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                label: Text(
                                  'Email to',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 75, 74, 74)),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                label: Text(
                                  'Email message',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 75, 74, 74)),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    // color: Colors.blue
                                  ),
                                  child:
                                      Image.asset('assets/images/telegram.png'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.green,

                                    // color: Colors.blue
                                  ),
                                  child: const Text('More options',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 90,
                      left: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 7, 135, 240)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
    this.radius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double width = size.width;
    final double height = size.height;

    Path dashPath = Path();

    // Top line
    _drawDashedLine(dashPath, Offset(radius, 0), Offset(width - radius, 0));

    // Right line
    _drawDashedLine(
        dashPath, Offset(width, radius), Offset(width, height - radius));

    // Bottom line
    _drawDashedLine(
        dashPath, Offset(width - radius, height), Offset(radius, height));

    // Left line
    _drawDashedLine(dashPath, Offset(0, height - radius), Offset(0, radius));

    // Top-left corner
    _drawDashedArc(
        dashPath, Rect.fromLTWH(0, 0, radius * 2, radius * 2), 180, 90);

    // Top-right corner
    _drawDashedArc(dashPath,
        Rect.fromLTWH(width - radius * 2, 0, radius * 2, radius * 2), 270, 90);

    // Bottom-right corner
    _drawDashedArc(
        dashPath,
        Rect.fromLTWH(
            width - radius * 2, height - radius * 2, radius * 2, radius * 2),
        0,
        90);

    // Bottom-left corner
    _drawDashedArc(dashPath,
        Rect.fromLTWH(0, height - radius * 2, radius * 2, radius * 2), 90, 90);

    canvas.drawPath(dashPath, paint);
  }

  void _drawDashedLine(Path path, Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final unitX = dx / distance;
    final unitY = dy / distance;

    final dashCount = (distance / (dashWidth + dashSpace)).floor();
    final dashLength = distance / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final startFraction = i / dashCount;
      final endFraction = (i + dashWidth / dashLength) / dashCount;
      final dashStart = Offset(
        start.dx + unitX * (startFraction * distance),
        start.dy + unitY * (startFraction * distance),
      );
      final dashEnd = Offset(
        start.dx + unitX * (endFraction * distance),
        start.dy + unitY * (endFraction * distance),
      );

      path.moveTo(dashStart.dx, dashStart.dy);
      path.lineTo(dashEnd.dx, dashEnd.dy);
    }
  }

  void _drawDashedArc(
      Path path, Rect rect, double startAngle, double sweepAngle) {
    final double radius = rect.width / 2;
    final double circumference = 2 * math.pi * radius;
    final double dashCount =
        (circumference / (dashWidth + dashSpace)).floor().toDouble();
    final double anglePerDash = 360 / dashCount;

    for (double angle = startAngle;
        angle < startAngle + sweepAngle;
        angle += anglePerDash) {
      final double endAngle = math.min(
          angle + (dashWidth / circumference) * 360, startAngle + sweepAngle);
      path.addArc(rect, _degToRad(angle), _degToRad(endAngle - angle));
    }
  }

  double _degToRad(double deg) => deg * (math.pi / 180.0);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
