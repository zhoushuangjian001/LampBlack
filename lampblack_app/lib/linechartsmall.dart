import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lampblack_app/bgreseau.dart';

// ignore: must_be_immutable
class SmallLineChart extends StatelessWidget {

  Picture _bgReseau;
    // 初始配置
  List marks = ["2","4","6","8","10","12","14","16","18","20"];
  void initConfig (){
    Size size = Size(512, 340);
    _bgReseau = Reseau(marks, size).drawBgReseau();
  }

  @override
  Widget build(BuildContext context) {
    initConfig();
    return Center(
      child: Container(
        width: 512,
        height: 400,
        color: Colors.white38,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomPaint(
                    size: Size(150, 60),
                    painter: LineChartTopItemView("颗粒物浓度", Colors.red),
                  ),
                  CustomPaint(
                    size: Size(140, 60),
                    painter: LineChartTopItemView("油烟浓度", Colors.blue),
                  )
                ],
              ),
            ),
            CustomPaint(
              size: Size(512, 240),
              painter: LineChart(_bgReseau),
            )
          ],
        ),
      )
    );
  }
}

/// 折线图的顶部
class LineChartTopItemView extends CustomPainter {
  final String title;
  final Color color;
  LineChartTopItemView(this.title, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double lineWidth = 2;
    double height = size.height;
    double width = size.width;
    canvas.save();
    var paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;
    var p1 = Offset(10, height *0.5 - lineWidth *0.5);
    var p2 = Offset(60, height *0.5 - lineWidth *0.5);
    canvas.drawLine(p1, p2, paint);
    canvas.save();
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(35, height * 0.5 - lineWidth *0.5), 5, paint);
    canvas.restore();
    TextPainter textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(
        text: title,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black
        )
      )
      ..layout();
    double textpointX = width - 70;
    double textpointY = height *0.5 - textPainter.size.height *0.5;
    textPainter.paint(canvas, Offset(textpointX, textpointY));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


/// 折线图
class LineChart extends CustomPainter {
  Picture _bgReseau;
  LineChart(this._bgReseau);
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制网格背景图片
    canvas.drawPicture(_bgReseau);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}