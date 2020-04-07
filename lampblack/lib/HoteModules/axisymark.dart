import 'package:flutter/material.dart';

class AxisYMark extends StatelessWidget {
  final List<String> marks;
  final Size size;
  AxisYMark(this.marks, this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        size: size,
        painter: DrawAxisMark(marks),
      ),
    );
  }
}

class DrawAxisMark extends CustomPainter {
  final List<String> marks;
  DrawAxisMark(this.marks);

  @override
  void paint(Canvas canvas, Size size) {
    // 顶部和底部固定偏移
    double setTop = 20;
    double setBottom = 40;
    // Y轴每次偏移
    double everyOffsetAxisY =
        (size.height - setTop - setBottom) * 1.0 / (marks.length - 1);
    canvas.save();
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    Offset p1 = Offset(size.width - 2, 0);
    Offset p2 = Offset(size.width - 2, size.height - setBottom);
    canvas.drawLine(p1, p2, paint);

    // 绘制刻度
    for (int i = 0; i < marks.length; i++) {
      TextPainter textPainter = TextPainter()
        ..textDirection = TextDirection.ltr
        ..text = TextSpan(text: marks[i], style: TextStyle(color: Colors.red))
        ..layout();
      Offset axis = Offset(size.width - textPainter.size.width - 5,
          setTop + i * everyOffsetAxisY - textPainter.size.height * 0.5);
      textPainter.paint(canvas, axis);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
